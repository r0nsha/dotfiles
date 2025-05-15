return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    config = function()
      local gitsigns = require "gitsigns"

      gitsigns.setup {
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true,
        on_attach = function(bufnr)
          vim.keymap.set("n", "[h", function()
            require("gitsigns").nav_hunk("prev", { preview = true })
          end, { buffer = bufnr, desc = "Git: Previous Hunk" })

          vim.keymap.set("n", "]h", function()
            require("gitsigns").nav_hunk("next", { preview = true })
          end, { buffer = bufnr, desc = "Git: Next Hunk" })

          vim.keymap.set(
            "n",
            "<leader>gp",
            require("gitsigns").preview_hunk,
            { buffer = bufnr, desc = "Git: Preview Hunk" }
          )

          vim.keymap.set("n", "<leader>gb", function()
            gitsigns.blame_line { full = true }
          end, { buffer = bufnr, desc = "Git: Blame Line (Full)" })
        end,
      }
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("git-conflict").setup()
      vim.keymap.set("n", "<leader>gl", "<cmd>GitConflictListQf<cr>", { desc = "Git: Open Conflict List" })
    end,
  },
  {
    "NeogitOrg/neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit kind=auto<cr>", desc = "Git: Open Neogit" },
    },
    config = function()
      require("neogit").setup {
        integrations = { diffview = true },
        disable_insert_on_commit = false,
        disable_commit_confirmation = true,
        disable_builtin_notifications = true,
      }
    end,
    dependencies = { "sindrets/diffview.nvim" },
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    config = function()
      require("diffview").setup {}
      vim.keymap.set("n", "<leader>gdd", function()
        if next(require("diffview.lib").views) == nil then
          vim.cmd "DiffviewOpen"
        else
          vim.cmd "DiffviewClose"
        end
      end, { desc = "Git: Toggle Diff" })
      vim.keymap.set("n", "<leader>ghh", "<cmd>DiffviewFileHistory<cr>", { desc = "Git: File History" })
      vim.keymap.set(
        "v",
        "<leader>gdh",
        "<esc><cmd>'<,'>DiffviewFileHistory --follow<cr>",
        { desc = "Git: File History (Follow visual selection)" }
      )
      vim.keymap.set(
        "n",
        "<leader>gdf",
        "<cmd>DiffviewFileHistory --follow %<cr>",
        { desc = "Git: File History (Follow current file)" }
      )
      vim.keymap.set(
        "n",
        "<leader>gdl",
        "<esc><cmd>.DiffviewFileHistory --follow<cr>",
        { desc = "Git: File History (Follow line)" }
      )
    end,
  },
  {
    "moyiz/git-dev.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
