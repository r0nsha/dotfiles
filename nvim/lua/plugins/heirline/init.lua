local heirline = require("heirline")
local heirline_components = require("heirline-components.all")

heirline_components.init.subscribe_to_events()
heirline.load_colors(heirline_components.hl.get_colors())
heirline.setup({
  opts = { colors = require("plugins.heirline.colors").setup() },
  statusline = require("plugins.heirline.statusline"),
  statuscolumn = require("plugins.heirline.statuscolumn"),
})
