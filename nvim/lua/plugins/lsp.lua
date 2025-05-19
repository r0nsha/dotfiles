return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        build = function()
          pcall(vim.cmd, "MasonToolsUpdate")
        end,
      },
      "stevearc/conform.nvim",
      "saghen/blink.cmp",
      "b0o/schemastore.nvim",
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    },
    config = function()
      local lspconfig = require "lspconfig"
      local utils = require "config.utils"

      -- local codelldb_path, liblldb_path = require("config.utils").get_codelldb_paths()

      local servers = {
        lua_ls = {
          manual_install = true,
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
        },
        ts_ls = {
          manual_install = true,
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
        },
        cssls = {
          manual_install = true,
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
        },
        unocss = { manual_install = true },
        biome = {},
        clangd = {},
        rust_analyzer = {
          manual_install = true,
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
          -- TODO: get Rust debugging to work
          -- dap = {
          --   adapter = {
          --     type = "server",
          --     port = "${port}",
          --     host = "127.0.0.1",
          --     executable = {
          --       command = codelldb_path,
          --       args = { "--liblldb", liblldb_path, "--port", "${port}" },
          --     },
          --   },
          -- },
        },
        gopls = {
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
        },
        jsonls = {
          manual_install = true,
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          manual_install = true,
          settings = {
            yaml = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
        emmet_language_server = { manual_install = true },
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require("mason").setup()

      local ensure_installed = {
        "typescript-language-server",
        "lua-language-server",
        "css-lsp",
        "unocss-language-server",
        "rust-analyzer",
        "gopls",
        "json-lsp",
        "yaml-language-server",
        "emmet-language-server",

        -- formatters
        "prettierd",
        "taplo",
        "stylua",
        "shfmt",
        "xmlformatter",
        "clang-format",
        "yamlfmt",
        "gofumpt",
        "goimports",
        "goimports-reviser",
        "golines",

        -- dap
        "delve",
        -- "codelldb",

        -- spell
        "codespell",
      }
      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      local capabilities = {
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true,
            },
          },
        },
      }

      for server, config in pairs(servers) do
        if config == true then
          config = {}
        end

        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        config.capabilities = vim.tbl_deep_extend("force", config.capabilities, capabilities)

        lspconfig[server].setup(config)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local buf = event.buf
          local id = vim.tbl_get(event, "data", "client_id")
          local client = id and vim.lsp.get_client_by_id(id)

          if client == nil then
            return
          end

          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
          end

          local opts = function(desc)
            return {
              buffer = buf,
              desc = "LSP: " .. desc,
            }
          end

          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts "Hover")
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to Definition")
          vim.keymap.set("n", "gv", "<cmd>vs<cr>gd", opts "Go to Definition (Vertical Split)")
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts "Go to Implementation")
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts "Go to Type Definition")
          vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts "Rename")
          vim.keymap.set("n", "grr", function()
            require("fzf-lua").lsp_references {}
          end, opts "References")
          vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts "Code Action")
          vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts "Signature Help")
          vim.keymap.set("n", "gws", function()
            require("fzf-lua").lsp_workspace_symbols {}
          end, opts "Workspace Symbols")
          vim.keymap.set("n", "gh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buf }, { bufnr = buf })
          end, opts "Toggle Inlay Hints")

          vim.keymap.set("n", "[d", function()
            vim.diagnostic.goto_prev { float = false }
          end, opts "Previous Diagnostic")
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.goto_next { float = false }
          end, opts "Next Diagnostic")
        end,
      })

      require("lsp_lines").setup {}

      vim.diagnostic.config {
        float = false, -- i use lsp_lines instead
        virtual_text = false,
        virtual_lines = {
          only_current_line = true,
          highlight_whole_line = true,
        },
        underline = true,
        update_in_insert = false,
        signs = {
          text = {
            [vim.diagnostic.severity.HINT] = utils.icons.hint,
            [vim.diagnostic.severity.INFO] = utils.icons.info,
            [vim.diagnostic.severity.WARN] = utils.icons.warning,
            [vim.diagnostic.severity.ERROR] = utils.icons.error,
          },
        },
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
}
