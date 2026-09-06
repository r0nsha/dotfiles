require("tiny-inline-diagnostic").setup({
  preset = "classic",
  transparent_bg = true,
  options = {
    show_source = { enabled = true, if_many = true },
    multilines = { enabled = true, trim_whitespaces = true },
    overflow = { mode = "wrap", padding = 10 },
    override_open_float = true,
    experimental = {
      use_window_local_extmarks = true,
    },
  },
  signs = {
    left = "",
    right = "",
    diag = "*",
    arrow = "  ",
  },
  blend = { factor = 0.22 },
})
vim.diagnostic.config({ virtual_text = false })

vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextBg", { bg = "none" })
