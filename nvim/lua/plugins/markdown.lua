---@module "lazy"
---@type LazySpec
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
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
  {
    "bngarren/checkmate.nvim",
    ft = { "markdown", "codecompanion" },
    opts = {
      todo_states = {
        unchecked = { marker = "󰄱", order = 1 },
        checked = { marker = "󰄲", order = 2 },
        cancelled = { marker = "󱋭", markdown = "/", type = "complete", order = 3 },
      },
      smart_toggle = {
        check_down = "all_children",
        uncheck_down = "none",
        check_up = "all_children",
        uncheck_up = "all_children",
      },
      keys = {
        ["<c-x>"] = {
          rhs = "<cmd>Checkmate toggle<CR>",
          desc = "Toggle todo item",
          modes = { "n", "x" },
        },
        ["<a-x>"] = {
          rhs = "<cmd>Checkmate create<CR>",
          desc = "Create todo item",
          modes = { "n", "x" },
        },
        ["<a-a>"] = {
          rhs = "<cmd>Checkmate archive<CR>",
          desc = "Archive completed todo items",
          modes = { "n" },
        },
      },
    },
  },
}
