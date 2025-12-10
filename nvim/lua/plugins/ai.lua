return {
  {
    "folke/sidekick.nvim",
    enabled = false,
    config = function()
      local sidekick = require("sidekick")
      local nes = require("sidekick.nes")

      sidekick.setup({})

      vim.keymap.set("n", "<a-cr>", function()
        sidekick.nes_jump_or_apply()
      end, {
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      })

      vim.keymap.set("n", "<a-bs>", function()
        nes.jump()
      end, { desc = "Goto Next Edit Suggestion" })

      vim.keymap.set("n", "<a-u>", function()
        sidekick.clear()
      end, { desc = "Clear Edit Suggestion" })
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      provider = "codestral",
      provider_options = {
        codestral = {
          optional = {
            max_tokens = 256,
            stop = { "\n\n" },
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = { "*" },
        auto_trigger_ignore_ft = {
          "snacks_input",
          "snacks_picker_input",
          "mini_*",
          "lazy",
          "mason",
          "help",
          "lspinfo",
          "TelescopePrompt",
          "TelescopeResults",
          "neo-tree",
          "dashboard",
          "neo-tree-popup",
          "notify",
          "gitrebase",
        },
        keymap = {
          accept = "<a-y>",
          accept_line = nil,
          accept_n_lines = nil,
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
  {
    "NickvanDyke/opencode.nvim",
    config = function()
      vim.g.opencode_opts = {
        auto_reload = true,
      }

      -- Required for `vim.g.opencode_opts.auto_reload`.
      vim.o.autoread = true

      local opencode = require("opencode")

      vim.keymap.set("n", "ga", function()
        opencode.toggle()
      end, { desc = "Opencode: Toggle" })

      vim.keymap.set({ "n", "x" }, "gA", function()
        opencode.prompt("@this")
      end, { desc = "Opencode: Add this" })

      vim.keymap.set({ "n", "x" }, "gp", function()
        opencode.ask("@this: ", { submit = true })
      end, { desc = "Opencode: Prompt about this" })

      vim.keymap.set({ "n", "x" }, "gP", function()
        opencode.ask("", { submit = true })
      end, { desc = "Opencode: Prompt" })

      vim.keymap.set({ "n", "x" }, "gs", function()
        opencode.select()
      end, { desc = "Opencode: Select prompt" })
    end,
  },
}
