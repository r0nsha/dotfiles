local augroup = require("augroup")
local ts = require("nvim-treesitter")

vim.api.nvim_create_autocmd("PackChanged", {
  group = augroup,
  once = true,
  callback = function(args)
    if args.data.spec.name == "nvim-treesitter" then ts.update() end
  end,
})

---@param buf integer
---@param lang string
local function start_treesitter(buf, lang)
  if not vim.treesitter.language.add(lang) then return end

  vim.treesitter.start(buf, lang)
  vim.bo[buf].syntax = "on"

  vim.wo.foldexpr = vim.treesitter.foldexpr
  vim.wo.foldmethod = "expr"

  if vim.treesitter.query.get(lang, "idnents") then vim.bo[buf].indentexpr = ts.indentexpr end
end

local available_parsers = ts.get_available()

-- Auto-install parsers and enable highlighting for filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(args)
    local buf, ft = args.buf, args.match
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then return end

    local installed_parsers = ts.get_installed("parsers")

    if vim.tbl_contains(installed_parsers, lang) then
      start_treesitter(buf, lang)
    elseif vim.tbl_contains(available_parsers, lang) then
      ts.install(lang):await(function() start_treesitter(buf, lang) end)
    end
  end,
})
vim.api.nvim_create_user_command("TSStart", function() start_treesitter(0, vim.bo.filetype) end, {})

vim.keymap.set("n", "<leader>ih", "<cmd>Inspect<cr>", { desc = "TS: Inspect" })
vim.keymap.set("n", "<leader>ip", "<cmd>InspectTree<cr>", { desc = "TS: Inspect tree" })
vim.keymap.set("n", "<leader>iq", "<cmd>EditQuery<cr>", { desc = "TS: Edit query" })

-- textobjects
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
  -- C = { desc = "class", outer = "@class.outer", inner = "@class.inner" },
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

-- splitjoin
vim.keymap.set(
  { "n", "x" },
  "gs",
  function() require("treesj").toggle() end,
  { desc = "Splitjoin" }
)
