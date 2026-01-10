local Utils = {}

function Utils.is_macos() return vim.fn.has("macunix") == 1 end

---@param v boolean
function Utils.bool_to_enabled(v) return v and "enabled" or "disabled" end

---@param callback function
---@param timeout number
---@return function | { cancel: function }
function Utils.debounce(callback, timeout)
  local timer = vim.uv.new_timer()

  if not timer then return callback end

  local t = {}

  setmetatable(t, {
    __call = function(_, ...)
      local argv = { ... }
      timer:start(timeout, 0, function()
        timer:stop()
        callback(unpack(argv))
      end)
    end,
  })

  t.cancel = function() timer:stop() end

  return t
end

---@return number, number
function Utils.get_visual_range()
  local start_line = vim.fn.line("v") - 1
  local end_line = vim.fn.line(".") - 1
  if start_line > end_line then
    return end_line, start_line
  else
    return start_line, end_line
  end
end

return Utils
