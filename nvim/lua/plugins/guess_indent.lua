---@module "lazy"
---@type LazySpec
return {
  "nmac427/guess-indent.nvim",
  config = function()
    require("guess-indent").setup {}
  end,
}
