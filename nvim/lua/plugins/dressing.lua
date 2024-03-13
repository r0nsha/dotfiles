return {
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup {
        input = {
          prompt_align = "left",
          insert_only = false,
          start_in_insert = true,
          win_options = {
            winblend = 0,
            wrap = false,
          },
        },
        -- select = {
        --   telescope = require("telescope.themes").get_cursor(),
        -- },
      }
    end,
  },
}
