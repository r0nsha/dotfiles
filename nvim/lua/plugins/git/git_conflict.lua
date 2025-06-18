return {
  "akinsho/git-conflict.nvim",
  cond = function()
    return not require("utils").repo_too_large()
  end,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("git-conflict").setup {}
    vim.keymap.set("n", "<leader>gl", "<cmd>GitConflictListQf<cr>", { desc = "Git: Open Conflict List" })
  end,
}
