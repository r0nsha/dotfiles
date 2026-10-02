local augroup = require("augroup")
local utils = require("utils")

-- opts
vim.opt.termguicolors = true
vim.opt.exrc = true
vim.opt.secure = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "+1"
vim.opt.scrolloff = 2
-- vim.opt.more = false
vim.opt.virtualedit = "block"
vim.opt.inccommand = "split"
vim.opt.scrollback = 100000
vim.opt.modeline = false
vim.opt.signcolumn = "yes:1"
vim.opt.winborder = "single"
vim.opt.pumheight = 10
vim.opt.pumborder = "single"
vim.opt.shortmess:append({ c = true, C = true })
vim.opt.list = true
vim.opt.listchars = {
  eol = "↲",
  tab = "· ",
  nbsp = "␣",
  extends = " ",
  precedes = " ",
  -- extends = "»",
  -- precedes = "«",
  trail = " ",
  multispace = " ",
  lead = " ",
}
vim.opt.fillchars:append({
  -- foldopen = "",
  -- foldclose = "",
  foldinner = " ",
  foldsep = " ",
  diff = "╱",
  msgsep = "─",
})
-- vim.opt.statuscolumn = "%l %s"
vim.opt.jumpoptions:append("view")

-- indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.copyindent = true
vim.opt.shiftround = true
vim.opt.joinspaces = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- completion
vim.opt.complete = { ".", "w", "b", "f", "kspell" }
vim.opt.completeopt = { "menuone", "fuzzy", "noselect", "noinsert", "preselect", "popup" }

vim.opt.path:append("**")
vim.opt.wildmode = { "noselect", "full" }
vim.opt.wildoptions = { "fuzzy", "pum" }
vim.opt.wildignore:append({ "*/node_modules/*", "*/.git/*" })

-- wrap
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.linebreak = true

-- title
vim.opt.title = true
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

-- files
vim.opt.isfname:append("@-@")
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.shada = { "'100", "<50", "s10", "h" }
vim.opt.updatetime = 250
vim.opt.updatecount = 0
vim.opt.ttimeoutlen = 0

-- filetypes
vim.filetype.add({
  extension = { jsonc = "jsonc", ll = "llvm", mdx = "markdown" },
  filename = {
    [".gitconfig.local"] = "gitconfig",
    ["jsconfig.json"] = "jsonc",
    ["tsconfig.json"] = "jsonc",
  },
  pattern = {
    [".*/%.vscode/.*%.json"] = "jsonc",
    [".*/vicinae/settings%.json"] = "jsonc",
    [".*/ghostty/themes/.*"] = "ghostty",
  },
})
vim.treesitter.language.register("markdown", "mdx")

-- diff
vim.opt.diffopt:append({
  "algorithm:histogram",
  "indent-heuristic",
  "inline:char",
  "followwrap",
  "hiddenoff",
  "linematch:60",
})

-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- mouse
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup_setpos"

-- fold
vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = "0"
vim.opt.foldlevelstart = 99

-- use system clipboard by default
vim.opt.clipboard:append("unnamedplus")

