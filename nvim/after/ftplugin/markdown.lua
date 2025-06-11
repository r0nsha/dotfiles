vim.keymap.set("n", "gd", function()
  require("follow-md-links").follow_link()
end, { buffer = 0, noremap = true, silent = true, desc = "Markdown: Follow link" })
