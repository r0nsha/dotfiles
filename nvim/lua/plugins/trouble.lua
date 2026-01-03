local trouble = require "trouble"
trouble.setup {
  indent_guides = false,
  modes = {
    diagnostics_buffer = {
      mode = "diagnostics",
      filter = { buf = 0 },
    },
  },
  keys = {
    ["<C-n>"] = "next",
    ["<C-p>"] = "prev",
  },
}

vim.keymap.set("n", "<leader>x", function()
  trouble.toggle "diagnostics"
end, { desc = "Toggle trouble" })

vim.keymap.set("n", "<leader>X", function()
  trouble.toggle "diagnostics_buffer"
end, { desc = "Toggle trouble" })

vim.keymap.set("n", "<A-n>", function()
  if trouble.is_open() then
    ---@diagnostic disable-next-line: missing-fields, missing-parameter
    trouble.next { skip_groups = true, jump = true }
  else
    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, "cnext")
  end
end)

vim.keymap.set("n", "<A-p>", function()
  if trouble.is_open() then
    ---@diagnostic disable-next-line: missing-fields, missing-parameter
    trouble.prev { skip_groups = true, jump = true }
  else
    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, "cprev")
  end
end)
