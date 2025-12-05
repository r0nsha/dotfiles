return {
  { "rafikdraoui/jj-diffconflicts" },
  {
    "nicolasgb/jj.nvim",
    config = function()
      local jj = require("jj")
      jj.setup({})

      local cmd = require("jj.cmd")
      vim.keymap.set("n", "<leader>gg", cmd.status, { desc = "JJ status" })
      vim.keymap.set("n", "<leader>gD", cmd.diff, { desc = "JJ diff" })
      vim.keymap.set("n", "<leader>gl", cmd.log, { desc = "JJ log" })
    end,
  },
}
