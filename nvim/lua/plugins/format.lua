return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require "conform"
    local prettier = { "prettierd", "prettier", stop_after_first = true }
    local biome_or_prettier = { "biome", "prettierd", "prettier", stop_after_first = true }

    conform.setup {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        javascript = biome_or_prettier,
        javascriptreact = biome_or_prettier,
        typescript = biome_or_prettier,
        typescriptreact = biome_or_prettier,
        json = biome_or_prettier,
        jsonc = biome_or_prettier,
        vue = biome_or_prettier,
        css = biome_or_prettier,
        scss = biome_or_prettier,
        less = biome_or_prettier,
        html = biome_or_prettier,
        graphql = prettier,
        handlebars = prettier,
        markdown = prettier,
        c = { "qmkfmt", "clang-format", stop_after_first = true },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        fish = { "fish_indent" },
        toml = { "taplo" },
        yaml = { "yamlfmt" },
        xml = { "xmlformatter" },
        go = {
          "gofumpt",
          "goimports-reviser",
          "golines",
        },
        ["_"] = { "trim_whitespace" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
      },
      formatters = {
        qmkfmt = {
          command = "qmkfmt",
          args = { "$FILENAME" },
          stdin = false,
          condition = function(_, ctx)
            if ctx.filename:find "[qmk_firmware|qmk_userspace]" == nil then
              return false
            end

            if ctx.filename:find "[keymap.c]" == nil then
              return false
            end

            return true
          end,
        },
      },
    }

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format {}
    end, { remap = false, desc = "Conform: Format" })
  end,
}
