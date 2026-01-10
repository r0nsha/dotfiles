local win_config = function()
  local has_statusline = vim.o.laststatus > 0
  local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
  return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - pad }
end

require("mini.notify").setup({
  lsp_progress = { duration_last = 1500 },
  window = { config = win_config },
})
