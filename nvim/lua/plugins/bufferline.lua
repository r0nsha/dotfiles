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
        vim.keymap.set("n", "<leader>b" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Buffer: Go to 1" })
      end

      vim.keymap.set("n", "<leader>b,", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer: Cycle prev" })
      vim.keymap.set("n", "<leader>b.", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer: Cycle next" })

      vim.keymap.set("n", "<leader>b<", "<cmd>BufferLineMovePrev<cr>", { desc = "Buffer: Move prev" })
      vim.keymap.set("n", "<leader>b>", "<cmd>BufferLineMoveNext<cr>", { desc = "Buffer: Move next" })

      vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Buffer: Toggle pin" })
      vim.keymap.set(
        "n",
        "<leader>bxu",
        "<cmd>BufferLineGroupClose ungrouped<cr>",
        { desc = "Buffer: Close ungrouped" }
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
