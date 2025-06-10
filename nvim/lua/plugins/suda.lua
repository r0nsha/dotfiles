return {
  "lambdalisue/suda.vim",
  keys = {
    { "<leader>w", "<cmd>w<cr>", desc = "Write the current file" },
    { "<leader>W", "<cmd>SudaWrite<cr>", desc = "Write the current file with sudo" },
  },
  cmd = { "SudaWrite", "SudaRead" },
}
