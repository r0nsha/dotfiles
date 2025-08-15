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
      keys = {
        ["<c-x>"] = {
          rhs = "<cmd>Checkmate cycle_next<CR>",
          desc = "Toggle todo item",
          modes = { "n", "v" },
        },
        ["<a-x>"] = {
          rhs = "<cmd>Checkmate create<CR>",
          desc = "Create todo item",
          modes = { "n", "v" },
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
