require "opts"
require "clipboard"
require "remap"
require "autocmd"
require "inspect"
require "pass"
require "toggle-checkbox"
require "ai"
require "utils/string"

-- load .env, if it exists
require("dotenv").eval(vim.fs.joinpath(vim.fn.stdpath "config", ".env"))

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
  spec = {
    { import = "plugins" },
    { import = "plugins.codecompanion" },
    { import = "plugins.git" },
    { import = "plugins.mini" },
    { import = "plugins.snacks" },
  },
  install = {
    colorscheme = { require("utils").colorscheme },
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
