return {
  "folke/which-key.nvim",
  enabled = false,
  event = "VeryLazy",
  config = function()
    require("which-key").setup({
      preset = "helix",
      show_help = false,
      win = {
        no_overlap = true,
        width = 45,
        height = { min = 4, max = 20 },
        border = "single",
      },
    })
  end,
}
