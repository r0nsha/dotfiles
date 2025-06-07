return {
  "Wansmer/treesj",
  keys = {
    {
      "<leader>j",
      function()
        require("treesj").toggle()
      end,
      desc = "Toggle Split/Join",
    },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup {
      use_default_keymaps = false,
      max_join_length = 9000,
    }
  end,
}
