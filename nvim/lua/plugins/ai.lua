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
      require("minuet").setup {
        -- provider = "gemini",
        provider = "codestral",
        virtualtext = {
          auto_trigger_ft = {},
          keymap = {
            accept = "<a-y>",
            accept_line = "<a-l>",
            accept_n_lines = "<a-L>",
            prev = "<a-p>",
            next = "<a-n>",
            dismiss = "<a-c>",
          },
        },
      }
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup {}
    end,
  },
}
