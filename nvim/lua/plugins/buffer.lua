local function delete_buffer(force)
  require("mini.bufremove").delete(0, force)

  local mark = require "harpoon.mark"
  local index = mark.get_index_of(vim.fn.bufname())
  mark.rm_file(index)
end

return {
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          delete_buffer(false)
        end,
        desc = "Buffer: Delete",
      },
      {
        "<leader>bD",
        function()
          delete_buffer(true)
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
    lazy = false,
    config = function()
      require("harpoon").setup {
        global_settings = {
          tabline = true,
        },
        menu = {
          width = math.min(vim.api.nvim_win_get_width(0) - 4, 100),
        },
      }

      local mark = require "harpoon.mark"
      local ui = require "harpoon.ui"

      vim.keymap.set("n", "<leader>a", mark.add_file, { remap = false, desc = "Harpoon: Add File" })
      vim.keymap.set("n", "<leader>k", ui.toggle_quick_menu, { remap = false, desc = "Harpoon: Toggle Quick Menu" })
      vim.keymap.set("n", "<leader>h", ui.nav_prev, { remap = false, desc = "Harpoon: Prev" })
      vim.keymap.set("n", "<leader>l", ui.nav_next, { remap = false, desc = "Harpoon: Next" })

      for i = 1, 9 do
        vim.keymap.set("n", "<leader>" .. i, function()
          ui.nav_file(i)
        end, { remap = false, desc = "Harpoon: Go to " .. i })
      end
    end,
  },
}
