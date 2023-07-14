return {
  {
    "mhartington/formatter.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local prettierd = require "formatter.defaults".prettierd

      require("formatter").setup {
        filetype = {
          javasriptreact = { prettierd },
          typescript = { prettierd },
          typescriptreact = { prettierd },
          json = { prettierd },
          jsonc = { prettierd },
          vue = { prettierd },
          css = { prettierd },
          scss = { prettierd },
          less = { prettierd },
          html = { prettierd },
          graphql = { prettierd },
          handlebars = { prettierd },
          markdown = { prettierd },
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
