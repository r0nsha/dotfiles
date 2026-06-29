local group = require("augroup")

-- bufremove
local br = require("mini.bufremove")
br.setup({})

vim.keymap.set("n", "<leader>bd", br.delete, { desc = "Delete buffer" })
vim.keymap.set(
  "n",
  "<leader>bD",
  function() br.delete(0, true) end,
  { desc = "Delete buffer (force)" }
)

-- clue
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
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

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

    -- `[` and `]` keys for textobject navigation
    { mode = "n", keys = "[" },
    { mode = "x", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "x", keys = "]" },
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
    { mode = "n", keys = "<Leader>g", desc = "+Source Control" },
    { mode = "n", keys = "<Leader>c", desc = "+Misc" },
    { mode = "n", keys = "<Leader>t", desc = "+Tabs" },
    { mode = "n", keys = "<Leader>i", desc = "+Treesitter" },
    { mode = "n", keys = "<Leader>s", desc = "+Pickers" },
    { mode = "n", keys = "<Leader>d", desc = "+Debug" },
    { mode = "n", keys = "gr", desc = "+LSP" },

    { mode = "n", keys = "[", desc = "+Previous" },
    { mode = "x", keys = "[", desc = "+Previous" },
    { mode = "n", keys = "]", desc = "+Next" },
    { mode = "x", keys = "]", desc = "+Next" },
  },
  window = {
    config = {
      width = 45,
    },
    delay = 500,
  },
})

-- diff
local diff = require("mini.diff")
diff.setup({
  -- view = { style = "sign" },
  source = { require("mini.diff.jj"), diff.gen_source.git() },
  mappings = {
    apply = "",
    reset = "gH",
    textobject = "",
    goto_first = "[H",
    goto_prev = "[h",
    goto_next = "]h",
    goto_last = "]H",
  },
})

vim.keymap.set("n", "<leader>gh", diff.toggle_overlay, { desc = "Toggle diff overlay" })

-- hipatterns
require("mini.hipatterns").setup({
  highlighters = {
    todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
    fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
    hack = { pattern = "HACK", group = "MiniHipatternsHack" },
    note = { pattern = "NOTE", group = "MiniHipatternsNote" },
  },
})

-- icons
require("mini.icons").setup()

-- jump
require("mini.jump").setup({
  mappings = { repeat_jump = "" },
})

-- move
require("mini.move").setup({
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
})

-- snippets
local snippets = require("mini.snippets")
snippets.setup({
  snippets = { snippets.gen_loader.from_lang() },
  mappings = {
    expand = "",
    jump_prev = "<C-h>",
    jump_next = "<C-l>",
    stop = "<C-c>",
  },
})

vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "stop mini.snippets when leaving insert mode",
  group = group,
  pattern = "*",
  callback = function() snippets.session.stop() end,
})

-- surround
require("mini.surround").setup({
  mappings = {
    add = "ms",
    delete = "md",
    find = "",
    find_left = "",
    highlight = "",
    replace = "mr",
    update_n_lines = "",
  },
  n_lines = 200,
})

-- trailspace
require("mini.trailspace").setup()

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "jjdescription",
  callback = function(args)
    vim.b[args.buf].minitrailspace_disable = true
    vim.api.nvim_buf_call(args.buf, MiniTrailspace.unhighlight)
  end,
})

-- completions

require("mini.completion").setup({})
vim.api.nvim_set_hl(0, "MiniCompletionInfoBorderOutdated", { link = "FloatBorder" })

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "disable mini.completion for prompt buffers",
  group = group,
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "prompt" then vim.b.minicompletion_disable = true end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "set omnifunc for dadbod",
  group = group,
  pattern = "sql",
  callback = function() vim.bo.omnifunc = "vim_dadbod_completion#omni" end,
})

require("mini.cmdline").setup({
  autopeek = { enable = false },
})
