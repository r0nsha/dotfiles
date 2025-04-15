return {
  {
    "mhartington/formatter.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local defaults = require "formatter.defaults"
      local jsformatter = defaults.biome
      local clangformat = defaults.clangformat

      require("formatter").setup {
        filetype = {
          javascript = { jsformatter },
          javascriptreact = { jsformatter },
          typescript = { jsformatter },
          typescriptreact = { jsformatter },
          json = { jsformatter },
          jsonc = { jsformatter },
          vue = { jsformatter },
          css = { jsformatter },
          scss = { jsformatter },
          less = { jsformatter },
          html = { jsformatter },
          graphql = { jsformatter },
          handlebars = { jsformatter },
          markdown = { jsformatter },
          c = { clangformat },
          cpp = { clangformat },
          lua = {
            require("formatter.filetypes.lua").stylua,
          },
          sh = {
            require("formatter.filetypes.sh").shfmt,
          },
          fish = {
            require("formatter.filetypes.fish").fishindent,
          },
          toml = {
            require("formatter.filetypes.toml").taplo,
          },
          yaml = {
            require("formatter.filetypes.yaml").yamlfmt,
          },
          python = {
            require("formatter.filetypes.python").black,
            require("formatter.filetypes.python").isort,
          },
          xml = {
            require("formatter.filetypes.xml").xmlformat,
          },
        },

        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace,
        },
      }

      vim.keymap.set(
        { "n", "v" },
        "<leader>f",
        "<cmd>Format<cr>",
        { silent = false, desc = "Format document (Formatter)" }
      )
    end,
  },
}
