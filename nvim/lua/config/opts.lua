-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- disable matchparen
vim.g.loaded_matchparen = 1

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
vim.opt.winborder = "none"
vim.opt.pumheight = 10
vim.opt.pumborder = "none"
vim.opt.shortmess:append({ c = true, C = true })
vim.opt.list = true
vim.opt.listchars = {
  -- eol = "↲",
  eol = " ",
  tab = "· ",
  nbsp = "␣",
  extends = "»",
  precedes = "«",
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
vim.opt.complete = { ".", "w", "b" }
vim.opt.completeopt = { "menuone", "noselect", "fuzzy", "nosort", "popup" }
vim.opt.path:append("**")
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
vim.opt.ttimeoutlen = 0

-- filetypes
vim.filetype.add({
  extension = { jsonc = "jsonc", ll = "llvm", mdx = "markdown" },
  filename = {
    [".gitconfig.local"] = "gitconfig",
    ["jsconfig.json"] = "jsonc",
    ["tsconfig.json"] = "jsonc",
  },
  pattern = { [".*/%.vscode/.*%.json"] = "jsonc", [".*/vicinae/settings%.json"] = "jsonc" },
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
vim.opt.foldopen:remove("search")
vim.opt.foldcolumn = "0"
vim.opt.foldlevelstart = 0

-- use system clipboard by default
vim.opt.clipboard:append("unnamedplus")

if vim.env.SSH_CONNECTION then
  local function vim_paste()
    local content = vim.fn.getreg('"')
    return vim.split(content, "\n")
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = vim_paste,
      ["*"] = vim_paste,
    },
  }
end

-- terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = require("augroup"),
  desc = "Configure :terminal buffer",
  callback = function()
    vim.opt_local.signcolumn = "auto"
    vim.keymap.set("n", "<cr>", "i<cr><c-\\><c-n>", { buf = 0 })
    vim.keymap.set("n", "<c-c>", "i<c-c><c-\\><c-n>", { buf = 0 })
  end,
})

require("vim._core.ui2").enable({ enable = true, msg = { target = "msg" } })
