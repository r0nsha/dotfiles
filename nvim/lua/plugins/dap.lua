return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "Weissle/persistent-breakpoints.nvim",
    "nvimtools/hydra.nvim",
    {
      "igorlfs/nvim-dap-view",
      opts = {
        winbar = {
          controls = {
            enabled = true,
            position = "right",
          },
        },
        windows = {
          height = 12,
          position = "below",
          terminal = {
            position = "right",
            width = 0.25,
            start_hidden = true,
          },
        },
      },
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {
        virt_text_pos = "eol",
      },
      config = true,
    },
    "nvim-neotest/nvim-nio",

    -- Adapters
    "jbyuki/one-small-step-for-vimkind",
    "leoluz/nvim-dap-go",
  },
  config = function()
    require "plugins.dap.config"
    require "plugins.dap.mode"
    require "plugins.dap.adapters"

    -- Keymaps
    -- local function key(k)
    --   return "<leader>d" .. k
    -- end

    -- local function opts(desc)
    --   return {
    --     remap = false,
    --     desc = "Debug: " .. desc,
    --   }
    -- end

    -- vim.keymap.set("n", key "s", dap.continue, opts "Start")
    -- vim.keymap.set("n", key "d", function()
    --   dap.disconnect()
    --   dap.close()
    -- end, opts "Disconnect")

    -- vim.keymap.set("n", key "g", dap.session, opts "Get session")

    -- vim.keymap.set("n", key "c", dap.continue, opts "Continue")
    -- vim.keymap.set("n", key "k", dap.step_back, opts "Step back")
    -- vim.keymap.set("n", key "j", dap.step_over, opts "Step over")
    -- vim.keymap.set("n", key "h", dap.step_out, opts "Step out")
    -- vim.keymap.set("n", key "l", dap.step_into, opts "Step into")
    -- vim.keymap.set("n", key "r", dap.run_to_cursor, opts "Run to cursor")

    -- vim.keymap.set("n", key "p", function()
    --   dap.pause.toggle()
    -- end, opts "Pause")

    -- vim.keymap.set("n", key "bb", persistent_breakpoints_api.toggle_breakpoint, opts "Toggle breakpoint")
    -- vim.keymap.set(
    --   "n",
    --   key "bc",
    --   persistent_breakpoints_api.set_conditional_breakpoint,
    --   opts "Set conditional breakpoint"
    -- )
    -- vim.keymap.set("n", key "bD", persistent_breakpoints_api.clear_all_breakpoints, opts "Clear all breakpoints")
    -- vim.keymap.set("n", key "bl", persistent_breakpoints_api.set_log_point, opts "Log point")
    -- vim.keymap.set("n", key "bx", function()
    --   dap.set_exception_breakpoints()
    --   persistent_breakpoints_api.breakpoints_changed_in_current_buffer()
    -- end, opts "Set exception breakpoints")
    -- vim.keymap.set("n", key "bX", function()
    --   dap.set_exception_breakpoints {}
    --   persistent_breakpoints_api.breakpoints_changed_in_current_buffer()
    -- end, opts "Clear exception breakpoints")

    -- vim.keymap.set({ "n", "v" }, key "w", dv.add_expr, opts "Watch Expression")
    -- vim.keymap.set("n", key "e", function()
    --   dv.add_expr(vim.fn.input "[Expression] > ")
    -- end, opts "Watch Expression (Input)")

    -- vim.keymap.set("n", key "q", dap.terminate, opts "Terminate")

    -- ---@param view dapview.SectionType
    -- local function jump_to_view(view)
    --   return function()
    --     dv.open()
    --     dv.jump_to_view(view)
    --   end
    -- end

    -- vim.keymap.set("n", key "U", dv.toggle, opts "Toggle UI")
    -- vim.keymap.set("n", key "W", jump_to_view "watches", opts "Jump to Watches")
    -- vim.keymap.set("n", key "S", jump_to_view "scopes", opts "Jump to Scopes")
    -- vim.keymap.set("n", key "E", jump_to_view "exceptions", opts "Jump to Exceptions")
    -- vim.keymap.set("n", key "B", jump_to_view "breakpoints", opts "Jump to Breakpoints")
    -- vim.keymap.set("n", key "T", jump_to_view "threads", opts "Jump to Threads")
    -- vim.keymap.set("n", key "R", jump_to_view "repl", opts "Jump to REPL")
    -- vim.keymap.set("n", key "C", jump_to_view "console", opts "Jump to Console")
  end,
}
