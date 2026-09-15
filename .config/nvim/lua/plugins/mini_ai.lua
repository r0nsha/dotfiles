local ai = require("mini.ai")
local spec_treesitter = ai.gen_spec.treesitter

ai.setup({
  custom_textobjects = {
    b = spec_treesitter({ a = "@block.outer", i = "@block.inner" }),
    f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
    C = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
    m = spec_treesitter({ a = "@call.outer", i = "@call.inner" }),
    v = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
    o = spec_treesitter({
      a = { "@conditional.outer", "@loop.outer" },
      i = { "@conditional.inner", "@loop.inner" },
    }),
    s = spec_treesitter({ a = "@statement.outer", i = "@statement.outer" }),
  },
})
