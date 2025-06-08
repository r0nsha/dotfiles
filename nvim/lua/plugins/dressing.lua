return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  config = function()
    require("dressing").setup {
      input = {
        prompt_align = "left",
        start_mode = "normal",
        border = "single",
      },
    }
  end,
}
