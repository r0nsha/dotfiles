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

local severity_order = {
  vim.diagnostic.severity.ERROR,
  vim.diagnostic.severity.WARN,
  vim.diagnostic.severity.INFO,
  vim.diagnostic.severity.HINT,
}

local function get_highest_severity()
  local count = vim.diagnostic.count(0)

  for _, s in ipairs(severity_order) do
    if count[s] and count[s] > 0 then return s end
  end

  return nil
end

local function jump_prev()
  local severity = get_highest_severity()
  vim.diagnostic.jump({ count = vim.v.count1, severity = severity })
  return severity
end

local function jump_next()
  local severity = get_highest_severity()
  vim.diagnostic.jump({ count = -vim.v.count1, severity = severity })
  return severity
end

vim.keymap.set({ "n", "x" }, "[d", jump_prev, {
  desc = "Jump to the previous diagnostic (prioritized)",
})

vim.keymap.set({ "n", "x" }, "gj", function()
  if jump_prev() == nil then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gj", true, true, true), "n", true)
  end
end, {
  desc = "Jump to the previous diagnostic (prioritized)",
})

vim.keymap.set({ "n", "x" }, "]d", jump_next, {
  desc = "Jump to the next diagnostic (prioritized)",
})

vim.keymap.set({ "n", "x" }, "gk", function()
  if jump_next() == nil then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gk", true, true, true), "n", true)
  end
end, {
  desc = "Jump to the next diagnostic (prioritized)",
})

-- local icons = require("config.icons")
-- vim.diagnostic.config({
--   virtual_text = false,
--   virtual_lines = false,
--   signs = {
--     text = {
--       [vim.diagnostic.severity.HINT] = icons.hint,
--       [vim.diagnostic.severity.INFO] = icons.info,
--       [vim.diagnostic.severity.WARN] = icons.warning,
--       [vim.diagnostic.severity.ERROR] = icons.error,
--     },
--   },
-- })
-- local icons = require("config.icons")

-- vim.diagnostic.config({
--   virtual_text = { current_line = true },
--   virtual_lines = false,
--   signs = {
--     text = {
--       [vim.diagnostic.severity.HINT] = icons.hint,
--       [vim.diagnostic.severity.INFO] = icons.info,
--       [vim.diagnostic.severity.WARN] = icons.warning,
--       [vim.diagnostic.severity.ERROR] = icons.error,
--     },
--   },
-- })

-- local function enable_virtual_lines()
--   vim.notify("Virtual lines enabled")
--   vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
-- end

-- local function disable_virtual_lines()
--   vim.notify("Virtual lines disabled")
--   vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })
-- end

-- vim.keymap.set("n", "grl", function()
--   local config = vim.diagnostic.config() or {}
--   if config.virtual_lines then
--     disable_virtual_lines()
--   else
--     enable_virtual_lines()
--   end
-- end, { desc = "LSP: Toggle line diagnostics" })

-- vim.api.nvim_create_autocmd("User", {
--   group = require("augroup"),
--   pattern = "DiagnosticChanged",
--   callback = function()
--     if vim.diagnostic.count() == 0 then disable_virtual_lines() end
--   end,
-- })
