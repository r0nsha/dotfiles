return {
  "julienvincent/hunk.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require("hunk").setup {
      keys = {
        diff = {
          next_hunk = { "]h", "<C-n>" },
          prev_hunk = { "[h", "<C-p>" },
        },
      },
    }
  end,
}
