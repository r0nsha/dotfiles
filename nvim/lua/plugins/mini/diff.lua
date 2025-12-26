local diff = require "mini.diff"

diff.setup {
  source = diff.gen_source.none(),
  mappings = {
    apply = "",
    reset = "",
    textobject = "",
    goto_first = "",
    goto_prev = "",
    goto_next = "",
    goto_last = "",
  },
}
