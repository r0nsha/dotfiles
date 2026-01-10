local ss = require("smart-splits")
ss.setup({})

-- move
vim.keymap.set({ "n", "t" }, "<C-h>", ss.move_cursor_left, { desc = "Move cursor left" })
vim.keymap.set({ "n", "t" }, "<C-j>", ss.move_cursor_down, { desc = "Move cursor down" })
vim.keymap.set({ "n", "t" }, "<C-k>", ss.move_cursor_up, { desc = "Move cursor up" })
vim.keymap.set({ "n", "t" }, "<C-l>", ss.move_cursor_right, { desc = "Move cursor right" })
vim.keymap.set({ "n", "t" }, "<C-\\>", ss.move_cursor_previous, { desc = "Move cursor previous" })

-- resize
vim.keymap.set({ "n", "t" }, "<A-h>", ss.resize_left, { desc = "Resize left" })
vim.keymap.set({ "n", "t" }, "<A-j>", ss.resize_down, { desc = "Resize down" })
vim.keymap.set({ "n", "t" }, "<A-k>", ss.resize_up, { desc = "Resize up" })
vim.keymap.set({ "n", "t" }, "<A-l>", ss.resize_right, { desc = "Resize right" })
