return {
  {
    "folke/which-key.nvim",
    lazy = true,
    config = function()
      require("which-key").setup()
    end,
  },
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
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
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
    enabled = false, -- disabled until https://github.com/RRethy/vim-illuminate/issues/232 is fixed
    event = { "BufReadPost", "BufNewFile" },
    config = function(_)
      require("illuminate").configure {
        delay = 100,
      }

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    tag = "1.6.3",
    keys = {
      {
        "<leader>sr",
        function()
          require("grug-far").open()
        end,
        desc = "Replace in files (Spectre)",
      },
    },
    cmd = "GrugFar",
    config = function()
      require("grug-far").setup {}
    end,
  },
  "derektata/lorem.nvim",
  {
    "lambdalisue/suda.vim",
    config = function()
      vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { remap = false, desc = "Write current file" })
      vim.keymap.set("n", "<leader>W", "<cmd>SudaWrite<cr>", { remap = false, desc = "Write current file with sudo" })
    end,
  },
  {
    "b0o/incline.nvim",
    config = function()
      require("incline").setup {}
    end,
  },
}
