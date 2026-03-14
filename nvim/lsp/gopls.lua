---@type vim.lsp.Config
return {
  ---@type lspconfig.settings.gopls
  settings = {
    gopls = {
      env = {
        GOEXPERIMENT = "rangefunc",
      },
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}
