local M = {}

function M.is_macos()
  return vim.fn.has "macunix" == 1
end

---@param v boolean
function M.bool_to_enabled(v)
  return v and "enabled" or "disabled"
end

---@param callback function
---@param timeout number
---@return function | { cancel: function }
function M.debounce(callback, timeout)
  local timer = vim.uv.new_timer()

  if not timer then
    return callback
  end

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

  t.cancel = function()
    timer:stop()
  end

  return t
end

return M
