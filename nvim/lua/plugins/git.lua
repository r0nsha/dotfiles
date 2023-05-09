return {
  {
    "dinhhuy258/git.nvim",
    event = "VeryLazy",
    config = function()
      require("git").setup {
        keymaps = {
          default_mappings = false,
          keymaps = {
            blame = "<leader>gb",
            quit_blame = "q",
            blame_commit = "<cr>",
            browse = "<leader>go",
            open_pull_request = "<leader>gp",
            create_pull_request = "<leader>gn",
            revert = "<leader>gr",
            revert_file = "<leader>gR",
          },
          target_branch = "master",
        },
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    config = function()
      local gitsigns = require "gitsigns"

      gitsigns.setup {
        current_line_blame = true,
      }

      vim.keymap.set("n", "<leader>gB", function()
        gitsigns.blame_line { full = true }
      end, { remap = false, silent = false })
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufRead",
    config = function()
      require("git-conflict").setup()
      vim.keymap.set("n", "<leader>gl", "<cmd>GitConflictListQf<cr>")
    end,
  },
  {
    "TimUntersberger/neogit",
    keys = {
      { "<leader>gs", "<cmd>Neogit kind=split<cr>" },
    },
    config = function()
      require("neogit").setup {
        kind = "tab",
        integrations = { diffview = true },
        disable_insert_on_commit = false,
        disable_commit_confirmation = true,
        disable_builtin_notifications = true,
      }
    end,
    dependencies = {
      {
        "sindrets/diffview.nvim",
        keys = {
          { "<leader>gd", "<cmd>DiffviewOpen<cr>" },
          { "<leader>gD", "<cmd>DiffviewClose<cr>" },
        },
      },
    },
  },
}
