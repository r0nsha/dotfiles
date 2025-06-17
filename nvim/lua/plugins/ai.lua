return {
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   config = function()
  --     require("supermaven-nvim").setup {
  --       keymaps = {
  --         accept_suggestion = "<m-y>",
  --         clear_suggestion = "<m-space>",
  --         accept_word = "<m-n>",
  --       },
  --     }
  --   end,
  -- },
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("minuet").setup {
        -- provider = "gemini",
        provider = "codestral",
        virtualtext = {
          auto_trigger_ft = {},
          keymap = {
            accept = "<a-y>",
            accept_line = "<a-l>",
            accept_n_lines = "<a-L>",
            prev = "<a-p>",
            next = "<a-n>",
            dismiss = "<a-r>",
          },
        },
      }
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local cc = require "codecompanion"
      cc.setup {
        strategies = {
          chat = {
            adapter = "gemini",
            keymaps = {
              send = {
                modes = { n = "<cr>", i = "<a-cr>" },
                opts = {},
              },
            },
          },
          inline = {
            adapter = "gemini",
            keymaps = {
              accept_change = {
                modes = { n = "<a-y>" },
                description = "Accept the suggested change",
              },
              reject_change = {
                modes = { n = "<a-r>" },
                description = "Reject the suggested change",
              },
            },
          },
          cmd = {
            adapter = "gemini",
          },
        },
        display = {
          action_palette = {
            provider = "snacks",
          },
          chat = {
            intro_message = "Welcome  ! Press ? for options",
          },
          diff = {
            provider = "mini_diff",
          },
          inline = {
            layout = "vertical",
          },
        },
      }

      vim.keymap.set("n", "<a-c>", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "CodeCompanion: Chat" })
      vim.keymap.set("n", "<a-p>", "<cmd>CodeCompanion<cr>", { desc = "CodeCompanion: Prompt" })
      vim.keymap.set("v", "<a-p>", ":'<,'>CodeCompanion<cr>", { desc = "CodeCompanion: Prompt" })
      vim.keymap.set("n", "<a-P>", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion: Actions" })
      vim.keymap.set("n", "<a-C>", ":CodeCompanionCmd ", { desc = "CodeCompanion: Cmd" })
    end,
  },
}
