---@class DBG: Hydra
local M

local Hydra = require "hydra"
local dap = require "dap"
local dv = require "dap-view"
local dv_globals = require "dap-view.globals"
local persistent_breakpoints_api = require "persistent-breakpoints.api"

---@type table<number, boolean>
local original_modifiable = {}

local excluded_filetypes = {
  "snacks_input",
  "snacks_picker_input",
  "snacks_picker_list",
  "TelescopePrompt",
  "TelescopeResults",
  "neo-tree-popup",
  "notify",
  "lazy",
  "mason",
  "help",
  "qf",
  "Trouble",
  "trouble",
}

---@param bufnr number
---@return boolean
local function is_excluded_buffer(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local filetype = vim.bo[bufnr].filetype
  local buftype = vim.bo[bufnr].buftype

  -- Exclude dap-view main buffer
  if bufname:match(vim.pesc(dv_globals.MAIN_BUF_NAME)) then
    return true
  end

  -- Exclude dap-* filetypes
  if filetype:match "^dap%-" then
    return true
  end

  -- Exclude prompts, nofile buffers (floating windows, scratch, etc.)
  if buftype == "prompt" or buftype == "nofile" then
    return true
  end

  -- Exclude specific filetypes (pickers, inputs, etc.)
  for _, ft in ipairs(excluded_filetypes) do
    if filetype == ft then
      return true
    end
  end

  return false
end

local function lock_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
      if not is_excluded_buffer(bufnr) then
        original_modifiable[bufnr] = vim.bo[bufnr].modifiable
        vim.bo[bufnr].modifiable = false
      end
    end
  end
end

local function unlock_buffers()
  for bufnr, was_modifiable in pairs(original_modifiable) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.bo[bufnr].modifiable = was_modifiable
    end
  end
  original_modifiable = {}
end

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
 _c_ Continue        ^_db_ Toggle breakpoint
 _J_ Step over       ^_dl_ Log point
 _K_ Step back       ^_dA_ Clear all breakpoints
 _L_ Step in         ^_dx_ Set exception breakpoints
 _H_ Step out        ^_dX_ Clear exception breakpoints
 _r_ Run to cursor   ^_dp_ Pause
                      ^
 UI                   ^
 _gu_  Toggle UI      ^_<leader>w_ Watch expression
 _gw_ Watches        ^_<leader>W_ Add watch
 _gs_ Scopes         ^
 _gx_ Exceptions     ^
 _gb_ Breakpoints    ^
 _gT_ Threads        ^
 _gR_ REPL           ^
 _gC_ Console        ^
                     ^
 _?_/_g?_ Help
 ^
 _Q_ Terminate ^_dd_ Disconnect _<C-c>_ Exit mode
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

---@type vim.api.keyset.get_hl_info
local original_cursor_hl

---@type DBG
M = Hydra {
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
      -- float_opts = { border = "single" },
      hide_on_load = true,
    },
    on_enter = function()
      original_cursor_hl = vim.deepcopy(vim.api.nvim_get_hl(0, { name = "Cursor" }))
      local hydra_pink = vim.api.nvim_get_hl(0, { name = "HydraPink" }).fg
      vim.api.nvim_set_hl(0, "Cursor", { bg = hydra_pink })
      lock_buffers()
      vim.api.nvim_exec_autocmds("User", { pattern = "HydraEnter" })
    end,
    on_exit = function()
      local hl = original_cursor_hl or { bg = "none" }
      vim.api.nvim_set_hl(0, "Cursor", hl --[[@as vim.api.keyset.highlight]])
      unlock_buffers()
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
    { "dl", persistent_breakpoints_api.set_log_point, { desc = "Log point", private = true } },
    {
      "dA",
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
    { "dp", dap.pause, { desc = "Pause", private = true } },

    -- UI
    {
      "gu",
      function()
        dv.toggle(true)
      end,
      { desc = "Toggle UI", private = true },
    },
    { "gw", jump_to_view "watches", { desc = "Jump to Watches", private = true } },
    { "gs", jump_to_view "scopes", { desc = "Jump to Scopes", private = true } },
    { "gx", jump_to_view "exceptions", { desc = "Jump to Exceptions", private = true } },
    { "gb", jump_to_view "breakpoints", { desc = "Jump to Breakpoints", private = true } },
    { "gT", jump_to_view "threads", { desc = "Jump to Threads", private = true } },
    { "gR", jump_to_view "repl", { desc = "Jump to REPL", private = true } },
    { "gC", jump_to_view "console", { desc = "Jump to Console", private = true } },
    { "<leader>w", dv.add_expr, { desc = "Watch expression", private = true, mode = { "n", "x" } } },
    {
      "<leader>W",
      function()
        vim.ui.input({ prompt = "Watch expression" }, function(input)
          dv.add_expr(input)
        end)
      end,
      { desc = "Add watch", private = true },
    },

    -- Quitting
    { "dd", disconnect, { desc = "Disconnect", exit = true } },
    { "Q", terminate, { desc = "Terminate", exit = true } },
    {
      "<C-c>",
      function()
        M:exit()
      end,
      { desc = "Terminate", exit = true },
    },

    -- Hint
    { "?", toggle_help, { desc = "Toggle Help", private = true } },
    { "g?", toggle_help, { desc = "Toggle Help", private = true } },
  },
}

function M:exit_mode()
  if self.layer then
    self.layer:exit()
  else
    self:exit()
  end
end

local group = vim.api.nvim_create_augroup("CustomDBG", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  pattern = dv_globals.MAIN_BUF_NAME,
  callback = function()
    M:exit_mode()
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  pattern = dv_globals.MAIN_BUF_NAME,
  callback = function()
    if dap.session() then
      M:activate()
    end
  end,
})

-- Lock newly opened buffers while debugging
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(args)
    -- Only if hydra is active (has layer) and dap session exists
    if not dap.session() or not M.layer then
      return
    end

    local bufnr = args.buf
    if not is_excluded_buffer(bufnr) and original_modifiable[bufnr] == nil then
      original_modifiable[bufnr] = vim.bo[bufnr].modifiable
      vim.bo[bufnr].modifiable = false
    end
  end,
})

return M
