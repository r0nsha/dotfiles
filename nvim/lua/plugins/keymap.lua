return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup {
        preset = "helix",
      }
    end,
  },
  {
    "meznaric/key-analyzer.nvim",
    cmd = "KeyAnalyzer",
    config = function()
      require("key-analyzer").setup {
        layout = "qwerty",
        promotion = false,
      }
    end,
  },
}
