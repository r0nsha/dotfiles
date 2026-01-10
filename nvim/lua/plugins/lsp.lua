require("plugins.lsp.servers")
require("plugins.lsp.attach")

-- Replaced with tiny-inline-diagnostic.nvim
-- require "plugins.lsp.diagnostic"

require("tiny-inline-diagnostic").setup({
  preset = "minimal",
  transparent_bg = true,
  transparent_cursorline = false,
  options = {
    show_source = { enabled = true },
    use_icons_from_diagnostic = false,
    multilines = {
      enabled = true,
      always_show = false,
      trim_whitespaces = true,
    },
    show_all_diags_on_cursorline = false,
  },
})

local icons = require("config.icons")
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = icons.hint,
      [vim.diagnostic.severity.INFO] = icons.info,
      [vim.diagnostic.severity.WARN] = icons.warning,
      [vim.diagnostic.severity.ERROR] = icons.error,
    },
  },
})
