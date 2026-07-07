require("hunk").setup({
  keys = {
    global = {
      accept = { "<c-y>" },
    },
    tree = {
      next_file = { "<C-n>" },
      prev_file = { "<C-p>" },
    },
    diff = {
      next_hunk = { "<C-S-N>" },
      prev_hunk = { "<C-S-P>" },
    },
  },
})
