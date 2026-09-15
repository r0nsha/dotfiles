require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
    selection_modes = {
      ["@statement.outer"] = "V",
      ["@comment.outer"] = "V",
    },
    include_surrounding_whitespace = function(opts) return opts.selection_mode == "V" end,
  },
  move = { set_jumps = true },
})

local config = require("nvim-treesitter-textobjects.config")
local move = require("nvim-treesitter-textobjects.move")
local select = require("nvim-treesitter-textobjects.select")
local shared = require("nvim-treesitter-textobjects.shared")

local function select_textobject(queries)
  if type(queries) ~= "table" then return select.select_textobject(queries, "textobjects") end

  for _, query in ipairs(queries) do
    if
      shared.textobject_at_point(query, "textobjects", nil, nil, {
        lookahead = config.select.lookahead,
        lookbehind = config.select.lookbehind,
      })
    then
      return select.select_textobject(query, "textobjects")
    end
  end
end

local textobjects = {
  b = { desc = "block", outer = "@block.outer", inner = "@block.inner" },
  C = { desc = "class", outer = "@class.outer", inner = "@class.inner" },
  f = { desc = "function", outer = "@function.outer", inner = "@function.inner" },
  m = { desc = "call", outer = "@call.outer", inner = "@call.inner" },
  v = { desc = "parameter", outer = "@parameter.outer", inner = "@parameter.inner" },
  o = {
    desc = "conditional/loop",
    outer = { "@conditional.outer", "@loop.outer" },
    inner = { "@conditional.inner", "@loop.inner" },
  },
  V = { desc = "statement", outer = "@statement.outer", inner = "@statement.outer" },
  a = { desc = "assignment", outer = "@assignment.outer", inner = "@assignment.inner" },
  c = {
    desc = "comment",
    outer = "@comment.outer",
    inner = "@comment.inner",
    move = false, -- ]c/[c are used for diff conflicts
  },
}

for id, obj in pairs(textobjects) do
  vim.keymap.set(
    { "x", "o" },
    "a" .. id,
    function() select_textobject(obj.outer) end,
    { desc = "Around " .. obj.desc }
  )

  vim.keymap.set(
    { "x", "o" },
    "i" .. id,
    function() select_textobject(obj.inner) end,
    { desc = "Inside " .. obj.desc }
  )

  if obj.move ~= false then
    vim.keymap.set(
      { "n", "x", "o" },
      "]" .. id,
      function() move.goto_next_start(obj.outer, "textobjects") end,
      { desc = "Next " .. obj.desc .. " start" }
    )

    vim.keymap.set(
      { "n", "x", "o" },
      "]" .. id:upper(),
      function() move.goto_next_end(obj.outer, "textobjects") end,
      { desc = "Next " .. obj.desc .. " end" }
    )

    vim.keymap.set(
      { "n", "x", "o" },
      "[" .. id,
      function() move.goto_previous_start(obj.outer, "textobjects") end,
      { desc = "Previous " .. obj.desc .. " start" }
    )

    vim.keymap.set(
      { "n", "x", "o" },
      "[" .. id:upper(),
      function() move.goto_previous_end(obj.outer, "textobjects") end,
      { desc = "Previous " .. obj.desc .. " end" }
    )
  end
end
