vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("QuickerSetup", { clear = true }),
  once = true,
  callback = function()
    local icons = require("config.icons")
    local quicker = require("quicker")

    quicker.setup({
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
          function() quicker.expand({ before = 2, after = 2, add_to_existing = true }) end,
          desc = "Expand quickfix context",
        },
        { "<S-Tab>", quicker.collapse, desc = "Collapse quickfix context" },
      },
    })

    vim.keymap.set("n", "<leader>q", quicker.toggle, { desc = "Quickfix" })
    vim.keymap.set("n", "<leader>Q", function() quicker.toggle({ loclist = true }) end, { desc = "Loclist" })
  end,
})
