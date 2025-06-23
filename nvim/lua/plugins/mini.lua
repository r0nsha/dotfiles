local version = "*"

return {
  { "echasnovski/mini.ai", version = version, opts = {} },
  { "echasnovski/mini.cursorword", version = version, opts = {} },
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
    "echasnovski/mini.snippets",
    version = version,
    config = function()
      local snippets = require "mini.snippets"
      local gen_loader = snippets.gen_loader
      snippets.setup {
        snippets = { gen_loader.from_lang() },
        mappings = {
          expand = "",
          jump_prev = "<C-h>",
          jump_next = "<C-l>",
          stop = "<C-c>",
        },
      }
    end,
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
