local Utils = {}

function Utils.is_macos() return vim.fn.has("macunix") == 1 end

---@param v boolean
function Utils.bool_to_enabled(v) return v and "enabled" or "disabled" end

---@param callback function
---@param timeout integer
---@return function | { cancel: function }
function Utils.debounce(callback, timeout)
  local timer = vim.uv.new_timer()

  if not timer then return callback end

  local t = {}

  setmetatable(t, {
    __call = function(_, ...)
      local argv = { ... }
      timer:stop()
      timer:start(timeout, 0, function()
        timer:stop()
        callback(unpack(argv))
      end)
    end,
  })

  t.cancel = function() timer:stop() end

  return t
end

---@return integer, integer
function Utils.get_visual_range()
  local start_line = vim.fn.line("v") - 1
  local end_line = vim.fn.line(".") - 1
  if start_line > end_line then
    return end_line, start_line
  else
    return start_line, end_line
  end
end

Utils.pack = {}

--- Calls vim.pack.add, making sure that `build` is called after
--- the package is installed or updated.
---@param src string
---@param build fun(ev: vim.api.keyset.create_autocmd.callback_args): nil
function Utils.pack.add_with_build(src, build)
  vim.api.nvim_create_autocmd("PackChanged", {
    once = true,
    callback = function(ev)
      local _src, name, kind = ev.data.spec.src, ev.data.spec.name, ev.data.kind
      if src == _src and (kind == "install" or kind == "update") then
        if not ev.data.active then vim.cmd.packadd(name) end
        build(ev)
      end
    end,
  })

  vim.pack.add({ { src = src } })
end

Utils.pack.src = {
  ---@param repo string
  ---@return string
  gh = function(repo) return "https://github.com/" .. repo end,

  ---@param repo string
  ---@return string
  tngl = function(repo) return "https://tangled.org/" .. repo end,

  ---@param repo string
  ---@return string
  cb = function(repo) return "https://codeberg.org/" .. repo end,
}

return Utils
