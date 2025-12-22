---@module "lazy"
---@type LazySpec
return {
  "rebelot/heirline.nvim",
  dependencies = { "Zeioth/heirline-components.nvim" },
  config = function()
    require("heirline-components.all").init.subscribe_to_events()
    require("heirline").setup {
      opts = { colors = require("plugins.heirline.colors").setup() },
      statusline = require "plugins.heirline.statusline",
      statuscolumn = require "plugins.heirline.statuscolumn",
    }
  end,
}
