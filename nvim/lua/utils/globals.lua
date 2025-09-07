---@generic T
---
---@param v T
---@return T
function _G.dbg(v)
  vim.schedule(function()
    vim.notify(vim.inspect(v))
  end)
  return v
end

---@param f function
function _G.without_notify(f)
  local real_notify = vim.notify
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify = function(...) end
  f()
  vim.notify = real_notify
end
