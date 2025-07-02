return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  config = function()
    local actions = require("diffview.actions")
    local close = { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" } }
    local next_entry = { "n", "<C-n>", actions.select_next_entry, { desc = "Open the diff for the next file" } }
    local prev_entry = { "n", "<C-p>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } }

    require("diffview").setup({
      keymaps = {
        view = { close, next_entry, prev_entry },
        file_panel = { close, next_entry, prev_entry },
        file_history_panel = { close, next_entry, prev_entry },
      },
    })

    local function toggle_diff(cmd)
      if next(require("diffview.lib").views) == nil then
        vim.cmd(cmd)
      else
        vim.cmd("DiffviewClose")
      end
    end

    vim.keymap.set("n", "<leader>gdd", function()
      toggle_diff("DiffviewOpen")
    end, { desc = "Git: Diffview" })

    vim.keymap.set("n", "<leader>gdf", function()
      toggle_diff("DiffviewFileHistory")
    end, { desc = "Git: File History" })

    vim.keymap.set("v", "<leader>gdf", function()
      toggle_diff("'<,'>DiffviewFileHistory --follow")
    end, { desc = "Git: File History (Follow visual selection)" })

    vim.keymap.set("n", "<leader>gdF", function()
      toggle_diff("DiffviewFileHistory --follow %")
    end, { desc = "Git: File History (Follow current file)" })

    vim.keymap.set("n", "<leader>gdl", function()
      toggle_diff(".DiffviewFileHistory --follow")
    end, { desc = "Git: File History (Follow line)" })
  end,
}
