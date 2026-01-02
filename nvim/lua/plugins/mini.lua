---@module "lazy"
---@type LazySpec
return {
  "nvim-mini/mini.nvim",
  version = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    require "plugins.mini.ai"
    require "plugins.mini.bufremove"
    require "plugins.mini.clue"
    require "plugins.mini.cursorword"
    require "plugins.mini.diff"
    require "plugins.mini.hipatterns"
    require "plugins.mini.icons"
    require "plugins.mini.jump"
    require "plugins.mini.move"
    require "plugins.mini.notify"
    require "plugins.mini.snippets"
    require "plugins.mini.surround"
  end,
}
