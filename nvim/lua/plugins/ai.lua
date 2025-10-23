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
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `toggle()`.
      { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
    },
    config = function()
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on `opencode_opts`.
      }

      -- Required for `vim.g.opencode_opts.auto_reload`.
      vim.o.autoread = true

      local opencode = require("opencode")

      -- Recommended/example keymaps.
      vim.keymap.set({ "n", "x" }, "<leader>aa", function()
        opencode.ask("@this: ", { submit = true })
      end, { desc = "Opencode: Ask about this" })
      vim.keymap.set({ "n", "x" }, "<leader>aA", function()
        opencode.prompt("@this")
      end, { desc = "Opencode: Add this" })
      vim.keymap.set({ "n", "x" }, "<leader>as", function()
        opencode.select()
      end, { desc = "Opencode: Select prompt" })
      vim.keymap.set("n", "<leader>at", function()
        opencode.toggle()
      end, { desc = "Opencode: Toggle embedded" })
      vim.keymap.set("n", "<leader>ac", function()
        opencode.command()
      end, { desc = "Opencode: Select command" })
      vim.keymap.set("n", "<leader>aN", function()
        opencode.command("session_new")
      end, { desc = "Opencode: New session" })
      vim.keymap.set("n", "<leader>ai", function()
        opencode.command("session_interrupt")
      end, { desc = "Opencode: Interrupt session" })
      -- vim.keymap.set("n", "<leader>an", function()
      --   opencode.command("agent_cycle")
      -- end, { desc = "Opencode: Cycle selected agent" })
      -- vim.keymap.set("n", "<S-C-u>", function()
      --   opencode.command("messages_half_page_up")
      -- end, { desc = "Opencode: Messages half page up" })
      -- vim.keymap.set("n", "<S-C-d>", function()
      --   opencode.command("messages_half_page_down")
      -- end, { desc = "Opencode: Messages half page down" })
    end,
  },
}
