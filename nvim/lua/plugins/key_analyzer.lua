return {
  "meznaric/key-analyzer.nvim",
  cmd = "KeyAnalyzer",
  config = function()
    require("key-analyzer").setup {
      layout = "qwerty",
      promotion = false,
    }
  end,
}
