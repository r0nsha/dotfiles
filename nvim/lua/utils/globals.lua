---@generic T
---
---@param v T
---@return T
function _G.dbg(v)
  vim.notify(vim.inspect(v))
  return v
end
