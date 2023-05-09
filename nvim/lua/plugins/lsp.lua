return {
  -- Flutter tools
  { "akinsho/flutter-tools.nvim", event = "VeryLazy" },
  { "reisub0/hot-reload.vim",     event = "VeryLazy" },

  -- Lsp
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      -- Lsp
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
      {
        "j-hui/fidget.nvim",
        event = "BufRead",
        config = function()
          require("fidget").setup {}
        end,
      },
      "simrat39/rust-tools.nvim",
      {
        "williamboman/mason.nvim",
        build = function()
          vim.cmd [[MasonUpdate]]
        end,
        config = function()
          require("mason").setup()
        end,
      },
      {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
          local utils = require "utils"
          local null_ls = require "null-ls"

          null_ls.setup {
            sources = {
              null_ls.builtins.formatting.stylua,
              null_ls.builtins.formatting.rome.with {
                condition = function()
                  -- Disable Rome on my day job's MacOS
                  return not utils.is_macos()
                end,
              },
              -- Use prettierd for everything on my day job's MacOS
              null_ls.builtins.formatting.prettierd.with(utils.is_macos() and {} or {
                filetypes = {
                  -- NOTE: Remove js/ts/json formatting because rome handles those
                  -- "javascript",
                  -- "javascriptreact",
                  -- "typescript",
                  -- "typescriptreact",
                  -- "json",
                  -- "jsonc",
                  -- "yaml",
                  "vue",
                  "css",
                  "scss",
                  "less",
                  "html",
                  "markdown",
                  "markdown.mdx",
                  "graphql",
                  "handlebars",
                },
              }),
            },
          }
        end,
      },
      {
        "SmiteshP/nvim-navic",
        lazy = true,
        config = function()
          vim.g.navic_silence = true
          require("nvim-navic").setup {
            separator = " ",
            highlight = true,
            depth_limit = 5,
          }
        end,
      },

      -- Completion
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          {
            "L3MON4D3/LuaSnip",
            event = "InsertCharPre",
            build = "make install_jsregexp",
            dependencies = {
              {
                "rafamadriz/friendly-snippets",
                event = "InsertCharPre",
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
          {
            "folke/neodev.nvim",
            opts = {
              experimental = {
                pathStrict = true,
              },
            },
          },
        },
      },
    },
    config = function()
      local lsp = require "lsp-zero"
      local lspconfig = require "lspconfig"

      lsp.preset "recommended"

      lsp.ensure_installed {
        "tsserver",
        "cssls",
        "unocss",
        "rome",
        "rust_analyzer",
        "lua_ls",
        "yamlls",
      }

      lsp.skip_server_setup {
        "rust_analyzer", -- We setup rust_analyzer via rust-tools
        "rome",          -- FIXME: Rome makes things slow af
      }

      lsp.on_attach(function(client, buffer)
        local opts = { buffer = buffer, remap = false }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gR", function()
          require("telescope.builtin").lsp_references {}
        end, opts)
        vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>ws", function()
          require("telescope.builtin").lsp_workspace_symbols {}
        end, opts)

        -- lsp.buffer_autoformat()

        if client.server_capabilities.documentFormattingProvider then
          vim.keymap.set({ "n", "v", "x" }, "<leader>f", function()
            vim.lsp.buf.format { async = false, timeout_ms = 10000 }
          end, { buffer = buffer, remap = false, desc = "Format document" })
        end

        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)

      lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

      lspconfig.tsserver.setup {
        on_init = function(client)
          -- Disable formatting for tsserver, since we use Rome for this
          client.server_capabilities.document_formatting = false
          client.server_capabilities.document_range_formatting = false
        end,
        init_options = {
          preferences = {
            importModuleSpecifierPreference = "relative",
          },
        },
        commands = {
          OrganizeImports = {
            function()
              local params = {
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
                title = "",
              }
              vim.lsp.buf.execute_command(params)
            end,
            description = "Organize Imports",
          },
        },
      }

      lspconfig.cssls.setup {
        settings = {
          css = {
            lint = {
              unknownAtRules = "ignore",
            },
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          less = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      }

      lspconfig.unocss.setup {
        root_dir = require("lspconfig.util").root_pattern(
          "unocss.config.js",
          "unocss.config.ts",
          "uno.config.js",
          "uno.config.ts"
        ),
      }

      local rust_tools = require "rust-tools"

      rust_tools.setup {
        -- server = {
        -- 	on_attach = function(_, buffer)
        -- 		vim.keymap.set("n", "<leader>ca", rust_tools.hover_actions.hover_actions, { remap = false, buffer = buffer })
        -- 		vim.keymap.set("n", "ga", rust_tools.code_action_group.code_action_group, { remap = true, buffer = buffer })
        -- 	end
        -- },
        settings = {
          ["rust_analyzer"] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            assist = {
              importEnforceGranularity = true,
              importPrefix = "crate",
            },
            cargo = {
              allFeatures = true,
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = {
              command = "clippy",
            },
            procMacro = {
              enable = true,
            },
          },
        },
      }

      local dart_lsp = lsp.build_options("dartls", {})

      require("flutter-tools").setup {
        lsp = {
          capabilities = dart_lsp.capabilities,
        },
      }

      lsp.setup()

      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = false,
      }

      -- Completion

      local luasnip = require "luasnip"

      luasnip.filetype_extend("all", { "_" })

      local cmp = require "cmp"
      local cmp_action = require("lsp-zero").cmp_action()

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
          ["<C-,>"] = cmp.mapping.complete(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = cmp_action.luasnip_supertab(),
          ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
          ["<cr>"] = cmp.mapping.confirm { select = true },
          ["<S-cr>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "git" },
          { name = "path" },
          { name = "buffer",  keyword_length = 5 },
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
          ghost_text = {
            hl_group = "LspCodeLens",
          },
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
