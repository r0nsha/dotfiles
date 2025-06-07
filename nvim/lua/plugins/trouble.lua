return {
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {}

      vim.keymap.set("n", "<leader>xx", function()
        require("trouble").toggle "diagnostics"
      end, { desc = "Trouble: Diagnostics" })

      vim.keymap.set("n", "<leader>xb", function()
        require("trouble").toggle("diagnostics", { filter = { buf = 0 } })
      end, { desc = "Trouble: Buffer Diagnostics" })

      vim.keymap.set("n", "<leader>xp", function()
        require("trouble").previous { skip_groups = true, jump = true }
      end, { desc = "Trouble: Previous" })

      vim.keymap.set("n", "<leader>xn", function()
        require("trouble").next { skip_groups = true, jump = true }
      end, { desc = "Trouble: Next" })
    end,
  },
}
