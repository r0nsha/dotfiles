local utils = require "utils"

-- netrw options
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- line numbers, cols, signs, etc.
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.isfname:append "@-@"

-- display and appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.guicursor = ""
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.conceallevel = 2
vim.opt.list = true
vim.opt.listchars = {
  eol = "↲",
  tab = "» ",
  multispace = " ",
  lead = " ",
  trail = " ",
  nbsp = " ",
}

vim.opt.wrap = true
if vim.opt.wrap then
  vim.opt.showbreak = ""
  vim.opt.breakindent = true
  vim.opt.linebreak = true
end

-- title
vim.opt.title = true
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

-- mouse
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup_setpos"

-- search
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.inccommand = "split"
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- indent, tabs and typing
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.expandtab = false
vim.opt.shiftround = true
vim.opt.joinspaces = true
vim.opt.backspace = { "indent", "start", "eol" }

-- scroll
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- buffer and backups
vim.opt.autoread = true
vim.opt.shada = { "'10", "<0", "s10", "h" }
vim.opt.swapfile = true
vim.opt.undofile = true
vim.opt.fixeol = false
vim.opt.hidden = true

-- completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- disable startup message
vim.opt.shortmess:append { I = true }

-- updatetime and timeout
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 1000

-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- fold
vim.opt.foldmethod = "manual"
vim.opt.foldlevel = 999

-- statusline
vim.opt.laststatus = 3
vim.opt.showcmdloc = "statusline"

-- don't pause when listings get too long
vim.opt.more = false

-- filetypes
vim.filetype.add { extension = { ll = "llvm" } }

-- win
vim.opt.winborder = "single"

-- windows specific options
if utils.is_windows() then
  vim.opt.shell = vim.fn.executable "powershell" and "powershell" or "pwsh"
  vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end
