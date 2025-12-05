return {
  "NeogitOrg/neogit",
  enabled = false,
  event = "VeryLazy",
  config = function()
    require("neogit").setup({
      graph_style = "kitty",
      -- kind = "auto",
      integrations = { diffview = true, snacks = true },
      disable_insert_on_commit = false,
      disable_commit_confirmation = false,
      disable_builtin_notifications = false,
    })

    vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("CustomNeogit", { clear = true }),
      pattern = "Neogit*",
      command = "set colorcolumn=",
    })
  end,
  dependencies = { "sindrets/diffview.nvim" },
}
