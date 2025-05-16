return {
  {
    "stevearc/quicker.nvim",
    config = function()
      local quicker = require "quicker"
      quicker.setup {
        keys = {
          {
            ">",
            function()
              quicker.expand { before = 2, after = 2, add_to_existing = true }
            end,
            desc = "Quickfix: Expand context",
          },
          {
            "<",
            function()
              quicker.collapse()
            end,
            desc = "Quickfix: Collapse context",
          },
        },
      }

      vim.keymap.set("n", "<leader>q", function()
        quicker.toggle()
      end, { desc = "Quickfix: Open" })
    end,
  },
}
