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
            vim.fn.stdpath("config"),
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
  basedpyright = {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          ignore = { "*" },
        },
      },
    },
  },
  marksman = {},
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
  "basedpyright",

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
  "ruff",

  -- dap
  "delve",
  -- "codelldb",
}
vim.list_extend(ensure_installed, servers_to_install)
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

vim.lsp.enable(vim.tbl_keys(servers))

vim.lsp.config("*", {
  capabilities = {},
})

for server, config in pairs(servers) do
  if type(config) == "table" then
    vim.lsp.config(server, config)
  end
end
