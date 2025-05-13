return {
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "stevearc/conform.nvim",
      "yioneko/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "j-hui/fidget.nvim",
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
      local lspconfig = require "lspconfig"

      -- Add cmp_nvim_lsp capabilities settings to lspconfig
      local lspconfig_defaults = require("lspconfig").util.default_config
      lspconfig_defaults.capabilities =
        vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local buf = event.buf
          local id = vim.tbl_get(event, "data", "client_id")
          local client = id and vim.lsp.get_client_by_id(id)
          if client == nil then
            return
          end
          local opts = { buffer = buf }

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
        end,
      })

      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            telemetry = {
              enable = false,
            },
          },
        },
        on_init = function(client)
          local join = vim.fs.joinpath
          local path = client.workspace_folders[1].name

          -- Don't do anything if there is project local config
          if vim.uv.fs_stat(join(path, ".luarc.json")) or vim.uv.fs_stat(join(path, ".luarc.jsonc")) then
            return
          end

          local nvim_settings = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                -- Make the server aware of Neovim runtime files
                vim.env.VIMRUNTIME,
                vim.fn.stdpath "config",
              },
            },
          }

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, nvim_settings)
        end,
      }

      lspconfig.ts_ls.setup {
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

      lspconfig.unocss.setup {}
      lspconfig.biome.setup {}

      lspconfig.clangd.setup {}

      lspconfig.gopls.setup {
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            env = {
              GOEXPERIMENT = "rangefunc",
            },
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      }

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
    version = "^4",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = function()
        local cfg = require "rustaceanvim.config"
        local codelldb_path, liblldb_path = require("config.utils").get_codelldb_paths()

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
                  punctuation = {
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
