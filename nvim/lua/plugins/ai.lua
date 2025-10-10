return {
  {
    "folke/sidekick.nvim",
    enabled = false,
    config = function()
      local sidekick = require("sidekick")
      local nes = require("sidekick.nes")

      sidekick.setup({
        cli = {
          mux = {
            enabled = true,
            backend = "tmux",
            create = "window",
          },
        },
        tools = {},
      })

      vim.keymap.set({ "n", "i" }, "<a-y>", function()
        sidekick.nes_jump_or_apply()
      end, {
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      })

      vim.keymap.set({ "n", "i" }, "<a-n>", function()
        nes.jump()
      end, { desc = "Goto Next Edit Suggestion" })

      vim.keymap.set({ "n", "i" }, "<a-r>", function()
        sidekick.clear()
      end, { desc = "Clear Edit Suggestion" })
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    enabled = true,
    opts = {
      provider = "codestral",
      throttle = 200,
      debounce = 400,
      virtualtext = {
        -- auto_trigger_ft = { "*" },
        -- auto_trigger_ignore_ft = {
        --   "snacks_input",
        --   "snacks_picker_input",
        --   "mini_*",
        --   "lazy",
        --   "mason",
        --   "help",
        --   "lspinfo",
        --   "TelescopePrompt",
        --   "TelescopeResults",
        --   "neo-tree",
        --   "dashboard",
        --   "neo-tree-popup",
        --   "notify",
        --   "gitrebase",
        -- },
        keymap = {
          accept = "<a-y>",
          accept_line = "<a-l>",
          accept_n_lines = "<a-L>",
          prev = "<a-p>",
          next = "<a-n>",
          dismiss = "<a-r>",
        },
        show_on_completion_menu = true,
      },
      cmp = { enable_auto_complete = false },
      blink = { enable_auto_complete = false },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    enabled = false,
    opts = {
      keymaps = {
        accept_suggestion = "<a-y>",
        clear_suggestion = "<a-r>",
        accept_word = "<a-l>",
      },
    },
  },
}
