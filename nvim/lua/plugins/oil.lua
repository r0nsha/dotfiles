return {
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    config = function()
      local oil = require "oil"
      oil.setup()

      require("which-key").register({
        ["-"] = {
          function()
            oil.open_float()
          end,
          "Oil: Parent directory",
        },
      }, {
        mode = "n",
        buffer = nil,
        silent = false,
        remap = false,
        nowait = false,
      })
    end,
  },
}
