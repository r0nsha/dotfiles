---@diagnostic disable: missing-fields
require("fyler").setup({
  integrations = {
    winpick = "builtin",
  },
  views = {
    finder = {
      confirm_simple = true,
    },
  },
})

vim.keymap.set(
  "n",
  "<leader>r",
  function() require("fyler").toggle({ kind = "split_left_most" }) end,
  { desc = "Fyler" }
)
