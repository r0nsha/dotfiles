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
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 and not dir:startswith("oil:/") then vim.fn.mkdir(dir, "p") end
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
  },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelloptions = { "camel" }
    vim.opt_local.spellsuggest = "best"
  end,
})

vim.api.nvim_create_autocmd("LspProgress", {
  group = augroup,
  command = "redrawstatus",
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

vim.api.nvim_create_autocmd({ "TermRequest" }, {
  desc = "Handles OSC 7 dir change requests",
  callback = function(ev)
    local dir, n = string.gsub(ev.data.sequence, "\027]7;file://[^/]*", "")
    if n > 0 then
      -- OSC 7: dir-change
      assert(vim.fn.isdirectory(dir) ~= 0, "invalid dir: " .. dir)
      if vim.api.nvim_get_current_buf() == ev.buf then vim.cmd.bcd(dir) end
    end
  end,
})

require("vim._core.ui2").enable({ enable = true })

-- remap

vim.g.mapleader = " "
vim.g.maplocalleader = ","
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

local function get_relative_file_path() return vim.fs.normalize(vim.fn.expand("%")) end

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
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, true, true), "n", true)
  local line = vim.fn.line(".")
  copy_line_reference(tostring(line))
end, { remap = false, desc = "Copy line reference to clipboard" })

vim.keymap.set("x", "<c-g>", function()
  local start_line, end_line = utils.get_visual_range()
  -- get_visual_range() returns 0-indexed lines
  start_line = start_line + 1
  end_line = end_line + 1
  local lines = start_line == end_line and tostring(start_line)
    or string.format("%d-%d", start_line, end_line)
  copy_line_reference(lines)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
end, { remap = false, desc = "Copy line reference to clipboard" })

-- Window mappings when tmux is not available
if vim.fn.executable("tmux") ~= 1 then
  vim.keymap.set("n", "<c-h>", "<c-w>h", { remap = false, desc = "Move Window: Left" })
  vim.keymap.set("n", "<c-j>", "<c-w>j", { remap = false, desc = "Move Window: Down" })
  vim.keymap.set("n", "<c-k>", "<c-w>k", { remap = false, desc = "Move Window: Up" })
  vim.keymap.set("n", "<c-l>", "<c-w>l", { remap = false, desc = "Move Window: Right" })
end

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
-- vim.keymap.set("x", "J", ":m '>+1<cr>gv=gv", { desc = "Move Selection: Down" })
-- vim.keymap.set("x", "K", ":m '<-2<cr>gv=gv", { desc = "Move Selection: Up" })

-- Splitjoin the line below the cursor
-- vim.keymap.set("n", "J", "mzJ`z", { desc = "Splitjoin" })

-- Justify center page up/down
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Justify center search next/prev
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")

-- Clear hlsearch
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlight" })

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

-- Tabs
vim.keymap.set("n", "<c-t>n", "<cmd>tabnew<cr>", { desc = "New tab" })
vim.keymap.set("n", "<c-t>x", "<cmd>tabclose<cr>", { desc = "Close tab" })
vim.keymap.set("n", "<c-t>O", "<cmd>tabonly<cr>", { desc = "Close other tabs" })

-- Easier toggle fold
vim.keymap.set("n", "zt", "<cmd>normal! za<cr>", { desc = "Toggle fold under cursor" })
vim.keymap.set("n", "zT", "<cmd>normal! zA<cr>", { desc = "Toggle all folds under cursor" })

vim.keymap.set("n", "za", function()
  local any_closed = false
  for lnum = 1, vim.fn.line("$") do
    if vim.fn.foldclosed(lnum) ~= -1 then
      any_closed = true
      break
    end
  end
  vim.cmd("normal! " .. (any_closed and "zR" or "zM"))
end, { desc = "Toggle all folds in buffer" })

-- Spell
vim.keymap.set("n", "<leader>cc", "1z=", { desc = "Correct spelling" })

-- Write
vim.keymap.set("n", "<leader>w", "<cmd>noau w<cr>", { desc = "Write without autocmds" })

