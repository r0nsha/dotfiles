return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "''", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: Toggle Quick Menu" })

    vim.keymap.set("n", "'A", function()
      harpoon:list():add()
    end, { desc = "Harpoon: Add" })

    local letters = { "a", "s", "d", "f" }

    for index, letter in ipairs(letters) do
      vim.keymap.set("n", "'" .. letter, function()
        harpoon:list():select(index)
      end, { desc = "Harpoon: Select " .. index })

      vim.keymap.set("n", "<leader>'" .. letter, function()
        harpoon:list():replace_at(index)
      end, { desc = "Harpoon: Replace " .. index })
    end
  end,
}
