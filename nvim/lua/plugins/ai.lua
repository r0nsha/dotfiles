return {
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   config = function()
  --     require("supermaven-nvim").setup {
  --       keymaps = {
  --         accept_suggestion = "<m-y>",
  --         clear_suggestion = "<m-space>",
  --         accept_word = "<m-n>",
  --       },
  --     }
  --   end,
  -- },
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "plugins.ai.minuet"
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require "plugins.ai.codecompanion"
    end,
  },
}
