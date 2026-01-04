local diff = require "mini.diff"

diff.setup {
  view = { style = "sign" },
  source = diff.gen_source.git(),
  mappings = {
    apply = "",
    reset = "gH",
    textobject = "",
    goto_first = "[H",
    goto_prev = "[h",
    goto_next = "]h",
    goto_last = "]H",
  },
}

vim.keymap.set("n", "<leader>gh", diff.toggle_overlay, { desc = "Toggle diff overlay" })
