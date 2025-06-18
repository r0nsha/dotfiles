return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      build = function()
        pcall(vim.cmd, "MasonToolsUpdate")
      end,
    },
    "stevearc/conform.nvim",
    "saghen/blink.cmp",
    "b0o/schemastore.nvim",
    {
      "aznhe21/actions-preview.nvim",
      opts = {
        backend = { "snacks" },
        snacks = {
          layout = require("plugins.snacks").ivy_cursor,
        },
      },
      config = true,
    },
  },
  config = function()
    require "plugins.lsp.servers"
    require "plugins.lsp.attach"
    require "plugins.lsp.diagnostic"
    require "plugins.lsp.progress"
  end,
}
