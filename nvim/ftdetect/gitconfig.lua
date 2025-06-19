vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*/git/config",
  callback = function()
    vim.cmd "set ft=gitconfig"
  end,
})
