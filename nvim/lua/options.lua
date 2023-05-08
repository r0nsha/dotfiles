local utils = require("utils")

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.shadafile = ""

vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.backspace = "indent,start,eol"
vim.opt.clipboard = "unnamedplus"

vim.opt.autoread = true
vim.opt.autoindent = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.termguicolors = true

vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.joinspaces = true

vim.opt.cursorline = true

vim.opt.wrap = false

if vim.opt.wrap then
	vim.opt.linebreak = true
	vim.opt.breakindent = true
end

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Windows specific options
if utils.is_windows() then
	vim.opt.shell = vim.fn.executable("powershell") and "powershell" or "pwsh"
	vim.opt.shellcmdflag =
		"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
	vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
	vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
end

vim.fn.sign_define("DiagnosticSignError", { text = utils.icons.error .. " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = utils.icons.warning .. " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = utils.icons.info .. " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = utils.icons.bulb, texthl = "DiagnosticSignHint" })
