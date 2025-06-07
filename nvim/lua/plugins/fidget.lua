return {
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {
        notification = {
          override_vim_notify = true,
          configs = {
            default = vim.tbl_deep_extend("force", require("fidget.notification").default_config, {
              icon = "",
            }),
          },
          view = {
            group_separator = " ",
          },
          window = {
            winblend = 0,
            x_padding = 1,
            y_padding = 0,
            border = "single",
            align = "bottom",
            relative = "editor",
          },
        },
      }
    end,
  },
}
