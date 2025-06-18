local version = "*"
return {
  "echasnovski/mini.nvim",
  version = version,
  config = function()
    require "plugins.mini.ai"
    require "plugins.mini.basics"
    require "plugins.mini.cursorword"
    require "plugins.mini.diff"
    require "plugins.mini.jump"
    require "plugins.mini.move"
    require "plugins.mini.surround"
  end,
}
