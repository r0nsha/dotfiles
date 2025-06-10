return {
  "folke/flash.nvim",
  event = "VeryLazy",
  config = function()
    local flash = require "flash"
    flash.setup {}

    vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash" })
    vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash Treesitter" })
    vim.keymap.set({ "o" }, "r", flash.remote, { desc = "Remote Flash" })
    vim.keymap.set({ "o", "x" }, "R", flash.treesitter_search, { desc = "Treesitter Search" })
    vim.keymap.set({ "c" }, "<c-s>", flash.toggle, { desc = "Toggle Flash Search" })
  end,
}
