return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local treesj = require("treesj")

    treesj.setup({
      use_default_keymaps = false,
      max_join_length = 9000,
    })

    vim.keymap.set({ "n", "v" }, "<leader>j", treesj.toggle, { desc = "Toggle Split/Join" })
  end,
}
