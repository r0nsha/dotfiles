require("extensions")
require("config")
require("theme")

local src = require("utils").pack.src

-- load colorscheme first
vim.pack.add({
  src.tngl("ronshavit.com/nor.nvim"),
  -- "file:///home/ron/dev/nor.nvim",
})
vim.g.nor_opts = {
  transparent = true,
  style = {
    -- statusline = { bg = "none" },
  },
}
vim.cmd.colorscheme("nor")

vim.pack.add({
  src.gh("nvim-lua/plenary.nvim"),
  src.gh("rafamadriz/friendly-snippets"),
  src.gh("nvim-mini/mini.nvim"),
  src.tngl("ronshavit.com/mini.diff.jj"),
  { src = src.gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  { src = src.gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
  src.gh("neovim/nvim-lspconfig"),
  src.gh("williamboman/mason.nvim"),
  src.gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  src.gh("b0o/schemastore.nvim"),
  src.gh("stevearc/conform.nvim"),
  src.gh("mfussenegger/nvim-lint"),
  src.gh("kylechui/nvim-surround"),
  src.gh("tpope/vim-endwise"),
  src.gh("JoosepAlviste/nvim-ts-context-commentstring"),
  src.gh("rachartier/tiny-inline-diagnostic.nvim"),
  src.gh("folke/snacks.nvim"),
  -- src.gh("milanglacier/minuet-ai.nvim"),
  -- src.gh("stevearc/oil.nvim"),
  src.gh("barrettruth/canola.nvim"),
  src.gh("mrjones2014/smart-splits.nvim"),
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
  src.gh("andymass/vim-matchup"),
  src.gh("Wansmer/treesj"),
})

require("plugins.treesitter")
require("plugins.treesitter_textobjects")
require("plugins.comment")
require("plugins.diagnostic")
require("plugins.lsp")
require("plugins.format")
require("plugins.lint")
require("plugins.mini")
require("plugins.smart_splits")
require("plugins.explorer")
require("plugins.snacks")
-- require("plugins.ai")
require("plugins.multicursor")
require("plugins.multinput")
require("plugins.quickfix")
require("plugins.vcs")
require("plugins.typst")
require("plugins.undotree")
require("plugins.db")
require("plugins.matchparen")
