---@module "lazy"
---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = {
    image = {
      doc = {
        inline = false,
        float = false,
      },
    },
  },
  keys = {
    {
      "<leader>ci",
      function()
        require("snacks").image.hover()
      end,
      desc = "Image: Hover",
    },
  },
}
