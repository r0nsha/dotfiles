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
