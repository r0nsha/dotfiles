---@module "lazy"
---@type LazySpec
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      checkbox = {
        checked = { icon = " ", highlight = "RenderMarkdownChecked", scope_highlight = nil },
        unchecked = { icon = " ", highlight = "RenderMarkdownUnchecked", scope_highlight = nil },
        custom = {
          in_progress = { raw = "[-]", rendered = " ", highlight = "RenderMarkdownBullet", scope_highlight = nil },
          cancelled = { raw = "[/]", rendered = "󱋭 ", highlight = "RenderMarkdownError", scope_highlight = nil },
        },
      },
      code = {
        conceal_delimiters = false,
      },
    },
  },
}
