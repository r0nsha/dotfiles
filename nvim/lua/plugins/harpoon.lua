return {
  {
    "ThePrimeagen/harpoon",
    keys = { "m" },
    config = function()
      local mark = require "harpoon.mark"
      local ui = require "harpoon.ui"

      vim.keymap.set("n", "ma", mark.add_file, { remap = false, desc = "Harpoon: Add File" })
      vim.keymap.set("n", "mm", ui.toggle_quick_menu, { remap = false, desc = "Harpoon: Toggle Quick Menu" })
      vim.keymap.set("n", "mh", ui.nav_prev, { remap = false, desc = "Harpoon: Prev File" })
      vim.keymap.set("n", "ml", ui.nav_next, { remap = false, desc = "Harpoon: Next File" })

      for i = 1, 9 do
        vim.keymap.set("n", "m" .. i, function()
          ui.nav_file(i)
        end, { remap = false, desc = "Harpoon: Go to " .. i })
      end
    end,
  },
}
