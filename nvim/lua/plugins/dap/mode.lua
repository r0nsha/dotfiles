---@class DBG: Hydra
local M

local Hydra = require("hydra")
local dap = require("dap")
local dv = require("dap-view")
local dv_globals = require("dap-view.globals")
local persistent_breakpoints_api = require("persistent-breakpoints.api")

---@param view dapview.Section
local function jump_to_view(view)
  return function()
    dv.open()
    dv.jump_to_view(view)
  end
end

local function disconnect()
  if dap.session() then
    dap.disconnect()
    dap.close()
  end
end

local function terminate()
  if dap.session() then
    dap.terminate()
    dap.close()
  end
end

local hint = [[
 Navigation        ^Breakpoints
 ==================================================== 
 _c_ Continue        ^_db_ Toggle breakpoint
 _J_ Step over       ^_dc_ Set conditional breakpoint
 _K_ Step back       ^_dl_ Log point
 _L_ Step in         ^_dA_ Clear all breakpoints
 _H_ Step out        ^_dx_ Set exception breakpoints
 _r_ Run to cursor   ^_dX_ Clear exception breakpoints
                   ^_dp_ Pause
                     ^
 UI                ^Watches
 ==================================================== 
 _gu_ Toggle UI      ^_<leader>w_ Watch expression
 _gW_ Watches        ^_<leader>W_ Add watch
 _gS_ Scopes         ^
 _gE_ Exceptions     ^
 _gB_ Breakpoints    ^
 _gT_ Threads        ^
 _gR_ REPL           ^
 _gC_ Console        ^
                     ^
 Misc
 ==================================================== 
 _?_/_g?_ Help
 _dq_ Disconnect     ^_dQ_ Terminate _<C-c>_ Exit mode
]]

local function toggle_help()
  ---@diagnostic disable-next-line: undefined-field
  if M.hint.win then
    M.hint:close()
  else
    M.hint:show()
  end
end

vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "Debug: Start" })
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run last" })
vim.keymap.set(
  "n",
  "<leader>dv",
  function() require("osv").launch({ port = 8086 }) end,
  { desc = "Debug: Start OSV server", buffer = 0 }
)

---@type vim.api.keyset.get_hl_info
local original_cursor_hl

---@type DBG
M = Hydra({
  name = "DBG",
  mode = { "n", "x", "v" },
  body = "<leader>dm",
  hint = hint,
  config = {
    color = "pink",
    invoke_on_body = true,
    desc = "Debug Mode",
    hint = {
      position = "middle-right",
      hide_on_load = true,
    },
    on_enter = function()
      original_cursor_hl = vim.deepcopy(vim.api.nvim_get_hl(0, { name = "Cursor" }))
      local hydra_pink = vim.api.nvim_get_hl(0, { name = "HydraPink" }).fg
      vim.api.nvim_set_hl(0, "Cursor", { bg = hydra_pink })
      vim.api.nvim_exec_autocmds("User", { pattern = "HydraEnter" })
    end,
    on_exit = function()
      local hl = original_cursor_hl or { bg = "none" }
      vim.api.nvim_set_hl(0, "Cursor", hl --[[@as vim.api.keyset.highlight]])
      vim.api.nvim_exec_autocmds("User", { pattern = "HydraExit" })
    end,
  },
  heads = {
    -- Stepping
    { "c", dap.continue, { desc = "Continue", private = true } },
    { "K", dap.step_back, { desc = "Step back", private = true } },
    { "J", dap.step_over, { desc = "Step over", private = true } },
    { "H", dap.step_out, { desc = "Step out", private = true } },
    { "L", dap.step_into, { desc = "Step into", private = true } },
    { "r", dap.run_to_cursor, { desc = "Run to cursor", private = true } },

    -- Breakpoints
    { "db", persistent_breakpoints_api.toggle_breakpoint, { desc = "Toggle breakpoint", private = true } },
    {
      "dc",
      persistent_breakpoints_api.set_conditional_breakpoint,
      { desc = "Set conditional breakpoint", private = true },
    },
    { "dl", persistent_breakpoints_api.set_log_point, { desc = "Log point", private = true } },
    { "dA", persistent_breakpoints_api.clear_all_breakpoints, { desc = "Clear all breakpoints", private = true } },
    { "dx", dap.set_exception_breakpoints, { desc = "Set exception breakpoints", private = true } },
    {
      "dX",
      function() dap.set_exception_breakpoints({}) end,
      { desc = "Clear exception breakpoints", private = true },
    },
    { "dp", dap.pause, { desc = "Pause", private = true } },

    -- UI
    { "gu", function() dv.toggle(true) end, { desc = "Toggle UI", private = true } },
    { "gW", jump_to_view("watches"), { desc = "Jump to Watches", private = true } },
    { "gS", jump_to_view("scopes"), { desc = "Jump to Scopes", private = true } },
    { "gE", jump_to_view("exceptions"), { desc = "Jump to Exceptions", private = true } },
    { "gB", jump_to_view("breakpoints"), { desc = "Jump to Breakpoints", private = true } },
    { "gT", jump_to_view("threads"), { desc = "Jump to Threads", private = true } },
    { "gR", jump_to_view("repl"), { desc = "Jump to REPL", private = true } },
    { "gC", jump_to_view("console"), { desc = "Jump to Console", private = true } },
    { "<leader>w", dv.add_expr, { desc = "Watch expression", private = true, mode = { "n", "x" } } },
    {
      "<leader>W",
      function()
        vim.ui.input({ prompt = "Watch expression" }, function(input) dv.add_expr(input) end)
      end,
      { desc = "Add watch", private = true },
    },

    -- Quitting
    { "dq", disconnect, { desc = "Disconnect", exit = true } },
    { "dQ", terminate, { desc = "Terminate", exit = true } },
    { "<C-c>", function() M:exit() end, { desc = "Terminate", exit = true } },

    -- Hint
    { "?", toggle_help, { desc = "Toggle Help", private = true } },
    { "g?", toggle_help, { desc = "Toggle Help", private = true } },
  },
})

function M:exit_mode()
  if self.layer then
    self.layer:exit()
  else
    self:exit()
  end
end

-- local group = vim.api.nvim_create_augroup("CustomDBG", { clear = true })
-- vim.api.nvim_create_autocmd("BufEnter", {
--   group = group,
--   pattern = dv_globals.MAIN_BUF_NAME,
--   callback = function() M:exit_mode() end,
-- })
--
-- vim.api.nvim_create_autocmd("BufLeave", {
--   group = group,
--   pattern = dv_globals.MAIN_BUF_NAME,
--   callback = function()
--     if dap.session() then M:activate() end
--   end,
-- })

return M
