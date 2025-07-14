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
      todo_markers = {
        unchecked = "[ ]",
        checked = "[x]",
      },
      keys = {
        ["<c-x>"] = {
          rhs = "<cmd>Checkmate toggle<CR>",
          desc = "Toggle todo item",
          modes = { "n", "v" },
        },
        ["<leader>Tt"] = {
          rhs = "<cmd>Checkmate toggle<CR>",
          desc = "Toggle todo item",
          modes = { "n", "v" },
        },
        ["<leader>Tc"] = {
          rhs = "<cmd>Checkmate check<CR>",
          desc = "Set todo item as checked (done)",
          modes = { "n", "v" },
        },
        ["<leader>Tu"] = {
          rhs = "<cmd>Checkmate uncheck<CR>",
          desc = "Set todo item as unchecked (not done)",
          modes = { "n", "v" },
        },
        ["<leader>Tn"] = {
          rhs = "<cmd>Checkmate create<CR>",
          desc = "Create todo item",
          modes = { "n", "v" },
        },
        ["<leader>Ta"] = {
          rhs = "<cmd>Checkmate archive<CR>",
          desc = "Archive checked/completed todo items (move to bottom section)",
          modes = { "n" },
        },
      },
    },
  },
}
