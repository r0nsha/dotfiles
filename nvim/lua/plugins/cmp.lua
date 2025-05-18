return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    version = "*",
    dependencies = {
      -- snippets
      "rafamadriz/friendly-snippets",

      -- sources
      "Kaiser-Yang/blink-cmp-git",

      -- misc
      "xzbdmw/colorful-menu.nvim",
    },
    config = function()
      local cmp = require "blink.cmp"

      local keymaps = {
        prev = {
          "snippet_backward",
          "select_prev",
          "show",
          "fallback_to_mappings",
        },

        next = {
          "snippet_forward",
          "select_next",
          "show",
          "fallback_to_mappings",
        },

        scroll_documentation_up = { "scroll_documentation_up", "fallback" },
        scroll_documentation_down = { "scroll_documentation_down", "fallback" },

        toggle_signature = { "show_signature", "hide_signature", "fallback" },
      }

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
              preselect = true,
              auto_insert = false,
            },
          },
          menu = {
            auto_show = function(ctx)
              return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
            end,
            draw = {
              -- We don't need label_description now because label and label_description are already
              -- combined together in label by colorful-menu.nvim.
              columns = { { "kind_icon" }, { "label", gap = 1 } },
              components = {
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end,
                },
              },
            },
          },
        },
        fuzzy = {
          implementation = "prefer_rust_with_warning",
          prebuilt_binaries = {
            download = false,
          },
          sorts = { "exact", "score", "sort_text", "kind", "label" },
        },
        keymap = {
          preset = "none",
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<C-y>"] = { "select_and_accept" },

          ["<C-p>"] = keymaps.prev,
          ["<C-n>"] = keymaps.next,
          ["<Up>"] = keymaps.prev,
          ["<Down>"] = keymaps.next,
          ["S-Tab"] = keymaps.prev,
          ["Tab"] = keymaps.next,

          ["<C-b>"] = keymaps.scroll_documentation_up,
          ["<C-f>"] = keymaps.scroll_documentation_down,
          ["<C-u>"] = keymaps.scroll_documentation_up,
          ["<C-d>"] = keymaps.scroll_documentation_down,

          ["<C-h>"] = keymaps.toggle_signature,
          ["<C-k>"] = keymaps.toggle_signature,
        },
        sources = {
          default = { "lazydev", "lsp", "snippets", "git", "path", "buffer" },
          providers = {
            git = {
              module = "blink-cmp-git",
              name = "Git",
              enabled = function()
                -- Allow git completions in specific filetypes
                if vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype) then
                  return true
                end

                -- Otherwise, only allow git completions in comments/strings
                local row, column = unpack(vim.api.nvim_win_get_cursor(0))
                local success, node = pcall(vim.treesitter.get_node, {
                  pos = { row - 1, math.max(0, column - 1) },
                  ignore_injections = false,
                })
                local accepted_nodes =
                  { "comment", "line_comment", "block_comment", "string_start", "string_content", "string_end" }
                if success and node and vim.tbl_contains(accepted_nodes, node:type()) then
                  return true
                end

                return false
              end,
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
          completion = {
            ghost_text = { enabled = true },
            list = {
              selection = {
                preselect = true,
                auto_insert = false,
              },
            },
            menu = {
              auto_show = true,
              draw = {
                -- We don't need label_description now because label and label_description are already
                -- combined together in label by colorful-menu.nvim.
                columns = { { "label", gap = 1 } },
                components = {
                  label = {
                    text = function(ctx)
                      return require("colorful-menu").blink_components_text(ctx)
                    end,
                    highlight = function(ctx)
                      return require("colorful-menu").blink_components_highlight(ctx)
                    end,
                  },
                },
              },
            },
          },
        },
        signature = { enabled = true },
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
