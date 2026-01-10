require("dap-view").setup({
  winbar = {
    controls = {
      enabled = true,
      position = "right",
    },
  },
  windows = {
    height = 12,
    position = "below",
    terminal = {
      position = "right",
      width = 0.25,
      start_hidden = true,
    },
  },
})

require("nvim-dap-virtual-text").setup({
  virt_text_pos = "",
})

require("plugins.dap.config")
require("plugins.dap.hydra")
require("plugins.dap.adapters")
require("plugins.dap.events")
