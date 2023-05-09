return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "nvim-dap-virtual-text",
      "nvim-dap-ui",
      "nvim-dap-python",
      "which-key.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope-dap.nvim",
      { "jbyuki/one-small-step-for-vimkind" },
    },
    config = function()
      local wk = require "which-key"

      require("nvim-dap-virtual-text").setup {
        commented = true,
      }

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

      -- Debug: Mappings
      wk.register({
        d = {
          name = "Debug",
          R = {
            function()
              dap.run_to_cursor()
            end,
            "Run to Cursor",
          },
          E = {
            function()
              dapui.eval(vim.fn.input "[Expression] > ")
            end,
            "Evaluate Input",
          },
          C = {
            function()
              dap.set_breakpoint(vim.fn.input "[Condition] > ")
            end,
            "Conditional Breakpoint",
          },
          U = {
            function()
              dapui.toggle()
            end,
            "Toggle UI",
          },
          b = {
            function()
              dap.step_back()
            end,
            "Step Back",
          },
          c = {
            function()
              dap.continue()
            end,
            "Continue",
          },
          d = {
            function()
              dap.disconnect()
            end,
            "Disconnect",
          },
          e = {
            function()
              dapui.eval()
            end,
            "Evaluate",
          },
          g = {
            function()
              dap.session()
            end,
            "Get Session",
          },
          h = {
            function()
              require("dap.ui.widgets").hover()
            end,
            "Hover Variables",
          },
          S = {
            function()
              require("dap.ui.widgets").scopes()
            end,
            "Scopes",
          },
          i = {
            function()
              dap.step_into()
            end,
            "Step Into",
          },
          o = {
            function()
              dap.step_over()
            end,
            "Step Over",
          },
          p = {
            function()
              dap.pause.toggle()
            end,
            "Pause",
          },
          q = {
            function()
              dap.close()
            end,
            "Quit",
          },
          r = {
            function()
              dap.repl.toggle()
            end,
            "Toggle Repl",
          },
          s = {
            function()
              dap.continue()
            end,
            "Start",
          },
          t = {
            function()
              dap.toggle_breakpoint()
            end,
            "Toggle Breakpoint",
          },
          x = {
            function()
              dap.terminate()
            end,
            "Terminate",
          },
          u = {
            function()
              dap.step_out()
            end,
            "Step Out",
          },
        },
      }, {
        mode = "n",
        prefix = "<leader>",
        buffer = nil,
        silent = true,
        remap = false,
        nowait = false,
      })

      wk.register({
        name = "Debug",
        e = {
          function()
            dapui.eval()
          end,
          "Evaluate",
        },
      }, {
        mode = "v",
        prefix = "<leader>",
        buffer = nil,
        silent = true,
        remap = false,
        nowait = false,
      })
    end,
  },
}
