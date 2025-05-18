return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    config = function()
      local gitsigns = require "gitsigns"

      gitsigns.setup {
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
            require("gitsigns").preview_hunk_inline,
            { buffer = bufnr, desc = "Git: Preview Hunk" }
          )

          vim.keymap.set("n", "<leader>gb", function()
            gitsigns.blame()
          end, { buffer = bufnr, desc = "Git: Blame Line (Full)" })

          vim.keymap.set("n", "<leader>gl", function()
            gitsigns.blame_line { full = true }
          end, { buffer = bufnr, desc = "Git: Blame Line (Full)" })

          vim.keymap.set("n", "<leader>gw", function()
            gitsigns.toggle_word_diff()
          end, { buffer = bufnr, desc = "Git: Blame Line (Full)" })
        end,
      }
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("git-conflict").setup {}
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

      local function toggle_diff(cmd)
        if next(require("diffview.lib").views) == nil then
          vim.cmd(cmd)
        else
          vim.cmd "DiffviewClose"
        end
      end

      vim.keymap.set("n", "<leader>gdd", function()
        toggle_diff "DiffviewOpen"
      end, { desc = "Git: Diffview" })

      vim.keymap.set("n", "<leader>gdh", function()
        toggle_diff "DiffviewFileHistory"
      end, { desc = "Git: File History" })

      vim.keymap.set("v", "<leader>gdh", function()
        toggle_diff "'<,'>DiffviewFileHistory --follow"
      end, { desc = "Git: File History (Follow visual selection)" })

      vim.keymap.set("n", "<leader>gdf", function()
        toggle_diff "DiffviewFileHistory --follow %"
      end, { desc = "Git: File History (Follow current file)" })

      vim.keymap.set("n", "<leader>gdl", function()
        toggle_diff ".DiffviewFileHistory --follow"
      end, { desc = "Git: File History (Follow line)" })
    end,
  },
  {
    "moyiz/git-dev.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
