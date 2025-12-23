-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_matchparen = 1

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

vim.opt.signcolumn = "yes"
vim.opt.laststatus = 2
vim.opt.showmode = true
vim.opt.cmdheight = 1
vim.opt.showcmdloc = "statusline"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 0
vim.opt.concealcursor = ""
vim.opt.list = true
vim.opt.listchars = {
  eol = "↲",
  tab = "󰧟 ",
  nbsp = "¬",
  extends = "»",
  precedes = "«",
  trail = " ",
  multispace = " ",
  lead = " ",
}
vim.opt.fillchars:append { diff = "╱" }
vim.opt.winborder = "single"

-- wrap
vim.opt.wrap = false
vim.opt.showbreak = ""
vim.opt.breakindent = true
vim.opt.linebreak = true

-- title
vim.opt.title = true
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

-- files
vim.opt.isfname:append "@-@"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.shada = { "'10", "<0", "s10", "h" }
vim.opt.updatetime = 300
vim.opt.timeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false

-- filetypes
vim.filetype.add {
  extension = { ll = "llvm", mdx = "markdown" },
  filename = { [".gitconfig.local"] = "gitconfig" },
}
vim.treesitter.language.register("markdown", "mdx")

-- behavior
vim.opt.hidden = true
vim.opt.visualbell = true
vim.opt.backspace = { "indent", "start", "eol" }
vim.opt.autochdir = false
vim.opt.path:append "**"
vim.opt.modifiable = true
vim.opt.encoding = "utf-8"
vim.opt.more = false

-- diff
vim.opt.diffopt:append "iwhite"
vim.opt.diffopt:append "algorithm:histogram"
vim.opt.diffopt:append "indent-heuristic"

-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- disable startup message
vim.opt.shortmess:append { I = true }

-- mouse
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup_setpos"

-- fold
vim.o.foldenable = false
vim.o.foldmethod = "manual"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.opt.foldcolumn = "1"
vim.opt.foldminlines = 1
vim.opt.foldnestmax = 3
vim.opt.fillchars:append {
  fold = "󰧟",
  foldopen = "",
  foldclose = "",
}

-- use system clipboard by default
-- vim.opt.clipboard:append "unnamedplus"

if vim.env.SSH_CONNECTION then
  local function vim_paste()
    local content = vim.fn.getreg '"'
    return vim.split(content, "\n")
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy "+",
      ["*"] = require("vim.ui.clipboard.osc52").copy "*",
    },
    paste = {
      ["+"] = vim_paste,
      ["*"] = vim_paste,
    },
  }
end
