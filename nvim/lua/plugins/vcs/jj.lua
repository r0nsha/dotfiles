return {
  { "rafikdraoui/jj-diffconflicts" },
  -- {
  --   "nicolasgb/jj.nvim",
  --   dependencies = {
  --     "folke/snacks.nvim", -- Optional only if you use picker's
  --   },
  --   config = function()
  --     local jj = require("jj")
  --     jj.setup({})

  --     local cmd = require("jj.cmd")
  --     vim.keymap.set("n", "<leader>jd", cmd.describe, { desc = "JJ describe" })
  --     vim.keymap.set("n", "<leader>jl", cmd.log, { desc = "JJ log" })
  --     vim.keymap.set("n", "<leader>je", cmd.edit, { desc = "JJ edit" })
  --     vim.keymap.set("n", "<leader>jn", cmd.new, { desc = "JJ new" })
  --     vim.keymap.set("n", "<leader>js", cmd.status, { desc = "JJ status" })
  --     vim.keymap.set("n", "<leader>dj", cmd.diff, { desc = "JJ diff" })
  --     vim.keymap.set("n", "<leader>sj", cmd.squash, { desc = "JJ squash" })

  --     -- Pickers
  --     -- local picker = require("jj.picker")
  --     -- vim.keymap.set("n", "<leader>gj", picker.status, { desc = "JJ Picker status" })
  --     -- vim.keymap.set("n", "<leader>gl", picker.file_history, { desc = "JJ Picker file history" })

  --     -- This is an alias i use for moving bookmarks its so good
  --     vim.keymap.set("n", "<leader>gt", function()
  --       cmd.j("tug")
  --       cmd.log({})
  --     end, { desc = "JJ tug" })
  --   end,
  -- },
}