-- Cmdline remaps
vim.keymap.set("c", "<C-h>", "<Left>", { desc = "Move cursor left", noremap = true })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "Move cursor down", noremap = true })
vim.keymap.set("c", "<C-k>", "<Up>", { desc = "Move cursor up", noremap = true })
vim.keymap.set("c", "<C-l>", "<Right>", { desc = "Move cursor right", noremap = true })
vim.keymap.set("c", "<C-w>", "<S-Right>", { desc = "Next word", noremap = true })
vim.keymap.set("c", "<C-b>", "<S-Left>", { desc = "Previous word", noremap = true })
vim.keymap.set("c", "<C-S-I>", "<C-b>", { desc = "Insert at start", noremap = true })
vim.keymap.set("c", "<C-S-A>", "<C-e>", { desc = "Insert at end", noremap = true })
vim.keymap.set("c", "<C-x>", "<Del>", { desc = "Delete character", noremap = true })
vim.keymap.set("c", "<C-d>", "<C-u>", { desc = "Delete to start", noremap = true })

-- Arglist
vim.keymap.set("n", "[a", "<cmd>prev<cr>", { desc = "Previous file in arglist" })
vim.keymap.set("n", "]a", "<cmd>next<cr>", { desc = "Next file in arglist" })

-- diagnostics

-- --- @param diagnostic? vim.Diagnostic
-- --- @param bufnr integer
-- local function on_jump(diagnostic, bufnr)
--   if diagnostic then
--     vim.diagnostic.open_float({
--       bufnr = bufnr,
--       namespace = diagnostic.namespace,
--       scope = "cursor",
--       source = "if_many",
--     })
--   end
-- end

-- vim.diagnostic.config({
--   -- jump = { on_jump = on_jump },
--   virtual_text = false,
-- })

local qf_severity = {
  E = vim.diagnostic.severity.ERROR,
  W = vim.diagnostic.severity.WARN,
  I = vim.diagnostic.severity.INFO,
  H = vim.diagnostic.severity.HINT,
}

---@param opts vim.diagnostic.GetOpts?
local function set_sorted_qflist(opts)
  opts = vim.tbl_extend("force", { open = false }, opts or {})
  local diagnostics = vim.diagnostic.get(nil, opts)
  if #diagnostics == 0 then
    vim.notify("No diagnostics found", vim.log.levels.INFO)
    vim.fn.setqflist({}, " ", { items = {}, title = "Diagnostics" })
    vim.cmd.cclose()
    return
  end
  local items = vim.diagnostic.toqflist(diagnostics)
  table.sort(
    items,
    function(a, b) return (qf_severity[a.type] or math.huge) < (qf_severity[b.type] or math.huge) end
  )
  vim.fn.setqflist({}, " ", { items = items, title = "Diagnostics" })
  vim.cmd.copen()
end

vim.keymap.set("n", "grq", set_sorted_qflist, { desc = "Show Diagnostics" })
vim.keymap.set("n", "grQ", function()
  vim.ui.select(
    { "Error", "Warn", "Info", "Hint" },
    { prompt = "Select minimum severity" },
    function(severity)
      if not severity then return end
      set_sorted_qflist({
        severity = {
          min = vim.diagnostic.severity[severity:upper()],
          max = vim.diagnostic.severity.ERROR,
        },
      } --[[@as vim.diagnostic.GetOpts]])
    end
  )
end, { desc = "Show Diagnostics (Filtered)" })

-- terminal
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]])
vim.keymap.set({ "n", "t" }, "<C-w>1", [[<C-\><C-n>1gt]])
vim.keymap.set({ "n", "t" }, "<C-w>2", [[<C-\><C-n>2gt]])
vim.keymap.set({ "n", "t" }, "<C-w>3", [[<C-\><C-n>3gt]])
vim.keymap.set({ "n", "t" }, "<C-w>4", [[<C-\><C-n>4gt]])
vim.keymap.set({ "n", "t" }, "<C-w>5", [[<C-\><C-n>5gt]])
vim.keymap.set({ "n", "t" }, "<C-w>6", [[<C-\><C-n>6gt]])
vim.keymap.set({ "n", "t" }, "<C-w>7", [[<C-\><C-n>7gt]])
vim.keymap.set({ "n", "t" }, "<C-w>8", [[<C-\><C-n>8gt]])
vim.keymap.set({ "n", "t" }, "<C-w>9", [[<C-\><C-n>9gt]])

