return {
  {
    "nvim-neotest/neotest",
    keys = {
      {
        "<leader>tt",
        function()
          print "Test: Running nearest..."
          require("neotest").run.run()
        end,
        desc = "Test: Run nearest",
      },
      {
        "<leader>tf",
        function()
          print "Test: Running current file..."
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Test: Run current file",
      },
      {
        "<leader>td",
        function()
          print "Test: Debugging nearest..."
          require("neotest").run.run {
            strategy = "dap",
            extra_args = { "--no-cov" },
          }
        end,
        desc = "Test: Debug nearest",
      },
      {
        "<leader>tl",
        function()
          print "Test: Running last..."
          require("neotest").run.run_last()
        end,
        desc = "Test: Run last",
      },
      {
        "<leader>tx",
        function()
          print "Test: Stopping..."
          require("neotest").run.stop()
        end,
        desc = "Test: Stop",
      },
      {
        "<leader>ta",
        function()
          print "Test: Attaching..."
          require("neotest").run.attach()
        end,
        desc = "Test: Attach",
      },
      {
        "<leader>to",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test: Summary",
      },
      {
        "<leader>tp",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Test: Output panel",
      },
    },
    dependencies = {
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-plenary",
          require "neotest-python" {
            dap = { justMyCode = false },
            runner = "pytest",
            args = {
              "--cov=.",
              "--cov-branch",
              "--cov-context=test",
            },
          },
        },
        icons = {
          passed = " ",
          running = " ",
          failed = " ",
          unknown = " ",
        },
      }
    end,
  },
  {
    "andythigpen/nvim-coverage",
    keys = {
      {
        "<leader>tcc",
        function()
          require("coverage").toggle()
        end,
        "Coverage: Toggle",
      },
      {
        "<leader>tcl",
        function()
          require("coverage").load { place = true }
        end,
        "Coverage: Load",
      },
      {
        "<leader>tcs",
        function()
          require("coverage").summary()
        end,
        "Coverage: Summary",
      },
    },
    config = function()
      require("coverage").setup {
        auto_reload = true,
        load_coverage_cb = function(ftype)
          vim.notify("Loaded " .. ftype .. " coverage")
        end,
      }
    end,
  },
}
