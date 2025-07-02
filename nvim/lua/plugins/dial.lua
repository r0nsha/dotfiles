return {
  "monaqa/dial.nvim",
  event = "VeryLazy",
  config = function()
    local map = require "dial.map"
    vim.keymap.set("n", "+", map.inc_normal, { desc = "Increment" })
    vim.keymap.set("n", "-", map.dec_normal, { desc = "Decrement" })

    vim.keymap.set("n", "g+", map.inc_gnormal, { desc = "Increment" })
    vim.keymap.set("n", "g-", map.dec_gnormal, { desc = "Decrement" })

    vim.keymap.set("v", "+", map.inc_visual, { desc = "Increment" })
    vim.keymap.set("v", "-", map.dec_visual, { desc = "Decrement" })

    vim.keymap.set("v", "g+", map.inc_gvisual, { desc = "Increment" })
    vim.keymap.set("v", "g-", map.dec_gvisual, { desc = "Decrement" })
  end,
}
