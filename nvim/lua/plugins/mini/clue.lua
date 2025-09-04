return {
  "nvim-mini/mini.clue",
  event = "VeryLazy",
  config = function()
    local clue = require("mini.clue")
    clue.setup({
      triggers = {
        -- Leader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },

        -- -- Marks
        -- { mode = "n", keys = "'" },
        -- { mode = "n", keys = "`" },
        -- { mode = "x", keys = "'" },
        -- { mode = "x", keys = "`" },

        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },

        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
      },
      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        clue.gen_clues.builtin_completion(),
        clue.gen_clues.g(),
        clue.gen_clues.marks(),
        clue.gen_clues.registers(),
        clue.gen_clues.windows(),
        clue.gen_clues.z(),

        { mode = "n", keys = "<Leader>b", desc = "+Buffers" },
        { mode = "n", keys = "<Leader>g", desc = "+Git" },
        { mode = "n", keys = "<Leader>a", desc = "+AI" },
        { mode = "n", keys = "<Leader>c", desc = "+Misc" },
        { mode = "n", keys = "<Leader>v", desc = "+CSV" },
        { mode = "n", keys = "<Leader>t", desc = "+Tabs" },
        { mode = "n", keys = "<Leader>T", desc = "+Todos" },
        { mode = "n", keys = "<Leader>i", desc = "+Treesitter" },
        { mode = "n", keys = "<Leader>s", desc = "+Pickers" },
        { mode = "n", keys = "<Leader>d", desc = "+Debug" },
        { mode = "n", keys = "gr", desc = "+LSP" },
      },
      window = {
        config = {
          width = 45,
        },
        delay = 500,
      },
    })
  end,
}
