return {
  "Goose97/timber.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("timber").setup({
      highlight = {
        duration = 40,
      },
    })
  end,
}
