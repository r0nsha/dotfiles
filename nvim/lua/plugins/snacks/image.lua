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
    styles = {
      -- snacks_image = {
      --   border = "single",
      --   col = 0,
      -- },
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
