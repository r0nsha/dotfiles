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
        "ts_ls",
        "cssls",
        "rust_analyzer",
        "lua_ls",
        "taplo",
        "unocss",
        "biome",
        "gopls",
        "gofumpt",
        "goimports",
        "golines",
      },
    },
  },
}
