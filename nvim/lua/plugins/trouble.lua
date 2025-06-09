return {
  "folke/trouble.nvim",
  config = function()
    local trouble = require "trouble"

    trouble.setup {
      auto_jump = true,
      follow = false,
    }

    vim.keymap.set("n", "<leader>xx", function()
      trouble.toggle "diagnostics"
    end, { desc = "Trouble: Diagnostics" })

    vim.keymap.set("n", "<leader>xX", function()
      trouble.toggle { mode = "diagnostics", filter = { buf = 0 } }
    end, { desc = "Trouble: Diagnostics" })

    vim.keymap.set("n", "<leader>q", function()
      trouble.toggle "quickfix"
    end, { desc = "Trouble: Quickfix" })

    local function prev()
      if trouble.is_open() then
        trouble.prev { skip_groups = true, jump = true }
      else
        local ok, err = pcall(vim.cmd.cprev)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end
    end

    local function next()
      if trouble.is_open() then
        trouble.next { skip_groups = true, jump = true }
      else
        local ok, err = pcall(vim.cmd.cnext)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end
    end

    vim.keymap.set("n", "[[", prev, { desc = "Trouble/Quickfix: Previous" })
    vim.keymap.set("n", "]]", next, { desc = "Trouble/Quickfix: Next" })
    vim.keymap.set("n", "[q", prev, { desc = "Trouble/Quickfix: Previous" })
    vim.keymap.set("n", "]q", next, { desc = "Trouble/Quickfix: Next" })
  end,
}
