require("hunk").setup({
  keys = {
    global = {
      accept = { "<c-y>" },
    },
    diff = {
      next_hunk = { "]h", "<C-n>" },
      prev_hunk = { "[h", "<C-p>" },
    },
  },
})
