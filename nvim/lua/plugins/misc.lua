return {
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup()
    end,
  },
  { "romainl/vim-cool", event = "VeryLazy" },
  { "tpope/vim-sleuth", event = "VeryLazy" },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function(_)
      require("illuminate").configure {
        delay = 100,
      }
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },
  {
    "lambdalisue/suda.vim",
    keys = {
      { "<leader>w", "<cmd>w<cr>", desc = "Write the current file" },
      { "<leader>W", "<cmd>SudaWrite<cr>", desc = "Write the current file with sudo" },
    },
    cmd = { "SudaWrite", "SudaRead" },
  },
}
