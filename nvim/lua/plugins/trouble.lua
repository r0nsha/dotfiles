return {
  "folke/trouble.nvim",
  config = function()
    local trouble = require "trouble"

    trouble.setup {
      auto_jump = true,
      keys = {
        ["c-n"] = "next",
        ["c-p"] = "prev",
        ["c-y"] = "jump",
      },
    }

    vim.keymap.set("n", "<leader>xx", function()
      trouble.toggle "diagnostics"
    end, { desc = "Trouble: Diagnostics" })

    vim.keymap.set("n", "<leader>q", function()
      trouble.toggle "quickfix"
    end, { desc = "Trouble: Quickfix" })

    vim.keymap.set("n", "[[", function()
      trouble.prev { skip_groups = true, jump = true }
    end, { desc = "Trouble: Previous" })

    vim.keymap.set("n", "[t", function()
      trouble.prev { skip_groups = true, jump = true }
    end, { desc = "Trouble: Previous" })

    vim.keymap.set("n", "]]", function()
      trouble.next { skip_groups = true, jump = true }
    end, { desc = "Trouble: Next" })
  end,
}
