return {
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "NTBBloodbath/color-converter.nvim",
    event = "VeryLazy",
    config = function()
      require("color-converter").setup {
        round_hsl = true,
        lowercase_hex = true,
      }

      vim.keymap.set({ "n", "v" }, "<leader>cc", function()
        require("color-converter").cycle()
      end, { desc = "Convert Color" })
    end,
  },
}
