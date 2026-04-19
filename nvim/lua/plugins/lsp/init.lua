require("plugins.lsp.servers")
require("plugins.lsp.attach")

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

-- Replaced with tiny-inline-diagnostic.nvim
-- local function enable_virtual_lines()
--   vim.notify("Virtual lines enabled")
--   vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
-- end
--
-- local function disable_virtual_lines()
--   vim.notify("Virtual lines disabled")
--   vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })
-- end
--
-- vim.keymap.set("n", "grl", function()
--   local config = vim.diagnostic.config() or {}
--   if config.virtual_lines then
--     disable_virtual_lines()
--   else
--     enable_virtual_lines()
--   end
-- end, { desc = "LSP: Toggle line diagnostics" })
--
-- vim.api.nvim_create_autocmd("User", {
--   group = require("augroup"),
--   pattern = "DiagnosticChanged",
--   callback = function()
--     if vim.diagnostic.count() == 0 then disable_virtual_lines() end
--   end,
-- })
