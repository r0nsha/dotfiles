local heirline = require("heirline")
heirline.setup({
  opts = { colors = require("plugins.heirline.colors").setup() },
  statusline = require("plugins.heirline.statusline"),
})
