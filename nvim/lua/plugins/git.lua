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
    event = { "BufRead", "BufNewFile" },
    config = function()
      local gitsigns = require "gitsigns"

      gitsigns.setup {
        -- signs = {
        --   add = { text = "+" },
        --   change = { text = "~" },
        --   delete = { text = "_" },
        --   topdelete = { text = "‾" },
        --   changedelete = { text = "~" },
        -- },
        current_line_blame = true,
        on_attach = function(bufnr)
          vim.keymap.set("n", "[c", require("gitsigns").prev_hunk, { buffer = bufnr, desc = "Go to Previous Hunk" })
          vim.keymap.set("n", "]c", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Go to Next Hunk" })
          vim.keymap.set(
            "n",
            "<leader>ph",
            require("gitsigns").preview_hunk,
            { buffer = bufnr, desc = "[P]review [H]unk" }
          )
          vim.keymap.set("n", "<leader>gB", function()
            gitsigns.blame_line { full = true }
          end, { buffer = bufnr, desc = "Git blame line (Full)" })
        end,
      }
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
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
