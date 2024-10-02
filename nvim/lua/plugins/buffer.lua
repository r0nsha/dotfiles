return {
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Buffer: Delete",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Buffer: Delete (Force)",
      },
    },
    config = function()
      require("mini.bufremove").setup()
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end, { remap = false, desc = "Harpoon: Add File" })

      vim.keymap.set("n", "<leader>k", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { remap = false, desc = "Harpoon: Toggle Quick Menu" })

      vim.keymap.set("n", "<leader>h", function()
        harpoon:list():prev()
      end, { remap = false, desc = "Harpoon: Prev" })

      vim.keymap.set("n", "<leader>l", function()
        harpoon:list():next()
      end, { remap = false, desc = "Harpoon: Next" })

      for i = 1, 9 do
        vim.keymap.set("n", "<leader>" .. i, function()
          harpoon:list():select(i)
        end, { remap = false, desc = "Harpoon: Go to " .. i })
      end
    end,
  },
  {
    "pteroctopus/faster.nvim",
    config = function()
      require("faster").setup()
    end,
  },
}
