vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  once = true,
  callback = function()
    require("typst-preview").setup({
      invert_colors = "auto",
      follow_cursor = true,
    })
  end,
})
