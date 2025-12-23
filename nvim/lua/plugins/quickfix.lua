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
  {
    "folke/trouble.nvim",
    config = function()
      local trouble = require "trouble"
      trouble.setup {
        indent_guides = false,
        modes = {
          diagnostics_buffer = {
            mode = "diagnostics",
            filter = { buf = 0 },
          },
        },
        keys = {
          ["<C-n>"] = "next",
          ["<C-p>"] = "prev",
        },
      }

      vim.keymap.set("n", "<leader>x", function()
        trouble.toggle "diagnostics"
      end, { desc = "Toggle trouble" })

      vim.keymap.set("n", "<leader>X", function()
        trouble.toggle "diagnostics_buffer"
      end, { desc = "Toggle trouble" })

      vim.keymap.set("n", "<A-n>", function()
        if trouble.is_open() then
          ---@diagnostic disable-next-line: missing-fields, missing-parameter
          trouble.next { skip_groups = true, jump = true }
        else
          ---@diagnostic disable-next-line: param-type-mismatch
          pcall(vim.cmd, "cnext")
        end
      end)

      vim.keymap.set("n", "<A-p>", function()
        if trouble.is_open() then
          ---@diagnostic disable-next-line: missing-fields, missing-parameter
          trouble.prev { skip_groups = true, jump = true }
        else
          ---@diagnostic disable-next-line: param-type-mismatch
          pcall(vim.cmd, "cprev")
        end
      end)
    end,
  },
}
