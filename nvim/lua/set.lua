local utils = require "utils"

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.shadafile = ""

vim.o.mouse = "a"
vim.o.guicursor = ""
vim.opt.background = "dark"

vim.o.completeopt = "menuone,noselect"
vim.o.backspace = "indent,start,eol"
vim.o.swapfile = false
vim.o.backup = false

vim.o.autoread = true
vim.o.autoindent = true
vim.o.colorcolumn = 80

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.incsearch = true
vim.o.hlsearch = true

vim.o.termguicolors = true

vim.o.smartcase = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = false
vim.o.shiftround = true

vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

vim.o.signcolumn = "yes"
vim.opt.isfname:append "@-@"

vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

vim.o.hidden = true
vim.o.ignorecase = true
vim.o.joinspaces = true

vim.o.cursorline = true

vim.o.wrap = false

if vim.o.wrap then
  vim.o.breakindent = true
  vim.o.linebreak = true
end

vim.o.splitbelow = true
vim.o.splitright = true

-- Windows specific options
if utils.is_windows() then
  vim.o.shell = vim.fn.executable "powershell" and "powershell" or "pwsh"
  vim.o.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.o.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
end

vim.fn.sign_define("DiagnosticSignError", { text = utils.icons.error .. " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = utils.icons.warning .. " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = utils.icons.info .. " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = utils.icons.bulb, texthl = "DiagnosticSignHint" })

vim.filetype.add { extension = { ll = "llvm" } }
