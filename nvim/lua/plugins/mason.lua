return {
  {
    "williamboman/mason.nvim",
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = {
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
      "MasonToolsClean",
    },
    opts = {
      ensure_installed = {
        "typescript-language-server",
        "prettierd",
        "biome",
        "css-lsp",
        "unocss-language-server",
        "rust-analyzer",
        "taplo",
        "lua-language-server",
        "stylua",
        "shfmt",
        "yamlfmt",
        "xmlformatter",
        "clang-format",
        "gopls",
        "gofumpt",
        "goimports",
        "goimports-reviser",
        "golines",
        "delve",
        "codespell",
      },
    },
  },
  build = function()
    pcall(vim.cmd, "MasonToolsUpdate")
  end,
}
