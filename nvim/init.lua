require("extensions")
require("config")
require("pass")
require("colors")

vim.cmd.packadd("nvim.undotree")

vim.pack.add({
  "https://github.com/miikanissi/modus-themes.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/nvim-mini/mini.nvim",
  "https://tangled.org/ronshavit.com/mini.diff.jj",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/b0o/schemastore.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
  "https://github.com/Wansmer/treesj",
  "https://github.com/folke/snacks.nvim",
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  "https://github.com/milanglacier/minuet-ai.nvim",
  "https://github.com/xzbdmw/colorful-menu.nvim",
  { src = "https://github.com/saghen/blink.cmp", version = "v1.8.0" },
  { src = "https://github.com/saghen/blink.compat", version = "v2.5.0" },
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/A7Lavinraj/fyler.nvim",
  "https://github.com/mrjones2014/smart-splits.nvim",
  "https://github.com/rebelot/heirline.nvim",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/igorlfs/nvim-dap-view",
  "https://github.com/Weissle/persistent-breakpoints.nvim",
  "https://github.com/nvimtools/hydra.nvim",
  "https://github.com/jbyuki/one-small-step-for-vimkind",
  "https://github.com/jake-stewart/multicursor.nvim",
  "https://github.com/r0nsha/multinput.nvim",
  -- "https://github.com/r0nsha/qfpreview.nvim" ,
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/FabijanZulj/blame.nvim",
  "https://github.com/esmuellert/codediff.nvim",
  "https://github.com/ruifm/gitlinker.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/julienvincent/hunk.nvim",
  "https://github.com/rafikdraoui/jj-diffconflicts",
  "https://github.com/avm99963/vim-jjdescription",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  { src = "https://github.com/chomosuke/typst-preview.nvim", version = "v1.4.1" },
  "https://github.com/stevearc/overseer.nvim",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/marilari88/neotest-vitest",
  "https://github.com/tpope/vim-dadbod",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/kristijanhusak/vim-dadbod-completion",
})

require("plugins.colorscheme")
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
require("plugins.oil")
require("plugins.fyler")
require("plugins.snacks")
require("plugins.harpoon")
require("plugins.ai")
require("plugins.multicursor")
require("plugins.multinput")
require("plugins.quickfix")
require("plugins.vcs")
require("plugins.markdown")
require("plugins.typst")
require("plugins.undotree")
require("plugins.dap")
require("plugins.overseer")
require("plugins.neotest")
require("plugins.db")

local function pack_complete()
  return vim.tbl_map(function(p) return p.spec.name end, vim.pack.get())
end

vim.api.nvim_create_user_command("PackUpdate", function(args)
  local name = args.args
  if name ~= "" then
    vim.pack.update({ name })
  else
    vim.pack.update()
  end
end, { nargs = "?", complete = pack_complete })

vim.api.nvim_create_user_command("PackDel", function(args)
  local name = args.args
  if name ~= "" then
    vim.pack.del({ name })
  else
    vim.pack.del()
  end
end, { nargs = "?", complete = pack_complete })
