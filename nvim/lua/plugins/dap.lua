return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "Weissle/persistent-breakpoints.nvim",
    "nvimtools/hydra.nvim",
    {
      "igorlfs/nvim-dap-view",
      opts = {
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
      },
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {
        virt_text_pos = "eol",
      },
      config = true,
    },
    "nvim-neotest/nvim-nio",

    -- Adapters
    "jbyuki/one-small-step-for-vimkind",
    "leoluz/nvim-dap-go",
  },
  config = function()
    require "plugins.dap.config"
    require "plugins.dap.hydra"
    require "plugins.dap.adapters"
    require "plugins.dap.events"
  end,
}
