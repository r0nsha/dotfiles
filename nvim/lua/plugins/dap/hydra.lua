---@type Hydra
local M

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

local hint = [[
 Navigation          ^Breakpoints
 _s_/_c_ Continue        ^_db_ Toggle breakpoint
 _S_   Run last        ^_dl_ Log point
 _J_   Step over       ^_dD_ Clear all breakpoints
 _K_   Step back       ^_dx_ Set exception breakpoints
 _L_   Step in         ^_dX_ Clear exception breakpoints
 _H_   Step out        ^_dp_ Pause
 _r_   Run to cursor   ^
                      ^
 UI                   ^
 _gu_ Toggle UI       ^_<leader>w_ Watch expression
 _gw_ Watches         ^_<leader>W_ Add watch
 _gs_ Scopes          ^
 _gx_ Exceptions      ^
 _gb_ Breakpoints     ^
 _gT_ Threads         ^
 _gR_ REPL            ^
 _gC_ Console         ^
                      ^
 _?_/_g?_ Help           ^_<Esc>_ Close this window
 ^
 _q_/_<C-c>_ Terminate   ^_d_ Disconnect
]]

local function toggle_help()
  ---@diagnostic disable-next-line: undefined-field
  if M.hint.win then
    M.hint:close()
  else
    M.hint:show()
  end
end

M = Hydra {
  name = "DBG",
  mode = { "n", "x", "v" },
  body = "<leader>d",
  hint = hint,
  config = {
    color = "pink",
    invoke_on_body = true,
    desc = "Debug Mode",
    hint = {
      position = "middle-right",
      float_opts = { border = "single" },
      -- hide_on_load = true,
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
    { "S", dap.run_last, { desc = "Run last", private = true } },

    -- Stepping
    { "c", dap.continue, { desc = "Continue", private = true } },
    { "K", dap.step_back, { desc = "Step back", private = true } },
    { "J", dap.step_over, { desc = "Step over", private = true } },
    { "H", dap.step_out, { desc = "Step out", private = true } },
    { "L", dap.step_into, { desc = "Step into", private = true } },
    { "r", dap.run_to_cursor, { desc = "Run to cursor", private = true } },

    -- Breakpoints
    { "db", persistent_breakpoints_api.toggle_breakpoint, { desc = "Toggle breakpoint", private = true } },
    { "dl", persistent_breakpoints_api.set_log_point, { desc = "Log point", private = true } },
    {
      "dD",
      persistent_breakpoints_api.clear_all_breakpoints,
      { desc = "Clear all breakpoints", private = true },
    },
    {
      "dx",
      dap.set_exception_breakpoints,
      { desc = "Set exception breakpoints", private = true },
    },
    {
      "dX",
      function()
        dap.set_exception_breakpoints {}
      end,
      { desc = "Clear exception breakpoints", private = true },
    },
    {
      "dp",
      function()
        ---@diagnostic disable-next-line: undefined-field
        dap.pause.toggle()
      end,
      { desc = "Pause", private = true },
    },

    -- Watch
    { "<leader>w", dv.add_expr, { desc = "Watch expression", private = true, mode = { "n", "v" } } },
    {
      "<leader>W",
      function()
        dv.add_expr(vim.fn.input "[Expression] > ")
      end,
      { desc = "Add watch", private = true },
    },

    -- UI
    { "gu", dv.toggle, { desc = "Toggle UI", private = true } },
    { "gw", jump_to_view "watches", { desc = "Jump to Watches", private = true } },
    { "gs", jump_to_view "scopes", { desc = "Jump to Scopes", private = true } },
    { "gx", jump_to_view "exceptions", { desc = "Jump to Exceptions", private = true } },
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
    { "<C-c>", dap.terminate, { desc = "Terminate", exit = true } },

    -- Hint
    { "g?", toggle_help, { desc = "Toggle Help", private = true } },
    { "?", toggle_help, { desc = "Toggle Help", private = true } },
    {
      "<Esc>",
      function()
        ---@diagnostic disable-next-line: undefined-field
        if M.hint.win then
          M.hint:close()
        end
      end,
      { desc = "Hide Help", private = true },
    },
  },
}

return M
