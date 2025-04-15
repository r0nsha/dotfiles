return {
  {
    "mhartington/formatter.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local defaults = require "formatter.defaults"
      local prettierd = defaults.prettierd
      local biome = defaults.biome
      local clangformat = defaults.clangformat

      require("formatter").setup {
        filetype = {
          javascript = { biome },
          javascriptreact = { biome },
          typescript = { biome },
          typescriptreact = { biome },
          json = { biome },
          jsonc = { biome },
          vue = { biome },
          css = { biome },
          scss = { biome },
          less = { biome },
          html = { biome },
          graphql = { prettierd },
          handlebars = { prettierd },
          markdown = { prettierd },
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
