---@type vim.lsp.Config
return {
  ---@type lspconfig.settings.gopls
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}
