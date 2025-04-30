local utils = require "config.utils"

-- disable netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.o.shadafile = ""

vim.o.mouse = "a"
vim.o.mousemodel = "popup_setpos"
vim.o.guicursor = ""
vim.opt.background = "dark"

vim.opt.shortmess:append { I = true }
vim.o.completeopt = "menuone,noselect"
vim.o.backspace = "indent,start,eol"
vim.o.swapfile = false
vim.o.backup = false

vim.o.autoread = true
vim.o.autoindent = true
vim.o.colorcolumn = "80"
vim.o.fixeol = false

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

vim.opt.list = true
vim.opt.listchars = {
  eol = "↲",
  tab = "» ",
  multispace = " ",
  lead = " ",
  trail = " ",
  nbsp = " ",
}

vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

vim.o.hidden = true
vim.o.ignorecase = true
vim.o.joinspaces = true

vim.o.cursorline = true

vim.o.wrap = true
if vim.o.wrap then
  vim.o.showbreak = ""
  vim.o.breakindent = true
  vim.o.linebreak = true
end

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.conceallevel = 2

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

-- WSL specific options
if utils.is_wsl() then
  vim.g.clipboard = {
    name = "wslclipboard",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 1,
  }
end

vim.fn.sign_define("DiagnosticSignError", { text = utils.icons.error .. " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = utils.icons.warning .. " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = utils.icons.info .. " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = utils.icons.bulb, texthl = "DiagnosticSignHint" })

vim.filetype.add { extension = { ll = "llvm" } }

local gitconfig_group = vim.api.nvim_create_augroup("GitConfig", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.cmd "set ft=gitconfig"
  end,
  group = gitconfig_group,
  pattern = "*/git/config",
})
