---@module "lazy"
---@type LazySpec
return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Buffer: Delete",
    },
    {
      "<leader>bD",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Buffer: Delete Other",
    },
  },
}
