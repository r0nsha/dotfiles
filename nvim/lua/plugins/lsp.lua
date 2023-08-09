return {
  -- Lsp
  {
    "VonHeikemen/lsp-zero.nvim",
    lazy = true,
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
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
          require("fidget").setup {}
        end,
      },
      {
        "folke/neodev.nvim",
        opts = {
          experimental = {
            pathStrict = true,
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
      }

      lsp.skip_server_setup {
        "tsserver", -- Manual setup
        "rust_analyzer", -- Replaced by rust-tools
        "rome", -- Rome's lsp makes things slow af
      }

      lsp.on_attach(function(client, buffer)
        local opts = { buffer = buffer, remap = false }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
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

        if client.server_capabilities.documentFormattingProvider then
          vim.keymap.set({ "n", "v" }, "<leader>f", function()
            vim.lsp.buf.format { async = false, timeout_ms = 10000 }
          end, { buffer = buffer, remap = false, desc = "Format document (LSP)" })
        else
          vim.keymap.set(
            { "n", "v" },
            "<leader>f",
            "<cmd>Format<cr>",
            { buffer = buffer, remap = false, desc = "Format document (Formatter)" }
          )
        end

        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)

      local function disable_formatting(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentFormattingRangeProvider = false
      end

      lspconfig.lua_ls.setup(lsp.nvim_lua_ls {
        on_init = function(client)
          disable_formatting(client) -- We use stylua instead
        end,
      })

      lspconfig.tsserver.setup {
        on_init = function(client)
          disable_formatting(client) -- We use Rome/Prettier instead
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
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local rt = require "rust-tools"
      local utils = require "utils"

      local codelldb_path, liblldb_path = utils.get_codelldb_paths()

      rt.setup {
        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = function(_, bufnr)
            vim.keymap.set(
              "n",
              "<leader>K",
              rt.hover_actions.hover_actions,
              { buffer = bufnr, desc = "Rust tools: Hover actions" }
            )
            vim.keymap.set(
              "n",
              "<leader>A",
              rt.code_action_group.code_action_group,
              { buffer = bufnr, desc = "Rust tools: Code action group" }
            )
          end,
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
                autoReload = true,
                buildScripts = {
                  enable = true,
                },
              },
              check = {
                command = "clippy",
              },
              checkOnSave = true,
              inlayHints = {
                enable = false,
                locationLinks = false,
              },
              diagnostics = {
                enable = true,
                experimental = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }
    end,
  },
}
