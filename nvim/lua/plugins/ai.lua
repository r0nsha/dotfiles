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
      vim.keymap.set({ "n", "x" }, "gp", function()
        opencode.ask("@this: ", { submit = true })
      end, { desc = "Opencode: Ask about this" })
      vim.keymap.set({ "n", "x" }, "gP", function()
        opencode.ask("", { submit = true })
      end, { desc = "Opencode: Prompt" })
      vim.keymap.set({ "n", "x" }, "gs", function()
        opencode.select()
      end, { desc = "Opencode: Select prompt" })
    end,
  },
  -- {
  --   "sudo-tee/opencode.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     {
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         anti_conceal = { enabled = false },
  --         file_types = { "markdown", "opencode_output" },
  --       },
  --       ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
  --     },
  --     "saghen/blink.cmp",
  --     "folke/snacks.nvim",
  --   },
  --   config = function()
  --     ---@param new_session boolean
  --     local function ask(new_session)
  --       local base = ""
  --       local in_visual_mode = vim.api.nvim_get_mode().mode:lower() == "v"
  --       if in_visual_mode then
  --         local start = vim.fn.line("v")
  --         local end_ = vim.fn.line(".")
  --         base = "Context lines " .. start .. "-" .. end_ .. ": "
  --       end

  --       vim.ui.input({
  --         prompt = "Enter a prompt: ",
  --         default = "",
  --       }, function(input)
  --         if input and input:match("^%s*$") == nil then
  --           local api = require("opencode.api")
  --           api.open_output()
  --           api.run(base .. input, {
  --             new_session = new_session,
  --             context = {
  --               cursor_data = {
  --                 enabled = not in_visual_mode,
  --               },
  --             },
  --           })
  --         end
  --       end)
  --     end

  --     require("opencode").setup({
  --       default_global_keymaps = false,
  --       default_mode = "plan",
  --       keymap_prefix = "<leader>o",
  --       keymap = {
  --         editor = {
  --           ["<leader>og"] = { "toggle" },
  --           ["<leader>oi"] = { "open_input" },
  --           ["<leader>oI"] = { "open_input_new_session" },
  --           ["<leader>oo"] = { "open_output" },
  --           ["<leader>ot"] = { "toggle_focus" },
  --           ["<leader>oT"] = { "timeline" },
  --           ["<leader>oq"] = { "close" },
  --           ["<leader>os"] = { "select_session" },
  --           ["<leader>oR"] = { "rename_session" },
  --           ["<leader>oP"] = { "configure_provider" },
  --           ["<leader>oz"] = { "toggle_zoom" },
  --           ["<leader>ov"] = { "paste_image" },
  --           ["<leader>od"] = { "diff_open" },
  --           ["<leader>o]"] = { "diff_next" },
  --           ["<leader>o["] = { "diff_prev" },
  --           ["<leader>oc"] = { "diff_close" },
  --           ["<leader>oua"] = { "diff_revert_all_last_prompt" },
  --           ["<leader>out"] = { "diff_revert_this_last_prompt" },
  --           ["<leader>ouA"] = { "diff_revert_all" },
  --           ["<leader>ouT"] = { "diff_revert_this" },
  --           ["<leader>our"] = { "diff_restore_snapshot_file" },
  --           ["<leader>ouR"] = { "diff_restore_snapshot_all" },
  --           ["<leader>ox"] = { "swap_position" },
  --           ["<leader>opa"] = { "permission_accept" },
  --           ["<leader>opA"] = { "permission_accept_all" },
  --           ["<leader>opd"] = { "permission_deny" },
  --           ["<M-o>"] = {
  --             function()
  --               ask(false)
  --             end,
  --             mode = { "n", "x" },
  --           },
  --           ["<M-O>"] = {
  --             function()
  --               ask(true)
  --             end,
  --             mode = { "n", "x" },
  --           },
  --         },
  --         input_window = {
  --           ["<cr>"] = { "submit_input_prompt", mode = { "n" } },
  --           ["<a-cr>"] = { "submit_input_prompt", mode = { "i" } },
  --           ["<esc>"] = { function() end }, -- ESC should do nothing
  --           ["<C-c>"] = { "cancel" },
  --           ["~"] = { "mention_file", mode = "i" },
  --           ["@"] = { "mention", mode = "i" },
  --           ["/"] = { "slash_commands", mode = "i" },
  --           ["#"] = { "context_items", mode = "i" },
  --           ["<M-v>"] = { "paste_image", mode = "i" },
  --           ["<C-i>"] = { "focus_input", mode = { "n", "i" } },
  --           ["<up>"] = { "prev_prompt_history" },
  --           ["<down>"] = { "next_prompt_history" },
  --           ["<M-m>"] = { "switch_mode" },
  --         },
  --         output_window = {
  --           ["<esc>"] = { function() end }, -- ESC should do nothing
  --           ["<C-c>"] = { "cancel" },
  --           ["<C-n>"] = { "next_message" },
  --           ["<C-p>"] = { "prev_message" },
  --           ["]]"] = { "next_message" },
  --           ["[["] = { "prev_message" },
  --           ["<M-m>"] = { "switch_mode" },
  --           ["i"] = { "focus_input", "n" },
  --           ["<leader>oS"] = { "select_child_session" },
  --           ["<leader>oD"] = { "debug_message" },
  --           ["<leader>oO"] = { "debug_output" },
  --           ["<leader>ods"] = { "debug_session" },
  --         },
  --         permission = {
  --           accept = "a",
  --           accept_all = "A",
  --           deny = "d",
  --         },
  --         session_picker = {
  --           rename_session = { "<C-r>" },
  --           delete_session = { "<C-x>" },
  --           new_session = { "<C-m>" },
  --         },
  --         timeline_picker = {
  --           undo = { "<C-u>", mode = { "i", "n" } },
  --           fork = { "<C-f>", mode = { "i", "n" } },
  --         },
  --         history_picker = {
  --           delete_entry = { "<C-d>", mode = { "i", "n" } },
  --           clear_all = { "<C-X>", mode = { "i", "n" } },
  --         },
  --       },
  --       ui = {
  --         window_width = 0.35,
  --         zoom_width = 0.8,
  --         input_height = 0.15,
  --         completion = {
  --           file_sources = {
  --             preferred_cli_tool = nil,
  --           },
  --         },
  --       },
  --       context = {
  --         enabled = true,
  --         diagnostics = {
  --           info = true,
  --           warn = true,
  --           error = true,
  --         },
  --         current_file = {
  --           enabled = true,
  --         },
  --         selection = {
  --           enabled = true,
  --         },
  --       },
  --     })
  --   end,
  -- },
}
