return {
  {
    "ThePrimeagen/harpoon",
    keys = { "m" },
    -- event = "VeryLazy",
    config = function()
      local mark = require "harpoon.mark"
      local ui = require "harpoon.ui"

      local opts = { remap = false }

      vim.keymap.set("n", "ma", mark.add_file, opts)
      vim.keymap.set("n", "mm", ui.toggle_quick_menu, opts)
      vim.keymap.set("n", "m,", ui.nav_prev, opts)
      vim.keymap.set("n", "m.", ui.nav_next, opts)

      for n = 1, 9 do
        vim.keymap.set("n", "m" .. n, function()
          ui.nav_file(n)
        end, opts)
      end
    end,
  },
}
