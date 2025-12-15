return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "stevearc/conform.nvim",
      "saghen/blink.cmp",
      "b0o/schemastore.nvim",
      {
        "aznhe21/actions-preview.nvim",
        opts = {
          backend = { "snacks" },
          snacks = {
            layout = require("plugins.snacks.picker").ivy_cursor,
          },
        },
        config = true,
      },
    },
    config = function()
      require "plugins.lsp.servers"
      require "plugins.lsp.attach"
      require "plugins.lsp.progress"
      -- Replaced with tiny-inline-diagnostic.nvim
      -- require "plugins.lsp.diagnostic"
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        init_options = {
          preferences = {
            importModuleSpecifierPreference = "relative",
          },
        },
      },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup {
        preset = "minimal",
        transparent_bg = true,
        transparent_cursorline = false,
        options = {
          show_source = { enabled = true },
          use_icons_from_diagnostic = false,
          multilines = {
            enabled = true,
            always_show = false,
            trim_whitespaces = true,
          },
          show_all_diags_on_cursorline = false,
        },
      }

      -- Disable Neovim's default virtual text diagnostics
      vim.diagnostic.config { virtual_text = false }

      local icons = require "config.icons"
      vim.diagnostic.config {
        virtual_text = false,
        virtual_lines = false,
        signs = {
          text = {
            [vim.diagnostic.severity.HINT] = icons.hint,
            [vim.diagnostic.severity.INFO] = icons.info,
            [vim.diagnostic.severity.WARN] = icons.warning,
            [vim.diagnostic.severity.ERROR] = icons.error,
          },
        },
      }
    end,
  },
}
