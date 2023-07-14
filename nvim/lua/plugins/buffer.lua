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
  -- {
  --   "akinsho/bufferline.nvim",
  --   config = function()
  --     require("bufferline").setup {
  --       options = {
  --         close_command = function(n)
  --           require("mini.bufremove").delete(n, false)
  --         end,
  --         right_mouse_command = function(n)
  --           require("mini.bufremove").delete(n, false)
  --         end,
  --         diagnostics = "nvim_lsp",
  --         always_show_bufferline = false,
  --         offsets = {
  --           {
  --             filetype = "neo-tree",
  --             text = "Neo-tree",
  --             highlight = "Directory",
  --             text_align = "left",
  --           },
  --         },
  --       },
  --     }
  --
  --     for i = 1, 9, 1 do
  --       vim.keymap.set(
  --         "n",
  --         "<leader>b" .. i,
  --         "<cmd>BufferLineGoToBuffer " .. i .. "<cr>",
  --         { desc = "Buffer: Go to " .. i }
  --       )
  --     end
  --
  --     vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer: Cycle Prev" })
  --     vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer: Cycle Next" })
  --
  --     vim.keymap.set("n", "<leader>bH", "<cmd>BufferLineMovePrev<cr>", { desc = "Buffer: Move Prev" })
  --     vim.keymap.set("n", "<leader>bL", "<cmd>BufferLineMoveNext<cr>", { desc = "Buffer: Move Next" })
  --
  --     vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineTogglePin<cr>", { desc = "Buffer: Toggle Pin" })
  --     vim.keymap.set(
  --       "n",
  --       "<leader>bxu",
  --       "<cmd>BufferLineGroupClose ungrouped<cr>",
  --       { desc = "Buffer: Close Ungrouped" }
  --     )
  --
  --     vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Buffer: Pick" })
  --   end,
  -- },
}
