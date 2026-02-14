require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
    include_surrounding_whitespace = false,
  },
  move = {
    set_jumps = true,
  },
})

local ts_config = require("nvim-treesitter-textobjects.config")
local ts_move = require("nvim-treesitter-textobjects.move")
local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
local ts_select = require("nvim-treesitter-textobjects.select")
local ts_shared = require("nvim-treesitter-textobjects.shared")

local function select_textobject(queries)
  if type(queries) == "string" then
    ts_select.select_textobject(queries, "textobjects")
    return
  end

  local opts = {
    lookahead = ts_config.select.lookahead,
    lookbehind = ts_config.select.lookbehind,
  }

  for _, query in ipairs(queries) do
    if ts_shared.textobject_at_point(query, "textobjects", nil, nil, opts) then
      ts_select.select_textobject(query, "textobjects")
      return
    end
  end
end

local textobjects = {
  b = { desc = "block", outer = "@block.outer", inner = "@block.inner" },
  c = { desc = "comment", outer = "@comment.outer", inner = "@comment.inner" },
  f = { desc = "function", outer = "@function.outer", inner = "@function.inner" },
  C = { desc = "class", outer = "@class.outer", inner = "@class.inner" },
  m = { desc = "call", outer = "@call.outer", inner = "@call.inner" },
  v = { desc = "parameter", outer = "@parameter.outer", inner = "@parameter.inner" },
  o = {
    desc = "conditional/loop",
    outer = { "@conditional.outer", "@loop.outer" },
    inner = { "@conditional.inner", "@loop.inner" },
  },
  s = { desc = "statement", outer = "@statement.outer", inner = "@statement.outer" },
}

for id, config in pairs(textobjects) do
  vim.keymap.set(
    { "x", "o" },
    "a" .. id,
    function() select_textobject(config.outer) end,
    { desc = "Around " .. config.desc }
  )

  vim.keymap.set(
    { "x", "o" },
    "i" .. id,
    function() select_textobject(config.inner) end,
    { desc = "Inside " .. config.desc }
  )

  vim.keymap.set(
    { "n", "x", "o" },
    "]" .. id,
    function() ts_move.goto_next_start(config.outer, "textobjects") end,
    { desc = "Next " .. config.desc .. " start" }
  )

  vim.keymap.set(
    { "n", "x", "o" },
    "]" .. id:upper(),
    function() ts_move.goto_next_end(config.outer, "textobjects") end,
    { desc = "Next " .. config.desc .. " end" }
  )

  vim.keymap.set(
    { "n", "x", "o" },
    "[" .. id,
    function() ts_move.goto_previous_start(config.outer, "textobjects") end,
    { desc = "Previous " .. config.desc .. " start" }
  )

  vim.keymap.set(
    { "n", "x", "o" },
    "[" .. id:upper(),
    function() ts_move.goto_previous_end(config.outer, "textobjects") end,
    { desc = "Previous " .. config.desc .. " end" }
  )
end

vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
