return {
  -- Lsp
  {
    "VonHeikemen/lsp-zero.nvim",
    lazy = true,
    command = { "LspZeroSetupServers" },
    config = function()
      require("lsp-zero.settings").preset {}
    end,
  },
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
      {
        "williamboman/mason.nvim",
        build = function()
          vim.cmd [[MasonUpdate]]
        end,
        config = true,
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
        "rust_analyzer", -- Replaced by rust-tools
        "rome", -- Rome's lsp makes things slow af
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

      lsp.setup()

      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = false,
      }
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
          null_ls.builtins.formatting.yamlfmt,
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
    "simrat39/rust-tools.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
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
    end,
  },
  {
    "akinsho/flutter-tools.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "reisub0/hot-reload.vim" },
    config = function()
      local lsp = require "lsp-zero"
      local dart_lsp = lsp.build_options("dartls", {})

      require("flutter-tools").setup {
        lsp = {
          capabilities = dart_lsp.capabilities,
        },
      }
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("fidget").setup {}
    end,
  },
}
