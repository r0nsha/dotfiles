-- Execute current buffer
vim.keymap.set("n", "<C-x>", "<cmd>.lua<cr>", { desc = "Execute line", buffer = 0 })
vim.keymap.set("x", "<C-x>", "<cmd>'<,'>lua<cr>", { desc = "Execute visual selection", buffer = 0 })
