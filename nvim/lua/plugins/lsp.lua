return {
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
    {
      "aznhe21/actions-preview.nvim",
      opts = {
        backend = { "snacks" },
        snacks = {
          layout = require("plugins.snacks").ivy_cursor,
        },
      },
      config = true,
    },
  },
  config = function()
    local lspconfig = require "lspconfig"
    local utils = require "utils"

    -- local codelldb_path, liblldb_path = require("utils").get_codelldb_paths()

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
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
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

        -- keymaps

        -- ---@type snacks.layout.Box
        -- local picker_layout = {
        --   layout = {
        --     box = "vertical",
        --     backdrop = false,
        --     row = 1,
        --     width = 0,
        --     height = 0.4,
        --     border = "top",
        --     title = " {title} {live} {flags}",
        --     title_pos = "left",
        --     position = "float",
        --     relative = "cursor",
        --     { win = "input", height = 1, border = "bottom" },
        --     {
        --       box = "horizontal",
        --       { win = "list", border = "none" },
        --       { win = "preview", title = "{preview}", width = 0.6, border = "left" },
        --       border = "bottom",
        --     },
        --   },
        -- }

        ---@type snacks.picker.Config
        local picker_opts = {
          layout = require("plugins.snacks").ivy_cursor,
        }

        vim.keymap.set("n", "gd", function()
          vim.api.nvim_feedkeys("zz", "n", true)
          Snacks.picker.lsp_definitions(picker_opts)
        end, opts "Go to Definition")

        vim.keymap.set("n", "gv", "<C-w>v<C-]>", opts "Go to Definition (VSplit)")

        vim.keymap.set("n", "grd", function()
          vim.api.nvim_feedkeys("zz", "n", true)
          Snacks.picker.lsp_declarations(picker_opts)
        end, opts "Declarations")

        vim.keymap.set("n", "grr", function()
          vim.api.nvim_feedkeys("zz", "n", true)
          Snacks.picker.lsp_references(picker_opts)
        end, opts "References")

        vim.keymap.set("n", "gt", function()
          vim.api.nvim_feedkeys("zz", "n", true)
          Snacks.picker.lsp_type_definitions(picker_opts)
        end, opts "Type Definitions")

        vim.keymap.set("n", "grt", function()
          vim.api.nvim_feedkeys("zz", "n", true)
          Snacks.picker.lsp_type_definitions(picker_opts)
        end, opts "Type Definitions")

        vim.keymap.set("n", "gri", function()
          vim.api.nvim_feedkeys("zz", "n", true)
          Snacks.picker.lsp_implementations(picker_opts)
        end, opts "Implementations")

        vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts "Rename")
        vim.keymap.set({ "n", "v" }, "gra", require("actions-preview").code_actions, opts "Code Action")
        vim.keymap.set({ "n", "v" }, "ga", require("actions-preview").code_actions, opts "Code Action")
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts "Signature Help")
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts "Hover")
        vim.keymap.set("n", "gh", function()
          local enable = not vim.lsp.inlay_hint.is_enabled { bufnr = buf }
          vim.lsp.inlay_hint.enable(enable, { bufnr = buf })
          vim.notify("Inlay hints " .. utils.bool_to_enabled(enable))
        end, opts "Toggle Inlay Hints")

        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump { count = -1, float = false }
        end, opts "Previous Diagnostic")
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump { count = 1, float = false }
        end, opts "Next Diagnostic")
      end,
    })

    vim.diagnostic.config {
      virtual_text = { current_line = true },
      virtual_lines = false,
      signs = {
        text = {
          [vim.diagnostic.severity.HINT] = utils.icons.hint,
          [vim.diagnostic.severity.INFO] = utils.icons.info,
          [vim.diagnostic.severity.WARN] = utils.icons.warning,
          [vim.diagnostic.severity.ERROR] = utils.icons.error,
        },
      },
    }

    local function enable_virtual_lines()
      vim.notify "Virtual lines enabled"
      vim.diagnostic.config { virtual_text = false, virtual_lines = true }
    end

    local function disable_virtual_lines()
      vim.notify "Virtual lines disabled"
      vim.diagnostic.config { virtual_text = { current_line = true }, virtual_lines = false }
    end

    vim.keymap.set("n", "<leader>l", function()
      local config = vim.diagnostic.config() or {}
      if config.virtual_lines then
        disable_virtual_lines()
      else
        enable_virtual_lines()
      end
    end, { desc = "LSP: Toggle line diagnostics" })

    vim.api.nvim_create_autocmd("User", {
      pattern = "DiagnosticChanged",
      callback = function()
        if vim.diagnostic.count() == 0 then
          disable_virtual_lines()
        end
      end,
    })
  end,
}
