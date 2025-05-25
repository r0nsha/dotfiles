return {
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree: Toggle" },
    },
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_WindowLayout = 1
      vim.g.undotree_SplitWidth = 40
      vim.g.undotree_DiffpanelHeight = 10
      vim.g.undotree_ShortIndicators = 0
    end,
  },
}
