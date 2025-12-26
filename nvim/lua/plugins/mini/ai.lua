local ai = require "mini.ai"
local treesitter = ai.gen_spec.treesitter

ai.setup {
  custom_textobjects = {
    a = treesitter { a = "@statement.outer", i = "@statement.inner" },
    b = treesitter { a = "@block.outer", i = "@block.inner" },
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

    -- Disable default goto mappings - using custom treesitter-style below
    goto_left = "",
    goto_right = "",
  },
  n_lines = 500,
}

-- Treesitter-textobjects style goto mappings
-- Automatically creates ]x/]X/[x/[X for each textobject
local textobjects = {
  { id = "f", desc = "function" },
  { id = "v", desc = "parameter" },
  { id = "b", desc = "block" },
  { id = "c", desc = "comment" },
  { id = "o", desc = "conditional/loop" },
  { id = "a", desc = "statement" },
}

for _, obj in ipairs(textobjects) do
  local id = obj.id
  local desc = obj.desc

  -- ]x - next start (left edge with next search)
  vim.keymap.set({ "n", "x", "o" }, "]" .. id, function()
    ai.move_cursor("left", "a", id, { search_method = "next" })
  end, { desc = "Next " .. desc .. " start" })

  -- ]X - next end (right edge with next search)
  vim.keymap.set({ "n", "x", "o" }, "]" .. id:upper(), function()
    ai.move_cursor("right", "a", id, { search_method = "next" })
  end, { desc = "Next " .. desc .. " end" })

  -- [x - previous start (left edge with prev search)
  vim.keymap.set({ "n", "x", "o" }, "[" .. id, function()
    ai.move_cursor("left", "a", id, { search_method = "prev" })
  end, { desc = "Previous " .. desc .. " start" })

  -- [X - previous end (right edge with prev search)
  vim.keymap.set({ "n", "x", "o" }, "[" .. id:upper(), function()
    ai.move_cursor("right", "a", id, { search_method = "prev" })
  end, { desc = "Previous " .. desc .. " end" })
end
