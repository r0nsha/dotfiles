local snippets = require("mini.snippets")
local gen_loader = snippets.gen_loader
snippets.setup({
  snippets = { gen_loader.from_lang() },
  mappings = {
    expand = "",
    jump_prev = "<C-h>",
    jump_next = "<C-l>",
    stop = "<C-c>",
  },
})
