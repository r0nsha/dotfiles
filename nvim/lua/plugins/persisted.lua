return {
  {
    "olimorris/persisted.nvim",
    config = function()
      require("persisted").setup {
        save_dir = vim.fn.expand(vim.fn.stdpath "data" .. "/sessions/"),
        silent = false,
        use_git_branch = true,
        autosave = true,
        autoload = false,
        follow_cwd = true,
      }

      vim.keymap.set("n", "<leader>ql", "<cmd>SessionLoad<cr>", { remap = false, desc = "Persisted: Load session" })
    end,
  },
}
