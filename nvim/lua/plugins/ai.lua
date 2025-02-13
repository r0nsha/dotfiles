return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup {
        keymaps = {
          accept_suggestion = "<c-j>",
          clear_suggestion = "<c-x>",
          accept_word = "<c-l>",
        },
      }
    end,
  },
}
