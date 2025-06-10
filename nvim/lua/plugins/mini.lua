return {
  "echasnovski/mini.nvim",
  version = "*",
  config = function()
    require("mini.bufremove").setup()

    vim.keymap.set("n", "<leader>bd", function()
      require("mini.bufremove").delete(0, false)
    end, { desc = "Buffer: Delete" })

    vim.keymap.set("n", "<leader>bD", function()
      require("mini.bufremove").delete(0, true)
    end, { desc = "Buffer: Delete (Force)" })
  end,
}
