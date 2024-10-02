return {
  -- Lsp
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
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
      local lsp_zero = require "lsp-zero"
      local lspconfig = require "lspconfig"

      lsp_zero.preset "recommended"

      lsp_zero.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gv", "<cmd>vs<cr>gd", opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gR", function()
          require("fzf-lua").lsp_references {}
        end, opts)
        vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>ws", function()
          require("fzf-lua").lsp_workspace_symbols {}
        end, opts)

        if client.server_capabilities.documentFormattingProvider then
          vim.keymap.set({ "n", "v" }, "<leader>f", function()
            vim.lsp.buf.format { async = false, timeout_ms = 10000 }
          end, { buffer = bufnr, remap = false, desc = "Format document (LSP)" })
        else
          vim.keymap.set(
            { "n", "v" },
            "<leader>f",
            "<cmd>Format<cr>",
            { buffer = bufnr, remap = false, desc = "Format document (Formatter)" }
          )
        end
      end)

      require("mason-lspconfig").setup {
        ensure_installed = {
          "ts_ls",
          "cssls",
          "rust_analyzer",
          "lua_ls",
        },
        handlers = {
          lsp_zero.default_setup,
          rust_analyzer = lsp_zero.noop,
        },
      }

      local function disable_formatting(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentFormattingRangeProvider = false
      end

      lspconfig.lua_ls.setup(lsp_zero.nvim_lua_ls {
        on_init = function(client)
          disable_formatting(client) -- We use stylua instead
        end,
      })

      lspconfig.ts_ls.setup {
        on_init = function(client)
          disable_formatting(client) -- We use Prettier instead
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

      lspconfig.clangd.setup {}

      lsp_zero.setup()

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
        -- javascript = { "eslint_d" },
        -- javascriptreact = { "eslint_d" },
        -- typescript = { "eslint_d" },
        -- typescriptreact = { "eslint_d" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = function()
        local cfg = require "rustaceanvim.config"
        local codelldb_path, liblldb_path = require("utils").get_codelldb_paths()

        return {
          server = {
            settings = {
              ["rust-analyzer"] = {
                imports = {
                  granularity = {
                    group = "module",
                  },
                  prefix = "self",
                },
                assist = {
                  importEnforceGranularity = true,
                  importPrefix = "crate",
                  emitMustUse = true,
                },
                cargo = {
                  features = "all",
                  allFeatures = true,
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
                  disabled = { "inactive-code" },
                },
                procMacro = {
                  enable = true,
                },
                semanticHighlighting = {
                  operator = { specialization = { enable = true } },
                  puncutation = {
                    enable = true,
                    specialization = { enable = true },
                    separate = { macro = { bang = true } },
                  },
                },
              },
            },
          },
          dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
          },
        }
      end
    end,
  },
  {
    "dgagn/diagflow.nvim",
    event = "LspAttach",
    config = function()
      require("diagflow").setup {}
    end,
  },
}
