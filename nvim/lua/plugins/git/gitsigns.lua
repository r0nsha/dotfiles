return {
  "lewis6991/gitsigns.nvim",
  config = function()
    local utils = require("utils")
    local gs = require("gitsigns")

    gs.setup({
      -- signs = {
      --   add = { text = "▎" },
      --   change = { text = "▎" },
      --   delete = { text = "▎" },
      --   topdelete = { text = "▎" },
      --   -- delete = { text = "▁" },
      --   -- topdelete = { text = "▁" },
      --   changedelete = { text = "▎" },
      --   untracked = { text = "▎" },
      -- },
      -- signs_staged = {
      --   add = { text = "▎" },
      --   change = { text = "▎" },
      --   delete = { text = "▎" },
      --   topdelete = { text = "▎" },
      --   -- delete = { text = "▁" },
      --   -- topdelete = { text = "▁" },
      --   changedelete = { text = "▎" },
      -- },
      -- current_line_blame = not utils.repo_too_large(),
      current_line_blame = false,
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
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev", { preview = true })
          end
        end, "Git: Previous Hunk")

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next", { preview = true })
          end
        end, "Git: Next Hunk")

        map("n", "[H", function()
          gs.nav_hunk("first")
        end, "Git: First Hunk")
        map("n", "]H", function()
          gs.nav_hunk("last")
        end, "Git: Last Hunk")

        map("n", "<leader>gp", gs.preview_hunk_inline, "Git: Preview Hunk")

        map("n", "<leader>gb", function()
          gs.blame()
        end, "Git: Blame Line")

        map("n", "<leader>gB", function()
          gs.blame_line({ full = true })
        end, "Git: Blame Line (Full)")

        map("n", "<leader>gdw", function()
          gs.toggle_word_diff()
        end, "Git: Toggle Word Diff")

        if utils.repo_too_large() then
          gs.detach(bufnr)
        end
      end,
    })
  end,
}
