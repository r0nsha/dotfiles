local csvview = require("csvview")
local buf = vim.api.nvim_get_current_buf()

csvview.enable(buf)
vim.notify("Enabled CSV View automatically")

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = buf })
end

map("n", "<leader>vv", function()
  csvview.toggle(buf)
end, "CSV View: Toggle")

map("n", "<leader>ve", function()
  csvview.enable(buf)
end, "CSV View: Toggle")

map("n", "<leader>vd", function()
  csvview.disable(buf)
end, "CSV View: Toggle")
