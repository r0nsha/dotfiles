-------------------------------------------------------
-- Extensions
-------------------------------------------------------

-- string
---@param sub string
---@return boolean
function string:contains(sub) return tostring(self):find(sub, 1, true) ~= nil end

---@param start string
---@return boolean
function string:startswith(start) return tostring(self):sub(1, #start) == start end

-------------------------------------------------------
-- Globals
-------------------------------------------------------

---@generic T
---
---@param v T
---@return T
function _G.dbg(v)
  vim.schedule(function() print(vim.inspect(v)) end)
  return v
end
