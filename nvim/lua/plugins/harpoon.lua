return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require "harpoon"
    harpoon:setup()

    vim.keymap.set("n", "<leader>A", function()
      harpoon:list():prepend()
    end, { desc = "Harpoon: Prepend File" })

    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Harpoon: Add File" })

    vim.keymap.set("n", "<c-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: Toggle Quick Menu" })

    for i = 1, 9 do
      vim.keymap.set("n", "<c-t>" .. i, function()
        harpoon:list():select(i)
      end, { desc = "Harpoon: Go to " .. i })
    end
  end,
}
