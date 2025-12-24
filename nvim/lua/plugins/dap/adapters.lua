local dap = require "dap"

dap.adapters.nlua = function(callback, config)
  callback { type = "server", host = config.host, port = config.port }
end

dap.adapters.lldb = {
  type = "executable",
  command = "lldb-vscode",
  name = "lldb",
}

dap.adapters.rust = {
  type = "executable",
  attach = { pidProperty = "pid", pidSelect = "ask" },
  command = "lldb-vscode", -- my binary was called 'lldb-vscode-11'
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
      local argument_string = vim.fn.input "Program arguments: "
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
      local args_str = vim.fn.input "Program arguments: "
      local args = vim.fn.split(args_str, " ", true)
      return { "build", "-o", "build", unpack(args) }
    end,

    -- Types
    initCommands = function()
      -- Find out where to look for the pretty printer Python module
      local rustc_sysroot = vim.fn.trim(vim.fn.system "rustc --print sysroot")

      local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
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
    host = function()
      local value = vim.fn.input "Host [127.0.0.1]: "
      if value ~= "" then
        return value
      end
      return "127.0.0.1"
    end,
    port = function()
      local val = tonumber(vim.fn.input("Port: ", "54321"))
      assert(val, "Please provide a port number")
      return val
    end,
  },
}

require("dap-go").setup {
  delve = {
    detached = vim.fn.has "win32" == 0,
  },
}

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = {
      vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
      "${port}",
    },
  },
}

---@type dap.Configuration[]
local config = {
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to Node.js",
    port = function()
      local co = coroutine.running()
      local result
      vim.ui.input({ prompt = "Port: " }, function(input)
        result = input
        if co then
          coroutine.resume(co)
        end
      end)
      if co then
        coroutine.yield()
      end
      return tonumber(result)
    end,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    localRoot = "${workspaceFolder}/dist/domains/data/apps/consumers/static-extension-analysis",
    remoteRoot = "/backend",
    sourceMapPathOverrides = {
      ["webpack:///./*"] = "${workspaceFolder}/domains/data/apps/consumers/static-extension-analysis/*",
      ["webpack:///../../../../../*"] = "${workspaceFolder}/*",
    },
  },
}

local fts = {
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
}

for _, ft in ipairs(fts) do
  dap.configurations[ft] = config
end
