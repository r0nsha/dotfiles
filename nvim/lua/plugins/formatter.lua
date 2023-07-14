return {
  {
    "mhartington/formatter.nvim",
    config = function()
      -- local util = require "formatter.util"

      require("formatter").setup {
        filetype = {
          lua = {
            require("formatter.filetypes.lua").stylua,
          },
          sh = {
            require("formatter.filetypes.sh").shfmt,
          },
          fish = {
            require("formatter.filetypes.fish").fishindent,
          },
        },

        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace,
        },
      }

      vim.keymap.set({ "n", "v" }, "<leader>f", "<cmd>Format<cr>", { silent = false, desc = "Format document (Formatter)" })
    end,
  },
}
