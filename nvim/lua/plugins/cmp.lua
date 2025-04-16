return {
  {
    -- "hrsh7th/nvim-cmp",
    "yioneko/nvim-cmp",
    branch = "perf",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              local loader = require "luasnip.loaders.from_vscode"
              loader.lazy_load()
              loader.lazy_load {
                paths = {
                  "../../snippets/typescript",
                  "../../snippets/python",
                  "../../snippets/solidjs",
                },
              }
            end,
          },
        },
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "petertriho/cmp-git",
      "onsails/lspkind-nvim",
    },
    config = function()
      local luasnip = require "luasnip"

      luasnip.filetype_extend("all", { "_" })

      local cmp = require "cmp"

      cmp.setup {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-.>"] = cmp.mapping.complete(),
          ["C-y"] = cmp.mapping.confirm { select = true },
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "neorg" },
          { name = "git" },
          { name = "path" },
          {
            name = "buffer",
            keyword_length = 3,
            option = {
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end,
            },
          },
          -- { name = "cmdline" },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = require("lspkind").cmp_format {
            mode = "symbol_text",
            preset = "default",
          },
        },
        experimental = {
          ghost_text = false,
        },
      }

      require("cmp_git").setup()

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" },
          { name = "git" },
        }, {
          { name = "buffer" },
        }),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      vim.cmd [[highlight! default link CmpItemKind CmpItemMenuDefault]]
    end,
  },
}
