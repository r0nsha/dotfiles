require("extensions")
require("config")
require("pass")
require("colors")

local src = require("utils.pack").src

vim.cmd.packadd("nvim.undotree")

-- load colorscheme first
vim.pack.add({ src.gh("miikanissi/modus-themes.nvim") })
require("plugins.colorscheme")

vim.pack.add({
  src.gh("nvim-lua/plenary.nvim"),
  src.gh("folke/lazydev.nvim"),
  src.gh("rafamadriz/friendly-snippets"),
  src.gh("nvim-mini/mini.nvim"),
  "https://tangled.org/ronshavit.com/mini.diff.jj",
  src.gh("neovim/nvim-lspconfig"),
  src.gh("williamboman/mason.nvim"),
  src.gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  src.gh("b0o/schemastore.nvim"),
  src.gh("stevearc/conform.nvim"),
  src.gh("rachartier/tiny-inline-diagnostic.nvim"),
  { src = src.gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  { src = src.gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
  src.gh("JoosepAlviste/nvim-ts-context-commentstring"),
  src.gh("Wansmer/treesj"),
  src.gh("folke/snacks.nvim"),
  { src = src.gh("ThePrimeagen/harpoon"), version = "harpoon2" },
  src.gh("milanglacier/minuet-ai.nvim"),
  src.gh("xzbdmw/colorful-menu.nvim"),
  { src = src.gh("saghen/blink.cmp"), version = "v1.8.0" },
  { src = src.gh("saghen/blink.compat"), version = "v2.5.0" },
  src.gh("stevearc/oil.nvim"),
  -- src.gh("A7Lavinraj/fyler.nvim"),
  src.gh("mrjones2014/smart-splits.nvim"),
  src.gh("rebelot/heirline.nvim"),
  src.gh("mfussenegger/nvim-dap"),
  src.gh("mfussenegger/nvim-lint"),
  src.gh("igorlfs/nvim-dap-view"),
  src.gh("Weissle/persistent-breakpoints.nvim"),
  src.gh("nvimtools/hydra.nvim"),
  src.gh("jbyuki/one-small-step-for-vimkind"),
  src.gh("jake-stewart/multicursor.nvim"),
  src.gh("r0nsha/multinput.nvim"),
  src.gh("stevearc/quicker.nvim"),
  src.gh("esmuellert/codediff.nvim"),
  src.gh("ruifm/gitlinker.nvim"),
  src.gh("MunifTanjim/nui.nvim"),
  src.gh("julienvincent/hunk.nvim"),
  src.gh("rafikdraoui/jj-diffconflicts"),
  src.tngl("ronshavit.com/jjannotate.nvim"),
  { src = src.gh("chomosuke/typst-preview.nvim"), version = "v1.4.1" },
  src.gh("tpope/vim-dadbod"),
  src.gh("kristijanhusak/vim-dadbod-ui"),
  src.gh("kristijanhusak/vim-dadbod-completion"),
})

require("plugins.treesitter")
require("plugins.treesitter_textobjects")
require("plugins.comment")
require("plugins.lazydev")
require("plugins.lsp")
require("plugins.format")
require("plugins.lint")
require("plugins.mini")
require("plugins.cmp")
require("plugins.smart_splits")
require("plugins.heirline")
require("plugins.explorer")
require("plugins.snacks")
require("plugins.harpoon")
require("plugins.ai")
require("plugins.multicursor")
require("plugins.multinput")
require("plugins.quickfix")
require("plugins.vcs")
require("plugins.typst")
require("plugins.undotree")
require("plugins.dap")
require("plugins.db")
