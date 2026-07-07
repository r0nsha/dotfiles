local Hydra = require("hydra")
local dap = require("dap")
local dv = require("dap-view")

dap.set_log_level("INFO")

dv.setup({
  winbar = {
    controls = {
      enabled = true,
      position = "right",
    },
  },
  windows = {
    size = 12,
    position = "below",
    terminal = {
      position = "right",
      size = 0.25,
    },
  },
  virtual_text = {
    enabled = true,
  },
})

require("persistent-breakpoints").setup({ load_breakpoints_event = { "BufReadPost" } })

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define(
  "DapStopped",
  { text = "", texthl = "DiagnosticError", linehl = "DapStoppedLine" }
)

dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host, port = config.port })
end

dap.adapters.lldb = {
  type = "executable",
  command = "lldb-vscode",
  name = "lldb",
}

dap.adapters.rust = {
  type = "executable",
  attach = { pidProperty = "pid", pidSelect = "ask" },
  command = "lldb-vscode",
  env = { LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES" },
  name = "lldb",
}

local lldb_config = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = function()
      local argument_string = vim.fn.input("Program arguments: ")
      return vim.fn.split(argument_string, " ", true)
    end,
  },
}

dap.configurations.c = lldb_config
dap.configurations.cpp = lldb_config
dap.configurations.zig = lldb_config

dap.configurations.rust = {
  {
    name = "Launch",
    type = "rust",
    request = "launch",
    cwd = "${workspaceFolder}",
    program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
    stopOnEntry = false,
    args = function()
      local args_str = vim.fn.input("Program arguments: ")
      local args = vim.fn.split(args_str, " ", true)
      return { "build", "-o", "build", unpack(args) }
    end,

    -- Types
    initCommands = function()
      -- Find out where to look for the pretty printer Python module
      local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

      local script_import = 'command script import "'
        .. rustc_sysroot
        .. '/lib/rustlib/etc/lldb_lookup.py"'
      local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

      local commands = {}
      local file = io.open(commands_file, "r")
      if file then
        for line in file:lines() do
          table.insert(commands, line)
        end
        file:close()
      end
      table.insert(commands, 1, script_import)

      return commands
    end,
  },
}

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = function() return vim.fn.input("Host [127.0.0.1]: ", "127.0.0.1") end,
    port = function() return tonumber(vim.fn.input("Port [8086]: ", "8086")) end,
  },
}

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = {
      vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
      "${port}",
    },
  },
}

dap.adapters["node"] = dap.adapters["pwa-node"]

---@type dap.Configuration[]
local js_config = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Run current file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to Node process",
    port = function() return vim.fn.input("Port: ") end,
    cwd = "${workspaceFolder}",
  },
}

---@type dap.Configuration[]
local ts_config = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Run current file",
    runtimeExecutable = "tsx",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to Node process",
    port = function() return vim.fn.input("Port: ") end,
    cwd = "${workspaceFolder}",
  },
}

dap.configurations.javascript = js_config
dap.configurations.javascriptreact = js_config
dap.configurations.typescript = ts_config
dap.configurations.typescriptreact = ts_config

---@class DBG: Hydra
local Mode

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
  if Mode.hint.win then
    Mode.hint:close()
  else
    Mode.hint:show()
  end
end

local cursor_mode_off = vim.o.guicursor
local cursor_mode_on = cursor_mode_off .. ",a:DapCursor"

---@type DBG
Mode = Hydra({
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
      vim.api.nvim_exec_autocmds("User", { pattern = "HydraEnter" })
      vim.o.guicursor = cursor_mode_on
    end,
    on_exit = function()
      vim.api.nvim_exec_autocmds("User", { pattern = "HydraExit" })
      vim.o.guicursor = cursor_mode_off
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
    {
      "db",
      persistent_breakpoints_api.toggle_breakpoint,
      { desc = "Toggle breakpoint", private = true },
    },
    {
      "dc",
      persistent_breakpoints_api.set_conditional_breakpoint,
      { desc = "Set conditional breakpoint", private = true },
    },
    { "dl", persistent_breakpoints_api.set_log_point, { desc = "Log point", private = true } },
    {
      "dA",
      persistent_breakpoints_api.clear_all_breakpoints,
      { desc = "Clear all breakpoints", private = true },
    },
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
    {
      "<leader>w",
      dv.add_expr,
      { desc = "Watch expression", private = true, mode = { "n", "x" } },
    },
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
    { "<C-c>", function() Mode:exit_mode() end, { desc = "Terminate", exit = true } },

    -- Hint
    { "?", toggle_help, { desc = "Toggle Help", private = true } },
    { "g?", toggle_help, { desc = "Toggle Help", private = true } },
  },
})

function Mode:exit_mode()
  if self.layer then
    self.layer:exit()
  else
    self:exit()
  end
end

---@type dap.RequestListener
local function enable() Mode:activate() end

---@type dap.RequestListener
local function disable()
  Mode:exit_mode()
  dv.close(true)
end

local name = "dap-mode-config"

dap.listeners.before.attach[name] = enable
dap.listeners.before.launch[name] = enable
dap.listeners.after.event_terminated[name] = disable
dap.listeners.after.event_exited[name] = disable

-- vim.api.nvim_create_autocmd("BufEnter", {
--   group = require("augroup"),
--   pattern = "*",
--   callback = function()
--     if not dap.session() then return end
--
--     ---@diagnostic disable-next-line: param-type-mismatch
--     if vim.bo.filetype:startswith("dap-") then
--       mode:exit_mode()
--     else
--       mode:activate()
--     end
--   end,
-- })

vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "Debug: Start" })
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run last" })
vim.keymap.set(
  "n",
  "<leader>dm",
  function() Mode:activate() end,
  { desc = "Debug: Toggle mode", nowait = true }
)
