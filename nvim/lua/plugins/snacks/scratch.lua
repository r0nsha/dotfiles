return {
  "folke/snacks.nvim",
  opts = {
    scratch = {
      win = {
        border = "single",
        relative = "editor",
      },
    },
  },
  keys = {
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>,",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
  },
}
