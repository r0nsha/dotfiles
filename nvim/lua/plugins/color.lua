return {
  {
    "uga-rosa/ccc.nvim",
    event = "VeryLazy",
    config = function()
      local ccc = require "ccc"
      local mapping = ccc.mapping

      ccc.setup {
        default_color = "#ff0000",
        preserve = true,
        inputs = {
          ccc.input.hsl,
          ccc.input.rgb,
          ccc.input.cmyk,
        },
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
        win_opts = {
          border = "single",
        },
        mappings = {
          ["<esc>"] = mapping.quit,
          ["<c-p>"] = mapping.goto_prev,
          ["<c-n>"] = mapping.goto_next,
          ["H"] = mapping.decrease10,
          ["L"] = mapping.increase10,
        },
        highlight_mode = "bg",
      }

      vim.keymap.set("n", "<leader>cp", "<cmd>CccPick<cr>", { desc = "Pick Color" })

      vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CccConvert<cr>", { desc = "Convert Color" })
    end,
  },
  {
    "rktjmp/lush.nvim",
    event = "VeryLazy",
  },
}
