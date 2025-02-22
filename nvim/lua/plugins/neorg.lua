return {
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.concealer"] = {},
          ["core.integrations.nvim-cmp"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                personal = "~/neorg/personal",
              },
            },
          },
        },
      }
    end,
  },
}
