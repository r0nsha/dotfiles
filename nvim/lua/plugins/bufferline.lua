return {
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup {
        options = {
          close_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          right_mouse_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          diagnostics = "nvim_lsp",
          always_show_bufferline = false,
          offsets = {
            {
              filetype = "neo-tree",
              text = "Neo-tree",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      }

      for i = 1, 9, 1 do
        vim.keymap.set("n", "<leader>b" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Buffer: Go to " .. i })
      end

      vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer: Cycle Prev" })
      vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer: Cycle Next" })

      vim.keymap.set("n", "<leader>bH", "<cmd>BufferLineMovePrev<cr>", { desc = "Buffer: Move Prev" })
      vim.keymap.set("n", "<leader>bL", "<cmd>BufferLineMoveNext<cr>", { desc = "Buffer: Move Next" })

      vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Buffer: Toggle Pin" })
      vim.keymap.set(
        "n",
        "<leader>bxu",
        "<cmd>BufferLineGroupClose ungrouped<cr>",
        { desc = "Buffer: Close Ungrouped" }
      )

      vim.keymap.set("n", "<leader>p", "<cmd>BufferLinePick<cr>", { desc = "Buffer: Pick" })
    end,
  },
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
}
