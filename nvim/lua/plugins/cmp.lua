return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    version = "*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "Kaiser-Yang/blink-cmp-git",
    },
    config = function()
      local cmp = require "blink.cmp"

      cmp.setup {
        appearance = {
          nerd_font_variant = "mono",
        },
        completion = {
          documentation = {
            auto_show = true,
          },
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
        },
        fuzzy = {
          implementation = "prefer_rust_with_warning",
          prebuilt_binaries = {
            download = false,
          },
        },
        keymap = {
          preset = "default",
          -- ["<C-d>"] = function()
          --   cmp.scroll_documentation_down(4)
          -- end,
          -- ["<C-u>"] = function()
          --   cmp.scroll_documentation_up(4)
          -- end,
        },
        sources = {
          default = { "git", "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            git = {
              module = "blink-cmp-git",
              name = "Git",
              opts = {},
            },
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
          },
        },
        cmdline = {
          -- keymap = { preset = "inherit" },
          completion = { menu = { auto_show = true } },
        },
      }
    end,
  },
  -- {
  --   "yioneko/nvim-cmp",
  --   enable = false,
  --   branch = "perf",
  --   event = { "InsertEnter", "CmdlineEnter" },
  --   dependencies = {
  --     {
  --       "L3MON4D3/LuaSnip",
  --       version = "v2.*",
  --       build = "make install_jsregexp",
  --       dependencies = {
  --         {
  --           "rafamadriz/friendly-snippets",
  --           config = function
  --             local loader = require "luasnip.loaders.from_vscode"
  --             loader.lazy_load
  --             loader.lazy_load {
  --               paths = {
  --                 "../../snippets/typescript",
  --                 "../../snippets/python",
  --               },
  --             }
  --           end,
  --         },
  --       },
  --     },
  --     "saadparwaiz1/cmp_luasnip",
  --     "hrsh7th/cmp-buffer",
  --     "hrsh7th/cmp-path",
  --     "hrsh7th/cmp-cmdline",
  --     "petertriho/cmp-git",
  --     "onsails/lspkind-nvim",
  --   },
  --   config = function
  --     local luasnip = require "luasnip"
  --
  --     luasnip.filetype_extend("all", { "_" })
  --
  --     local cmp = require "cmp"
  --
  --     cmp.setup {
  --       sources = cmp.config.sources {
  --         { name = "nvim_lsp" },
  --         { name = "luasnip" },
  --         { name = "neorg" },
  --         { name = "git" },
  --         { name = "path" },
  --         {
  --           name = "buffer",
  --           keyword_length = 3,
  --           option = {
  --             get_bufnrs = function()
  --               local bufs = {}
  --               for _, win in ipairs(vim.api.nvim_list_wins()) do
  --                 bufs[vim.api.nvim_win_get_buf(win)] = true
  --               end
  --               return vim.tbl_keys(bufs)
  --             end,
  --           },
  --         },
  --       },
  --       mapping = cmp.mapping.preset.insert {
  --         ["<C-.>"] = cmp.mapping.complete(),
  --         ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
  --         ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
  --         ["<C-y>"] = cmp.mapping.confirm({
  --           behavior = cmp.ConfirmBehavior.Insert,
  --           select = true,
  --         }, { "i", "c" }),
  --         ["<C-u>"] = cmp.mapping.scroll_docs(-4),
  --         ["<C-d>"] = cmp.mapping.scroll_docs(4),
  --       },
  --       snippet = {
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --       window = {
  --         completion = cmp.config.window.bordered(),
  --         documentation = cmp.config.window.bordered(),
  --       },
  --       formatting = {
  --         fields = { "abbr", "kind", "menu" },
  --         format = require("lspkind").cmp_format {
  --           mode = "symbol_text",
  --           preset = "default",
  --         },
  --       },
  --       experimental = {
  --         ghost_text = false,
  --       },
  --     }
  --
  --     require("cmp_git").setup()
  --
  --     cmp.setup.filetype("gitcommit", {
  --       sources = cmp.config.sources({
  --         { name = "cmp_git" },
  --         { name = "git" },
  --       }, {
  --         { name = "buffer" },
  --       }),
  --     })
  --
  --     cmp.setup.cmdline({ "/", "?" }, {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = {
  --         { name = "buffer" },
  --       },
  --     })
  --
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = cmp.config.sources({
  --         { name = "path" },
  --       }, {
  --         { name = "cmdline" },
  --       }),
  --     })
  --
  --     vim.cmd [[highlight! default link CmpItemKind CmpItemMenuDefault]]
  --   end,
  -- },
}
