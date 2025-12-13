return {
  { "rafikdraoui/jj-diffconflicts" },
  {
    "nicolasgb/jj.nvim",
    config = function()
      local jj = require "jj"
      jj.setup {}

      local cmd = require "jj.cmd"
      vim.keymap.set("n", "<leader>gg", cmd.log, { desc = "JJ log" })
      vim.keymap.set("n", "<leader>gs", cmd.status, { desc = "JJ status" })
      vim.keymap.set("n", "<leader>gD", cmd.diff, { desc = "JJ diff" })
    end,
  },
}
