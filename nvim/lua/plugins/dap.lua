return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "nvim-dap-virtual-text",
      "nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "jbyuki/one-small-step-for-vimkind",
    },
    config = function()
      require("nvim-dap-virtual-text").setup {
        commented = true,
      }

      local dap = require "dap"
      local dapui = require "dapui"

      dap.set_log_level "INFO"
      dapui.setup {}

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Adapters

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

      -- Configurations
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

      local function key(k)
        return "<leader>d" .. k
      end

      local function opts(desc)
        return {
          remap = false,
          desc = "Debug: " .. desc,
        }
      end

      vim.keymap.set("n", key "s", dap.continue, opts "Start")
      vim.keymap.set("n", key "d", dap.disconnect, opts "Disconnect")

      vim.keymap.set("n", key "U", dapui.toggle, opts "Toggle UI")
      vim.keymap.set("n", key "g", dap.session, opts "Get session")

      vim.keymap.set("n", key "R", dap.run_to_cursor, opts "Run to cursor")

      vim.keymap.set("n", key "c", dap.continue, opts "Continue")
      vim.keymap.set("n", key "j", dap.step_back, opts "Step back")
      vim.keymap.set("n", key "k", dap.step_over, opts "Step over")
      vim.keymap.set("n", key "h", dap.step_out, opts "Step out")
      vim.keymap.set("n", key "l", dap.step_into, opts "Step into")

      vim.keymap.set("n", key "p", function()
        dap.pause.toggle()
      end, opts "Pause")

      vim.keymap.set("n", key "t", dap.toggle_breakpoint, opts "Toggle breakpoint")
      vim.keymap.set("n", key "T", function()
        dap.set_breakpoint(vim.fn.input "[Condition] > ")
      end, opts "Conditional breakpoint")

      vim.keymap.set("n", key "r", dap.repl.toggle, opts "Toggle Repl")

      vim.keymap.set("n", key "K", function()
        require("dap.ui.widgets").hover()
      end, opts "Hover variables")

      vim.keymap.set("n", key "S", function()
        require("dap.ui.widgets").scopes()
      end, opts "Scopes")

      vim.keymap.set({ "n", "v" }, key "e", dapui.eval, opts "Evaluate")
      vim.keymap.set("n", key "E", function()
        dapui.eval(vim.fn.input "[Expression] > ")
      end, opts "Evaluate input")

      vim.keymap.set("n", key "x", dap.terminate, opts "Terminate")
      vim.keymap.set("n", key "q", dap.close, opts "Quit")
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    config = function()
      require("dap-go").setup {}
    end,
  },
}
