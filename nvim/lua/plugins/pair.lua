return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      }
    end,
  },
  { "RRethy/nvim-treesitter-endwise" },
}
