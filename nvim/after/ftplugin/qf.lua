vim.keymap.set("n", "<CR>", function()
  local qflist = vim.fn.getqflist()
  local item = qflist[vim.fn.line(".")]

  if not item then return end

  vim.cmd("cclose")

  vim.cmd("e " .. vim.api.nvim_buf_get_name(item.bufnr))
  vim.fn.cursor(item.lnum, item.col)
end, { buffer = 0, silent = true })
