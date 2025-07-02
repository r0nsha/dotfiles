local utils = require("utils")

vim.diagnostic.config({
  virtual_text = { current_line = true },
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = utils.icons.hint,
      [vim.diagnostic.severity.INFO] = utils.icons.info,
      [vim.diagnostic.severity.WARN] = utils.icons.warning,
      [vim.diagnostic.severity.ERROR] = utils.icons.error,
    },
  },
})

local function enable_virtual_lines()
  vim.notify("Virtual lines enabled")
  vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
end

local function disable_virtual_lines()
  vim.notify("Virtual lines disabled")
  vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })
end

vim.keymap.set("n", "<leader>l", function()
  local config = vim.diagnostic.config() or {}
  if config.virtual_lines then
    disable_virtual_lines()
  else
    enable_virtual_lines()
  end
end, { desc = "LSP: Toggle line diagnostics" })

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("CustomDisableVirtualLines", { clear = true }),
  pattern = "DiagnosticChanged",
  callback = function()
    if vim.diagnostic.count() == 0 then
      disable_virtual_lines()
    end
  end,
})
