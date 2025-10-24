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
      require("plugins.lsp.servers")
      require("plugins.lsp.attach")
      require("plugins.lsp.diagnostic")
      require("plugins.lsp.progress")
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
}
