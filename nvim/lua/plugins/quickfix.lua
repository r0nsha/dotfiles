---@module "lazy"
---@type LazySpec
return {
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    config = function()
      local icons = require "config.icons"
      local quicker = require "quicker"

      quicker.setup {
        type_icons = {
          E = icons.error,
          W = icons.warn,
          I = icons.info,
          N = icons.info,
          H = icons.hint,
        },
        keys = {
          {
            "<Tab>",
            function()
              quicker.expand { before = 2, after = 2, add_to_existing = true }
            end,
            desc = "Expand quickfix context",
          },
          { "<S-Tab>", quicker.collapse, desc = "Collapse quickfix context" },
        },
      }

      vim.keymap.set("n", "<leader>q", quicker.toggle, { desc = "Toggle quickfix" })
      vim.keymap.set("n", "<leader>Q", function()
        quicker.toggle { loclist = true }
      end, { desc = "Toggle loclist" })
    end,
  },
  {
    "r0nsha/qfpreview.nvim",
    -- dir = "~/dev/qfpreview.nvim",
    enabled = false,
    opts = { ui = { height = 20 } },
  },
}
