require("extensions")
require("config")
require("pass")
require("colors")

vim.cmd.packadd("nvim.undotree")

require("vim._extui").enable({
  enable = true,
  msg = { target = "cmd", timeout = 2000 },
})

vim.pack.add({
  { src = "https://github.com/miikanissi/modus-themes.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/nvim-mini/mini.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/williamboman/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/b0o/schemastore.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
  { src = "https://github.com/Wansmer/treesj" },
  { src = "https://github.com/folke/snacks.nvim" },
  -- { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  { src = "https://github.com/otavioschwanck/arrow.nvim" },
  { src = "https://github.com/milanglacier/minuet-ai.nvim" },
  { src = "https://github.com/uga-rosa/ccc.nvim" },
  { src = "https://github.com/xzbdmw/colorful-menu.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = "v1.8.0" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/mrjones2014/smart-splits.nvim" },
  { src = "https://github.com/rebelot/heirline.nvim" },
  { src = "https://github.com/Zeioth/heirline-components.nvim" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/igorlfs/nvim-dap-view" },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
  { src = "https://github.com/Weissle/persistent-breakpoints.nvim" },
  { src = "https://github.com/nvimtools/hydra.nvim" },
  { src = "https://github.com/jbyuki/one-small-step-for-vimkind" },
  { src = "https://github.com/jake-stewart/multicursor.nvim" },
  { src = "https://github.com/r0nsha/multinput.nvim" },
  -- { src = "https://github.com/r0nsha/qfpreview.nvim" },
  { src = "https://github.com/stevearc/quicker.nvim" },
  { src = "https://github.com/FabijanZulj/blame.nvim" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/ruifm/gitlinker.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/julienvincent/hunk.nvim" },
  { src = "https://github.com/rafikdraoui/jj-diffconflicts" },
  { src = "https://github.com/avm99963/vim-jjdescription" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/chomosuke/typst-preview.nvim", version = "v1.4.1" },
  { src = "https://github.com/stevearc/overseer.nvim" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/nvim-neotest/neotest" },
  { src = "https://github.com/marilari88/neotest-vitest" },
})

require("plugins.colorscheme")
require("plugins.treesitter")
require("plugins.lazydev")
require("plugins.lsp")
require("plugins.format")
require("plugins.lint")
require("plugins.mini")
require("plugins.cmp")
require("plugins.smart_splits")
require("plugins.heirline")
require("plugins.oil")
require("plugins.snacks.picker")
-- require("plugins.harpoon")
require("plugins.arrow")
require("plugins.ai")
require("plugins.ccc")
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
