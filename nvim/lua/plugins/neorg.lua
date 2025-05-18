return {
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    config = function()
      -- add blink.cmp integration when https://github.com/nvim-neorg/neorg/issues/1603 is fixed
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          -- ["core.completion"] = {
          --   config = {
          --     engine = "blink.cmp",
          --   },
          -- },
          ["core.concealer"] = {},
          -- ["core.integrations.nvim-cmp"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                personal = "~/neorg/personal",
              },
            },
          },
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "norg",
        callback = function()
          vim.keymap.set("n", "gd", "<Plug>(neorg.esupports.hop.hop-link)", { buffer = true, desc = "Neorg: Hop Link" })
        end,
      })
    end,
  },
}
