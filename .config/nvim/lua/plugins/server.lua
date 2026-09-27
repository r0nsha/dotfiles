require("servery").setup({
  dirs = function()
    local dirs = {
      "~/dotfiles",
      "~/documents",
      "~/pictures/backgrounds",
    }
    local dev = vim.fs.normalize("~/dev")
    for name, type in vim.fs.dir(dev) do
      if type == "directory" then table.insert(dirs, vim.fs.joinpath(dev, name)) end
    end
    return dirs
  end,
  ui = { provider = "mini_pick" },
})

vim.keymap.set({ "n", "t" }, "<C-f>", "<cmd>Sv<cr>", { desc = "Switch nvim servers" })
vim.keymap.set({ "n", "t" }, "<A-f>", "<cmd>1Sv<cr>", { desc = "Go to previous server" })
