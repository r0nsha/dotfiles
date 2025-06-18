local version = "*"
return {
  { "echasnovski/mini.ai", version = version },
  {
    "echasnovski/mini.basics",
    version = version,
    opts = {
      options = {
        win_borders = "single",
        extra_ui = true,
      },
    },
  },
  { "echasnovski/mini.cursorword", version = version },
  {
    "echasnovski/mini.diff",
    version = version,
    config = function()
      local diff = require "mini.diff"
      diff.setup {
        source = diff.gen_source.none(),
      }
    end,
  },
  {
    "echasnovski/mini.jump",
    version = version,
    opts = {
      delay = {
        highlight = 250,
        idle_stop = 1000,
      },
    },
  },
  {
    "echasnovski/mini.move",
    version = version,
    opts = {
      mappings = {
        left = "H",
        right = "L",
        down = "J",
        up = "K",

        line_left = "",
        line_right = "",
        line_down = "",
        line_up = "",
      },
    },
  },
  {
    "echasnovski/mini.surround",
    version = version,
    opts = {
      mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sc",
        update_n_lines = "sn",
      },
    },
  },
}
