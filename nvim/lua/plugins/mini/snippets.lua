local snippets = require("mini.snippets")
snippets.setup({
  snippets = { snippets.gen_loader.from_lang() },
  mappings = {
    expand = "",
    jump_prev = "<C-h>",
    jump_next = "<C-l>",
    stop = "<C-c>",
  },
})

vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "stop mini.snippets when leaving insert mode",
  group = require("augroup"),
  pattern = "*",
  callback = function() snippets.session.stop() end,
})
