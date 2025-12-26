-- Execute current buffer
vim.keymap.set("n", "X", "<cmd>.lua<cr>", { desc = "Execute line", buffer = 0 })
vim.keymap.set("x", "X", "<cmd>'<,'>lua<cr>", { desc = "Execute visual selection", buffer = 0 })
vim.keymap.set("n", "<leader>X", "<cmd>so<cr>", { desc = "Execute buffer", buffer = 0 })
