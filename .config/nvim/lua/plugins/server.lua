local async = require("plugins.server.async")

require("servery").setup({
  servers = async.servers,
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

    local active_dirs = vim.tbl_map(
      function(s) return vim.fs.normalize(s.cwd or "") end,
      require("servery").list_sessions("active")
    )

    return vim.tbl_filter(
      function(dir) return not vim.tbl_contains(active_dirs, vim.fs.normalize(dir)) end,
      dirs
    )
  end,
  ui = { provider = "mini_pick" },
})

-- AI-generated slop until https://github.com/wurli/servery.nvim/issues/16 is resolved:
-- servery's built-in discovery is blocking. Remove once fixed upstream.
async.install()

vim.keymap.set({ "n", "t" }, "<C-f>", [[<C-\><C-n><cmd>Sv<cr>]], { desc = "Switch nvim servers" })
vim.keymap.set({ "n", "t" }, "<A-f>", "<cmd>1Sv<cr>", { desc = "Go to previous server" })
