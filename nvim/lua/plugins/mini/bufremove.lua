local br = require("mini.bufremove")
br.setup({})

vim.keymap.set("n", "<leader>bd", br.delete, { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bD", function() br.delete(0, true) end, { desc = "Delete buffer (force)" })
