require("codediff").setup({
  diff = { compute_moves = true },
  explorer = {
    visible_groups = {
      staged = false,
    },
  },
  keymaps = {
    view = {
      toggle_layout = "t",
      next_hunk = "<C-S-N>",
      prev_hunk = "<C-S-P>",
      next_file = "<C-n>",
      prev_file = "<C-p>",
      toggle_stage = false,
      focus_explorer = false,
    },
    explorer = {
      stage_all = false,
      unstage_all = false,
      toggle_changes = false,
      toggle_staged = false,
    },
  },
})

vim.keymap.set("n", "<leader>gdd", "<cmd>CodeDiff<cr>", { desc = "Diff" })
vim.keymap.set("n", "<leader>gdD", "<cmd>CodeDiff %<cr>", { desc = "Diff (current file)" })

vim.keymap.set("n", "<leader>gdf", "<cmd>CodeDiff history<cr>", { desc = "File History" })
vim.keymap.set("x", "<leader>gdf", "<cmd>CodeDiff history<cr>", { desc = "File History (visual)" })
vim.keymap.set("n", "<leader>gdF", "<cmd>CodeDiff history %<cr>", { desc = "File History (current file)" })