local exit_term_mode = [[<C-\><C-n>]]
vim.keymap.set("t", "<C-Esc>", exit_term_mode, { desc = "Exit terminal mode" })
vim.keymap.set("t", "<S-Esc>", exit_term_mode, { desc = "Exit terminal mode" })
vim.keymap.set("t", "<A-Esc>", exit_term_mode, { desc = "Exit terminal mode" })

-- :terminal-nested Nvim:
if vim.env.NVIM then
  ---@return integer?
  local function parent_chan()
    local ok, chan = pcall(vim.fn.sockconnect, "pipe", vim.env.NVIM, { rpc = true })
    if not ok then
      vim.notify(("failed to create channel to $NVIM: %s"):format(chan))
      return nil
    end
    return chan --[[@as integer?]]
  end

  local didset = false
  local chan = assert(parent_chan())
  local function map_parent(lhs)
    -- Map `lhs` in the parent so it gets sent to the child (this) Nvim.
    local map = vim.rpcrequest(
      chan,
      "nvim_exec_lua",
      [[return vim.fn.maparg(..., 't', false, true)]],
      { lhs }
    ) --[[@as table<string,any>]]
    if map.rhs == exit_term_mode then
      vim.rpcrequest(
        chan,
        "nvim_exec_lua",
        [[vim.keymap.set('t', ..., '<Esc>', {buffer=0})]],
        { lhs }
      )
      didset = true
    end
  end
  map_parent("<C-Esc>")
  map_parent("<S-Esc>")
  map_parent("<A-Esc>")
  vim.fn.chanclose(chan)

  -- Restore the mapping(s) on VimLeave.
  if didset then
    vim.api.nvim_create_autocmd("VimLeave", {
      group = augroup,
      desc = "Restore parent nvim mappings",
      callback = function()
        local chan2 = assert(parent_chan())
        vim.rpcrequest(
          chan2,
          "nvim_exec2",
          [=[
          silent! tunmap <buffer> <C-Esc>
          silent! tunmap <buffer> <S-Esc>
          silent! tunmap <buffer> <A-Esc>
        ]=],
          {}
        )
      end,
    })
  end
end

-- tabline
_G._myconfig = _G._myconfig or {}

_G._myconfig.tablabel = function(n)
  local buflist = vim.fn.tabpagebuflist(n)
  local winnr = vim.fn.tabpagewinnr(n)
  local tabdir = vim.fn.getcwd(-1, n)
  local has_tabdir = vim.fn.getcwd(-1, -1) ~= tabdir
  if has_tabdir then return ("CWD: %s/"):format(vim.fn.fnamemodify(tabdir, ":t")) end
  local bufname = vim.fn.bufname(buflist[winnr])
  local isdir = bufname:sub(#bufname) == "/"
  local name = vim.fn.fnamemodify(bufname, isdir and ":h:t" or ":t") .. (isdir and "/" or "")
  name = name:len() > 20 and name:sub(1, 20) .. "…" or name
  return name == "" and "No Name" or name
end
_G._myconfig.tabline = function()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local hlgroup = (i == vim.fn.tabpagenr() and "%#TabLineSel#" or "%#TabLine#")
    s = s .. ("%s%%%dT %d: %%{v:lua._myconfig.tablabel(%d)} "):format(hlgroup, i, i, i)
  end
  -- return s .. "%#TabLineFill#%T%=%#TabLine#%999XX"
  return s .. "%#TabLineFill#"
end

vim.opt.tabline = "%!v:lua._myconfig.tabline()"
