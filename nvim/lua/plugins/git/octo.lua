return {
  "pwntester/octo.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("octo").setup {
      picker = "snacks",
      mappings = {
        review_diff = {
          select_next_entry = { lhs = "<C-n>", desc = "move to next changed file" },
          select_prev_entry = { lhs = "<C-p>", desc = "move to previous changed file" },
        },
        file_panel = {
          select_entry = { lhs = "<C-y>", desc = "show selected changed file diffs" },
          select_next_entry = { lhs = "<C-n>", desc = "move to next changed file" },
          select_prev_entry = { lhs = "<C-p>", desc = "move to previous changed file" },
        },
      },
    }
  end,
}
