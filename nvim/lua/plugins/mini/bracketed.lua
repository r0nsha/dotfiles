local br = require "mini.bracketed"

br.setup()

vim.keymap.set("n", "<leader>bd", function()
  br.delete(0, false)
end, { desc = "Buffer: Delete" })

vim.keymap.set("n", "<leader>bD", function()
  br.delete(0, true)
end, { desc = "Buffer: Delete (Force)" })
