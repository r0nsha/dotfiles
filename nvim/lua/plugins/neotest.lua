---@diagnostic disable-next-line: missing-fields
require("neotest").setup({
  adapters = {
    require("neotest-vitest"),
    {
      ---@diagnostic disable-next-line: unused-local
      filter_dir = function(name, rel_path, root) return name ~= "node_modules" end,
    },
  },
  consumers = {
    ---@diagnostic disable-next-line: assign-type-mismatch - "neotest.consumers.overseer" is callable
    overseer = require("neotest.consumers.overseer"),
  },
})

vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run() end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tl", function() require("neotest").run.run_last() end, { desc = "Run last test" })
vim.keymap.set(
  "n",
  "<leader>td",
  function() require("neotest").run.run({ strategy = "dap", suite = false }) end,
  { desc = "Debug nearest test" }
)
vim.keymap.set("n", "<leader>ta", function() require("neotest").run.attach() end, { desc = "Attach to nearest test" })
vim.keymap.set("n", "<leader>tx", function() require("neotest").run.stop() end, { desc = "Stop nearest test" })
vim.keymap.set(
  "n",
  "<leader>tf",
  function() require("neotest").run.run(vim.fn.expand("%")) end,
  { desc = "Run all tests in file" }
)
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
vim.keymap.set(
  "n",
  "<leader>to",
  function() require("neotest").output_panel.toggle() end,
  { desc = "Show test output" }
)
