vim.api.nvim_create_autocmd({ "BufRead" }, {
  group = require("augroup"),
  pattern = "Cargo.toml",
  callback = function()
    require("crates").setup({
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    })
  end,
})
