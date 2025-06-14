local Hydra = require "hydra"
local dap = require "dap"
local dv = require "dap-view"
local persistent_breakpoints_api = require "persistent-breakpoints.api"

---@param view dapview.SectionType
local function jump_to_view(view)
  return function()
    dv.open()
    dv.jump_to_view(view)
  end
end

Hydra {
  name = "DBG",
  mode = { "n", "x", "v" },
  body = "<leader>d",
  config = {
    color = "pink",
    invoke_on_body = true,
    desc = "Debug Mode",
    hint = {
      position = "bottom",
      float_opts = { border = "single" },
    },
    on_enter = function()
      local hydra_pink = vim.api.nvim_get_hl(0, { name = "HydraPink" }).fg
      vim.api.nvim_set_hl(0, "Cursor", { bg = hydra_pink })
      vim.api.nvim_exec_autocmds("User", { pattern = "HydraEnter" })
    end,
    on_exit = function()
      vim.api.nvim_set_hl(0, "Cursor", { bg = "none" })
      vim.api.nvim_exec_autocmds("User", { pattern = "HydraExit" })
    end,
  },
  heads = {
    { "s", dap.continue, { desc = "Continue", private = true } },
    { "S", dap.session, { desc = "Session", private = true } },

    -- Stepping
    { "c", dap.continue, { desc = "Continue", private = true } },
    { "K", dap.step_back, { desc = "Step back", private = true } },
    { "J", dap.step_over, { desc = "Step over", private = true } },
    { "H", dap.step_out, { desc = "Step out", private = true } },
    { "L", dap.step_into, { desc = "Step into", private = true } },
    { "r", dap.run_to_cursor, { desc = "Run to cursor", private = true } },
    {
      "P",
      function()
        dap.pause.toggle()
      end,
      { desc = "Pause", private = true },
    },

    -- Breakpoints
    { "<leader>bb", persistent_breakpoints_api.toggle_breakpoint, { desc = "Toggle breakpoint", private = true } },
    {
      "<leader>bd",
      persistent_breakpoints_api.clear_all_breakpoints,
      { desc = "Clear all breakpoints", private = true },
    },
    { "<leader>bl", persistent_breakpoints_api.set_log_point, { desc = "Log point", private = true } },
    {
      "<leader>bx",
      dap.set_exception_breakpoints,
      { desc = "Set exception breakpoints", private = true },
    },
    {
      "<leader>bX",
      function()
        dap.set_exception_breakpoints {}
      end,
      { desc = "Clear exception breakpoints", private = true },
    },

    -- UI
    { "gu", dv.toggle, { desc = "Toggle UI", private = true } },
    { "gw", jump_to_view "watches", { desc = "Jump to Watches", private = true } },
    { "gs", jump_to_view "scopes", { desc = "Jump to Scopes", private = true } },
    { "ge", jump_to_view "exceptions", { desc = "Jump to Exceptions", private = true } },
    { "gb", jump_to_view "breakpoints", { desc = "Jump to Breakpoints", private = true } },
    { "gT", jump_to_view "threads", { desc = "Jump to Threads", private = true } },
    { "gR", jump_to_view "repl", { desc = "Jump to REPL", private = true } },
    { "gC", jump_to_view "console", { desc = "Jump to Console", private = true } },

    -- Quitting
    {
      "d",
      function()
        dap.disconnect()
        dap.close()
      end,
      { desc = "Continue", exit = true },
    },
    { "q", dap.terminate, { desc = "Terminate", exit = true } },
  },
}
