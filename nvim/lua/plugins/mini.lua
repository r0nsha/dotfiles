return {
  "echasnovski/mini.nvim",
  version = "*",
  config = function()
    require "plugins/mini/ai"
    require "plugins/mini/basics"
    require "plugins/mini/cursorword"
    require "plugins/mini/surround"
  end,
}
