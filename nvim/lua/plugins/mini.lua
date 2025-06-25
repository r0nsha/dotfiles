local version = "*"

return {
  {
    "echasnovski/mini.ai",
    version = version,
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      local ai = require "mini.ai"
      local treesitter = ai.gen_spec.treesitter

      ai.setup {
        custom_textobjects = {
          a = treesitter { a = "@statement.outer", i = "@statement.inner" },
          f = treesitter { a = "@function.outer", i = "@function.inner" },
          c = treesitter { a = "@comment.outer", i = "@comment.inner" },
          v = treesitter { a = "@parameter.outer", i = "@parameter.inner" },
          o = treesitter {
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
          },
          -- Single words in different cases (camelCase, snake_case, etc.)
          s = {
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[^%s%p][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
              "%f[^%s%p][%a%d]+%f[^%a%d]",
              "^[%a%d]+%f[^%a%d]",
            },
            "^().*()$",
          },
          -- whole buffer
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line "$",
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
        mappings = {
          around = "a",
          inside = "i",
          around_next = "an",
          inside_next = "in",
          around_last = "al",
          inside_last = "il",
        },
        n_lines = 500,
      }
    end,
  },
  { "echasnovski/mini.cursorword", version = version, opts = {} },
  { "echasnovski/mini.icons", version = version, opts = {} },
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
