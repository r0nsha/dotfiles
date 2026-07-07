vim.keymap.set("n", "<leader>u", function()
  vim.cmd.packadd("nvim.undotree")
  require("undotree").open({ command = "40vnew" })
end, { desc = "Undotree" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nvim-undotree",
  callback = function(args) vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = args.buf }) end,
})
