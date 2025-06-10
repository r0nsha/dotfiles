return {
  "hat0uma/csvview.nvim",
  config = function()
    local csvview = require "csvview"
    csvview.setup {
      view = {
        spacing = 2,
        display_mode = "border",
      },
      keymaps = {
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "csv",
      callback = function(args)
        local buf = args.buf

        csvview.enable(buf)
        vim.notify "Enabled CSV View automatically"

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = buf })
        end

        map("n", "<leader>vv", function()
          csvview.toggle(buf)
        end, "CSV View: Toggle")

        map("n", "<leader>ve", function()
          csvview.enable(buf)
        end, "CSV View: Toggle")

        map("n", "<leader>vd", function()
          csvview.disable(buf)
        end, "CSV View: Toggle")
      end,
    })
  end,
}
