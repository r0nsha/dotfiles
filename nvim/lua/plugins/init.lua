---@module "lazy"
---@type LazySpec
return {
  { "nvim-lua/plenary.nvim" },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
