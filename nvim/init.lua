require "config"
require "ai"
require "utils.globals"
require "utils.extensions"
require "colors"

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  performance = {
    rtp = {
      disabled_plugins = {
        "matchparen",
        "netrwPlugin",
      },
    },
  },
  spec = {
    { import = "plugins" },
    { import = "plugins.vcs" },
    { import = "plugins.mini" },
    { import = "plugins.snacks" },
  },
  install = {
    colorscheme = { require "config.colorscheme" },
  },
  ui = {
    border = "single",
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
}

pcall(require, "local")
