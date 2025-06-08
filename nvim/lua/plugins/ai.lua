return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup {
      keymaps = {
        accept_suggestion = "<m-y>",
        clear_suggestion = "<m-space>",
        accept_word = "<m-n>",
      },
    }
  end,
}
