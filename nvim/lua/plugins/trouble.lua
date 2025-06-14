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
    end, { desc = "Trouble: Diagnostics (Current Buffer)" })

    vim.keymap.set("n", "<leader>xt", function()
      trouble.toggle "todo"
    end, { desc = "Trouble: Todos" })

    vim.keymap.set("n", "<leader>q", function()
      vim.cmd [[cclose]]
      trouble.toggle "qflist"
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

    -- Open trouble automatically when opening quickfix
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CustomTroubleOverrideQuickfix", { clear = true }),
      callback = function(ev)
        if vim.bo[ev.buf].buftype == "quickfix" then
          vim.schedule(function()
            vim.cmd [[cclose]]
            vim.cmd [[Trouble qflist open]]
          end)
        end
      end,
    })
  end,
}
