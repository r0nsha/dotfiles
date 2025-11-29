return {
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
