return {
  "julienvincent/hunk.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require("hunk").setup()
  end,
}
