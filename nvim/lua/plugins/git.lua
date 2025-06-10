local utils = require "utils"

return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local gs = require "gitsigns"

      gs.setup {
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "▁" },
          topdelete = { text = "▁" },
          changedelete = { text = "▎" },
          untracked = { text = "▎" },
        },
        signs_staged = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "▁" },
          topdelete = { text = "▁" },
          changedelete = { text = "▎" },
        },
        current_line_blame = not utils.repo_too_large(),
        on_attach = function(bufnr)
          ---@param mode string
          ---@param l string
          ---@param r string|function
          ---@param desc string
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          map("n", "[h", function()
            if vim.wo.diff then
              vim.cmd.normal { "[c", bang = true }
            else
              gs.nav_hunk("prev", { preview = true })
            end
          end, "Git: Previous Hunk")

          map("n", "]h", function()
            if vim.wo.diff then
              vim.cmd.normal { "]c", bang = true }
            else
              gs.nav_hunk("next", { preview = true })
            end
          end, "Git: Next Hunk")

          map("n", "[H", function()
            gs.nav_hunk "first"
          end, "First Hunk")
          map("n", "]H", function()
            gs.nav_hunk "last"
          end, "Last Hunk")

          map("n", "<leader>gp", gs.preview_hunk_inline, "Git: Preview Hunk")

          map("n", "<leader>gb", function()
            gs.blame()
          end, "Git: Blame Line (Full)")

          map("n", "<leader>gl", function()
            gs.blame_line { full = true }
          end, "Git: Blame Line (Full)")

          map("n", "<leader>gw", function()
            gs.toggle_word_diff()
          end, "Git: Blame Line (Full)")

          if utils.repo_too_large() then
            gs.detach(bufnr)
          end
        end,
      }
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    cond = function()
      return not utils.repo_too_large()
    end,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("git-conflict").setup {}
      vim.keymap.set("n", "<leader>gl", "<cmd>GitConflictListQf<cr>", { desc = "Git: Open Conflict List" })
    end,
  },
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    config = function()
      require("neogit").setup {
        graph_style = "kitty",
        kind = "auto",
        commit_editor = {
          kind = "floating",
        },
        integrations = { diffview = true, fzf_lua = true },
        disable_insert_on_commit = false,
        disable_commit_confirmation = false,
        disable_builtin_notifications = false,
      }

      vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
    end,
    dependencies = { "sindrets/diffview.nvim" },
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    config = function()
      local actions = require "diffview.actions"
      local close = { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" } }
      local next_entry = { "n", "<C-n>", actions.select_next_entry, { desc = "Open the diff for the next file" } }
      local prev_entry = { "n", "<C-p>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } }

      require("diffview").setup {
        keymaps = {
          view = { close, next_entry, prev_entry },
          file_panel = { close, next_entry, prev_entry },
          file_history_panel = { close, next_entry, prev_entry },
        },
      }

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
  {
    "pwntester/octo.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("octo").setup {
        picker = "fzf-lua",
        mappings = {
          review_diff = {
            select_next_entry = { lhs = "<C-n>", desc = "move to next changed file" },
            select_prev_entry = { lhs = "<C-p>", desc = "move to previous changed file" },
          },
          file_panel = {
            select_entry = { lhs = "<C-y>", desc = "show selected changed file diffs" },
            select_next_entry = { lhs = "<C-n>", desc = "move to next changed file" },
            select_prev_entry = { lhs = "<C-p>", desc = "move to previous changed file" },
          },
        },
      }
    end,
  },
}
