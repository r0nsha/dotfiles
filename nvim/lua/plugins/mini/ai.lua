return {
  "echasnovski/mini.ai",
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
}
