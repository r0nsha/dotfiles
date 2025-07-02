return {
  "mrjones2014/smart-splits.nvim",
  config = function()
    local ss = require("smart-splits")
    ss.setup({})

    -- move
    vim.keymap.set("n", "<C-h>", ss.move_cursor_left, { desc = "Move cursor left" })
    vim.keymap.set("n", "<C-j>", ss.move_cursor_down, { desc = "Move cursor down" })
    vim.keymap.set("n", "<C-k>", ss.move_cursor_up, { desc = "Move cursor up" })
    vim.keymap.set("n", "<C-l>", ss.move_cursor_right, { desc = "Move cursor right" })
    vim.keymap.set("n", "<C-\\>", ss.move_cursor_previous, { desc = "Move cursor previous" })

    -- resize
    vim.keymap.set("n", "<A-h>", ss.resize_left, { desc = "Resize left" })
    vim.keymap.set("n", "<A-j>", ss.resize_down, { desc = "Resize down" })
    vim.keymap.set("n", "<A-k>", ss.resize_up, { desc = "Resize up" })
    vim.keymap.set("n", "<A-l>", ss.resize_right, { desc = "Resize right" })

    -- swap
    vim.keymap.set("n", "<A-H>", ss.swap_buf_left, { desc = "Swap buffer left" })
    vim.keymap.set("n", "<A-J>", ss.swap_buf_down, { desc = "Swap buffer down" })
    vim.keymap.set("n", "<A-K>", ss.swap_buf_up, { desc = "Swap buffer up" })
    vim.keymap.set("n", "<A-L>", ss.swap_buf_right, { desc = "Swap buffer right" })
  end,
}
