vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  once = true,
  callback = function()
    require("render-markdown").setup({
      completions = { lsp = { enabled = true } },
      checkbox = {
        checked = { icon = " ", highlight = "RenderMarkdownChecked", scope_highlight = nil },
        unchecked = { icon = " ", highlight = "RenderMarkdownUnchecked", scope_highlight = nil },
        custom = {
          in_progress = { raw = "[-]", rendered = " ", highlight = "RenderMarkdownBullet", scope_highlight = nil },
          cancelled = { raw = "[/]", rendered = "󱋭 ", highlight = "RenderMarkdownError", scope_highlight = nil },
        },
      },
      code = {
        render_modes = true,
        conceal_delimiters = false,
        border = "thin",
      },
      html = {
        render_modes = true,
        comment = {
          conceal = true,
          text = function(ctx) return ctx.text:match("^<!%-%-%s*(.-)%s*%-%->$") end,
        },
      },
    })
  end,
})
