local utils = require("utils")
local undodir = vim.fn.expand("~/.vim/undodir")

-- basic
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.shiftround = true
vim.opt.joinspaces = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- visual
vim.opt.termguicolors = true
vim.opt.background = "dark"
-- vim.opt.guicursor = "a:block-Cursor/lCursor"

vim.opt.signcolumn = "yes"
-- vim.opt.colorcolumn = "80"
vim.opt.laststatus = 2
vim.opt.showmode = true
vim.opt.cmdheight = 1
vim.opt.showcmdloc = "statusline"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 2
vim.opt.concealcursor = ""
-- vim.opt.lazyredraw = true
-- vim.opt.synmaxcol = 400
vim.opt.list = true
vim.opt.listchars = {
  eol = "↲",
  tab = "󰧟 ",
  multispace = " ",
  lead = " ",
  trail = " ",
  nbsp = " ",
}
vim.opt.fillchars:append({ diff = "╱" })
vim.opt.winborder = "single"

-- wrap
vim.opt.wrap = true
if vim.opt.wrap then
  vim.opt.showbreak = ""
  vim.opt.breakindent = true
  vim.opt.linebreak = true
end

-- title
vim.opt.title = true
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

-- files
vim.opt.isfname:append("@-@")
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = undodir
vim.opt.shada = { "'10", "<0", "s10", "h" }
vim.opt.updatetime = 300
vim.opt.timeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false
-- vim.opt.fixeol = false

-- filetypes
vim.filetype.add({ extension = { ll = "llvm" } })

-- behavior
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = { "indent", "start", "eol" }
vim.opt.autochdir = false
vim.opt.path:append("**")
vim.opt.modifiable = true
vim.opt.encoding = "utf-8"
vim.opt.more = false

-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- disable startup message
vim.opt.shortmess:append({ I = true })

-- mouse
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup_setpos"

-- perf
-- vim.opt.redrawtime = 10000
-- vim.opt.maxmempattern = 20000

-- Create undo directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

-- windows specific options
if utils.is_windows() then
  vim.opt.shell = vim.fn.executable("powershell") and "powershell" or "pwsh"
  vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end