-- autocmd
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  desc = "Configure :terminal buffer",
  callback = function()
    vim.opt_local.signcolumn = "auto"
    vim.keymap.set("n", "<cr>", "i<cr><c-\\><c-n>", { buf = 0 })
    vim.keymap.set("n", "<c-c>", "i<c-c><c-\\><c-n>", { buf = 0 })
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost", "TextPutPost" }, {
  group = augroup,
  desc = "Highlight yank/put",
  pattern = "*",
  callback = function() vim.hl.hl_op({ timeout = 50 }) end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Return to last edit position when opening files",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  desc = "Reload kitty.conf when it's modified",
  pattern = "*/kitty/*.conf",
  callback = function()
    local pgrep = utils.is_macos() and "pgrep -a kitty" or "pgrep kitty"

    vim.system({ "fish", "-c", "kill -SIGUSR1 (" .. pgrep .. ")" }, {}, function(out)
      vim.schedule(function()
        if out.code == 0 then
          vim.notify("Reloaded kitty.conf")
        else
          vim.notify("Failed to reload kitty.conf")
        end
      end)
    end)
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = augroup,
  desc = "Remove `o` from formatoptions when entering a buffer",
  pattern = "*",
  callback = function()
    -- Don't have `o` add a comment
    vim.opt.formatoptions:remove("o")
  end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
  group = augroup,
  desc = "Clear search highlight when moving cursor",
  callback = function()
    if vim.v.hlsearch == 1 then
      local ok, sc = pcall(vim.fn.searchcount)
      if ok and sc.exact_match == 0 then vim.schedule(function() vim.cmd.nohlsearch() end) end
    end
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  desc = "Auto-resize splits when window is resized",
  callback = function() vim.cmd("tabdo wincmd =") end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  desc = "Create directories when saving files",
  callback = function(ev)
    local dir = vim.fs.normalize(vim.fs.dirname(ev.file))
    local stat = vim.uv.fs_stat(dir)
    if not stat then return end
    if stat.type ~= "directory" and not dir:startswith("oil:/") then
      vim.fs.mkdir(dir, { parents = true })
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  desc = "Set gitconfig filetype",
  pattern = "*/git/config",
  callback = function() vim.bo.filetype = "gitconfig" end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  desc = "Enable spell checking for prose",
  pattern = {
    "text",
    "plaintext",
    "tex",
    "plaintex",
    "markdown",
    "typst",
    "lex",
    "latex",
    "mail",
    "jjdescription",
    "gitcommit",
  },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelloptions = { "camel" }
    vim.opt_local.spellsuggest = "best"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup,
  desc = "Disable swapfile, backup, and undofile for pass files",
  pattern = { "/dev/shm/pass*", "/private/**/pass**" },
  callback = function()
    vim.opt_local.swapfile = false
    vim.opt_local.backup = false
    vim.opt_local.undofile = false
    vim.opt_local.shada = ""
  end,
})

require("vim._core.ui2").enable({ enable = true })

-- remap

vim.g.mapleader = " "
vim.keymap.set({ "n", "x" }, "<Space>", "<Nop>", { remap = false })

vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { remap = false, desc = "Yank to clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>Y", '"+Y', { remap = false, desc = "Yank to clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { remap = false, desc = "Paste from clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>P", '"+P', { remap = false, desc = "Paste from clipboard" })
vim.keymap.set({ "n", "x" }, "gy", '""y', { remap = false, desc = "Yank to unnamed register" })
vim.keymap.set({ "n", "x" }, "gY", '""Y', { remap = false, desc = "Yank to unnamed register" })
vim.keymap.set({ "n", "x" }, "gp", '""p', { remap = false, desc = "Paste from unnamed register" })
vim.keymap.set({ "n", "x" }, "gP", '""P', { remap = false, desc = "Paste from unnamed register" })

-- Don't yank when using 'p' in visual mode
vim.keymap.set("x", "p", '"_dP', { remap = false })

-- Remove `s`, it's useless
vim.keymap.set("n", "s", "<Nop>")

-- Inc/Dec
vim.keymap.set("x", "<C-x>", "<C-x>gv")
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("x", "+", "<C-a>gv")

local function get_relative_file_path()
  return vim.fs.normalize(vim.fn.expand("%") --[[@as string]])
end

---@param lines string
local function copy_line_reference(lines)
  local ref = string.format("%s:%s", get_relative_file_path(), lines)
  vim.fn.setreg("+", ref)
  vim.fn.setreg('"', ref)
  vim.notify("Yanked line reference")
end

vim.keymap.set("n", "<C-S-G>", function()
  local file = get_relative_file_path()
  vim.fn.setreg("+", file)
  vim.fn.setreg('"', file)
  vim.notify("Yanked file reference")
end, { remap = false, desc = "Copy file path to clipboard" })

vim.keymap.set("n", "<c-g>", function()
  vim.api.nvim_feedkeys(vim.keycode("<C-g>"), "n", false)
  copy_line_reference(tostring(vim.api.nvim_win_get_cursor(0)[1]))
end, { remap = false, desc = "Copy line reference to clipboard" })

vim.keymap.set("x", "<c-g>", function()
  local start_line, end_line = utils.get_visual_range()
  -- get_visual_range() returns 0-indexed lines
  start_line = start_line + 1
  end_line = end_line + 1
  local lines = start_line == end_line and tostring(start_line)
    or string.format("%d-%d", start_line, end_line)
  copy_line_reference(lines)
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
end, { remap = false, desc = "Copy line reference to clipboard" })

-- Deal with word wrap
vim.keymap.set({ "n", "x" }, "j", function()
  if vim.v.count == 0 then
    return "gj"
  else
    return "j"
  end
end, { expr = true })
vim.keymap.set({ "n", "x" }, "k", function()
  if vim.v.count == 0 then
    return "gk"
  else
    return "k"
  end
end, { expr = true })

-- replaced with mini.move
-- vim.keymap.set("x", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection: down" })
-- vim.keymap.set("x", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection: up" })

-- Splitjoin the line below the cursor
-- vim.keymap.set("n", "J", "mzJ`z", { desc = "Splitjoin" })

-- Justify center page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- -- Justify center search next/prev
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")

-- Stay in visual mode when indenting
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- Quickfix remaps
vim.keymap.set("n", "<leader>q", "<cmd>copen<cr>", { desc = "Quickfix" })
vim.keymap.set("n", "<A-n>", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<A-p>", "<cmd>cprev<cr>zz", { desc = "Previous quickfix item" })

-- Loclist remaps
vim.keymap.set("n", "<leader>Q", "<cmd>lopen<cr>", { desc = "Loclist" })
vim.keymap.set("n", "<A-N>", "<cmd>lnext<cr>zz", { desc = "Next loclist item" })
vim.keymap.set("n", "<A-P>", "<cmd>lprev<cr>zz", { desc = "Previous loclist item" })

-- Replace word under cursor (when LSP is not available)
vim.keymap.set(
  "n",
  "grn",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Rename" }
)
vim.keymap.set("x", "grn", [["vy:%s/<C-r>v/<C-r>v/gI<Left><Left><Left>]], { desc = "Rename" })

-- Toggle conceal
vim.keymap.set("n", "<leader>cl", function()
  if vim.wo.conceallevel == 0 then
    vim.wo.conceallevel = 2
  else
    vim.wo.conceallevel = 0
  end

  local conceal_enabled = utils.bool_to_enabled(vim.wo.conceallevel == 2)
  vim.notify("Conceal " .. conceal_enabled)
end, { desc = "Toggle conceal" })

-- Easier toggle fold
vim.keymap.set("n", "zt", "<cmd>normal! za<cr>", { desc = "Toggle fold under cursor" })
vim.keymap.set("n", "zT", "<cmd>normal! zA<cr>", { desc = "Toggle all folds under cursor" })

vim.keymap.set("n", "za", function()
  local any_closed = false
  for lnum = 1, vim.api.nvim_buf_line_count(0) do
    if vim.fn.foldclosed(lnum) ~= -1 then
      any_closed = true
      break
    end
  end
  vim.cmd("normal! " .. (any_closed and "zR" or "zM"))
end, { desc = "Toggle all folds in buffer" })

vim.keymap.set("n", "<leader>cc", "1z=", { desc = "Correct spelling" })
vim.keymap.set("n", "<leader>w", "<cmd>noau w<cr>", { desc = "Write without autocmds" })

require("config.diagnostics")
require("config.mcursor")
require("config.tabline")
require("config.window")
require("config.term")

-- -- atom ring
-- local last_atom ---@type vim.event.cmdatom.data?
-- local last_edit ---@type vim.event.cmdatom.data?
-- local maxseq = {} ---@type table<integer, integer>
--
-- vim.api.nvim_create_autocmd("CmdAtom", {
--   -- pattern = { 'motion', 'mapping' },
--   desc = "Remembers the most-recent user action",
--   group = augroup,
--   callback = function(ev)
--     local atom = ev.data --[[@as vim.event.cmdatom.data]]
--     local is_redo_or_undo = atom.changed and (atom.undoseq or 0) <= (maxseq[ev.buf] or 0)
--     maxseq[ev.buf] = vim.fn.undotree(ev.buf).seq_last
--     if atom.keys == "" then
--       -- Unreplayable Visual op.
--     elseif atom.changed and not is_redo_or_undo and atom.lhs ~= "." then
--       last_edit = atom
--     elseif not atom.changed and not is_redo_or_undo and not atom.lhs:match("^[,hjkl]$") then
--       last_atom = atom
--     elseif vim.g.debug then
--       local oneline = table.concat(vim.split(vim.inspect(atom), "%s*\n%s*"), " ")
--       vim.print(("skipped: %s"):format(oneline))
--     end
--   end,
-- })
--
-- ---@param atom? vim.event.cmdatom.data
-- local function replay(atom)
--   if not atom then
--     vim.print("no `atom`")
--     return
--   end
--   local keys = atom.keys or atom.lhs
--   vim.schedule(function()
--     vim.api.nvim_feedkeys(keys, atom.keys and "n" or "m", false)
--     if vim.g.debug then
--       local oneline = table.concat(vim.split(vim.inspect(atom), "%s*\n%s*"), " ")
--       vim.print(('atom: sent "%s", %s'):format(keys, oneline))
--     end
--   end)
-- end
--
-- -- Track the last atoms.
-- local atom_ring_count = 20
-- local atom_ring = {} ---@type vim.event.cmdatom.data[]
-- vim.api.nvim_create_autocmd("CmdAtom", {
--   desc = "Remembers the " .. atom_ring_count .. " most-recent user actions",
--   group = augroup,
--   callback = function(ev)
--     if not ev.data.lhs:match("^[ ,.u]$") and vim.fn.getcmdwintype() == "" then
--       atom_ring[#atom_ring + 1] = ev.data
--       if #atom_ring > atom_ring_count then table.remove(atom_ring, 1) end
--     end
--   end,
-- })
--
-- vim.keymap.set("n", ",", function()
--   local count = vim.v.count
--
--   if count == 0 then
--     replay(last_atom)
--     return
--   end
--
--   vim.schedule(function()
--     count = math.min(count, #atom_ring)
--     if count == 0 then -- Replay the saved macro.
--       for _, step in ipairs(vim.g.atom_macro or {}) do
--         vim.api.nvim_feedkeys(vim.keycode(step.keys or step.lhs), step.keys and "n" or "m", false)
--       end
--       return
--     end
--     local parts = {}
--     for i = #atom_ring - count + 1, #atom_ring do
--       local a = atom_ring[i]
--       local keys = a.keys or ("%s%s"):format(a.count or "", a.lhs)
--       local field = a.keys and "keys" or "lhs"
--       parts[#parts + 1] = ("{%s=%q},"):format(field, vim.fn.keytrans(keys))
--     end
--     local cmd = ("lua vim.g.atom_macro = { %s }"):format(table.concat(parts, " "))
--     -- Draft it on the cmdline; CTRL-F opens the cmdwin to edit it.
--     vim.api.nvim_feedkeys((":%s%s"):format(cmd, vim.keycode("<C-f>")), "n", false)
--   end)
-- end)
--
-- vim.keymap.set("n", ".", function() replay(last_edit) end)
