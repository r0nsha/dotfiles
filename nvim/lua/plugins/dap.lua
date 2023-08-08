return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "nvim-dap-virtual-text",
      "nvim-dap-ui",
      "nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope-dap.nvim",
      { "jbyuki/one-small-step-for-vimkind" },
    },
    config = function()
      require("nvim-dap-virtual-text").setup {
        commented = true,
      }

      -- https://github.com/simrat39/rust-tools.nvim/wiki/Use-with-dap.ext.vscode-launch.json
      require("dap.ext.vscode").load_launchjs(nil, { rt_lldb = { "rust" } })

      local dap, dapui = require "dap", require "dapui"

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

      -- Debug: Lua
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

      dap.adapters.nlua = function(callback, config)
        callback { type = "server", host = config.host, port = config.port }
      end

      -- Debug: Python
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python", {})
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch main.py",
        program = "./main.py",
        python = { "./venv/bin/python" },
      })

      -- Debug: LLDB/Rust
      dap.configurations.rust = {
        {
          type = "executable",
          command = "lldb-vscode",
          name = "lldb",
        },
      }

      -- Mappings
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
      vim.keymap.set({ "n", "v" }, key "e", dapui.eval, opts "Evaluate")
      vim.keymap.set("n", key "g", dap.session, opts "Get session")

      vim.keymap.set("n", key "R", dap.run_to_cursor, opts "Run to cursor")

      vim.keymap.set("n", key "c", dap.continue, opts "Continue")
      vim.keymap.set("n", key "i", dap.step_into, opts "Step into")
      vim.keymap.set("n", key "o", dap.step_over, opts "Step over")
      vim.keymap.set("n", key "u", dap.step_out, opts "Step out")
      vim.keymap.set("n", key "b", dap.step_back, opts "Step back")

      vim.keymap.set("n", key "p", function()
        dap.pause.toggle()
      end, opts "Pause")

      vim.keymap.set("n", key "t", dap.toggle_breakpoint, opts "Toggle breakpoint")

      vim.keymap.set("n", key "r", dap.repl.toggle, opts "Toggle Repl")

      vim.keymap.set("n", key "h", function()
        require("dap.ui.widgets").hover()
      end, opts "Hover variables")

      vim.keymap.set("n", key "S", function()
        require("dap.ui.widgets").scopes()
      end, opts "Scopes")

      vim.keymap.set("n", key "E", function()
        dapui.eval(vim.fn.input "[Expression] > ")
      end, opts "Evaluate input")

      vim.keymap.set("n", key "C", function()
        dap.set_breakpoint(vim.fn.input "[Condition] > ")
      end, opts "Conditional breakpoint")

      vim.keymap.set("n", key "x", dap.terminate, opts "Terminate")
      vim.keymap.set("n", key "q", dap.close, opts "Quit")
    end,
  },
}
