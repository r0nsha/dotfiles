return {
	{
		"nvim-neotest/neotest",
		event = "VeryLazy",
		dependencies = {
			{ "nvim-neotest/neotest-python", event = "VeryLazy" },
			{ "nvim-neotest/neotest-plenary", event = "VeryLazy" },
		},
		config = function()
			local neotest = require("neotest")
			local wk = require("which-key")

			neotest.setup({
				adapters = {
					require("neotest-plenary"),
					require("neotest-python")({
						dap = { justMyCode = false },
						runner = "pytest",
						args = {
							"--cov=.",
							"--cov-branch",
							"--cov-context=test",
						},
					}),
				},
				icons = {
					passed = " ",
					running = " ",
					failed = " ",
					unknown = " ",
				},
			})

			wk.register({
				t = {
					name = "Test",
					t = {
						function()
							print("Test: Running nearest...")
							neotest.run.run()
						end,
						"Run nearest",
					},
					f = {
						function()
							print("Test: Running file...")
							neotest.run.run(vim.fn.expand("%"))
						end,
						"Run current file",
					},
					d = {
						function()
							print("Test: Debugging nearest...")
							neotest.run.run({
								strategy = "dap",
								extra_args = { "--no-cov" },
							})
						end,
						"Debug nearest",
					},
					l = {
						function()
							print("Test: Running last...")
							neotest.run.run_last()
						end,
						"Run nearest",
					},
					x = {
						function()
							print("Test: Stopping nearest...")
							neotest.run.stop()
						end,
						"Stop nearest",
					},
					a = {
						function()
							print("Test: Attaching to nearest...")
							neotest.run.attach()
						end,
						"Attach to nearest",
					},
					o = {
						function()
							neotest.summary.toggle()
						end,
						"Open summary",
					},
					p = {
						function()
							neotest.output_panel.toggle()
						end,
						"Open output panel",
					},
				},
			}, {
				mode = "n",
				prefix = "'",
				buffer = nil,
				silent = true,
				remap = false,
				nowait = false,
			})
		end,
	},
	{
		"andythigpen/nvim-coverage",
		event = "VeryLazy",
		config = function()
			local coverage = require("coverage")
			local wk = require("which-key")

			coverage.setup({
				auto_reload = true,
				load_coverage_cb = function(ftype)
					vim.notify("Loaded " .. ftype .. " coverage")
				end,
			})

			wk.register({
				c = {
					name = "Coverage",
					c = {
						function()
							coverage.toggle()
						end,
						"Toggle",
					},
					l = {
						function()
							coverage.load({ place = true })
						end,
						"Load",
					},
					s = {
						function()
							coverage.summary()
						end,
						"Summary",
					},
				},
			}, {
				mode = "n",
				prefix = "'",
				buffer = nil,
				silent = true,
				remap = false,
				nowait = false,
			})
		end,
	},
}
