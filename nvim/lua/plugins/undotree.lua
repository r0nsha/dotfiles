vim.keymap.set("n", "<leader>u", function()
  require("undotree").open { command = "topleft 40vnew" }
end, { desc = "Undotree" })
