return {
  {
    "supermaven-inc/supermaven-nvim",
    enabled = false,
    config = function()
      require("supermaven-nvim").setup {
        keymaps = {
          accept_suggestion = "<m-y>",
          clear_suggestion = "<m-space>",
          accept_word = "<m-n>",
        },
      }
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("minuet").setup {
        provider = "codestral",
        provider_options = {
          codestral = {
            api_key = function()
              return vim.env.CODESTRAL_API_KEY
            end,
          },
        },
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
}
