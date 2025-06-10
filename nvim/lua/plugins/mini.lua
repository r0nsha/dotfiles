return {
  "echasnovski/mini.nvim",
  version = "*",
  config = function()
    require "plugins/mini/ai"
    require "plugins/mini/basics"
    require "plugins/mini/bufremove"
    require "plugins/mini/pairs"
  end,
}
