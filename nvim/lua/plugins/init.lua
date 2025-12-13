return {
  { "nvim-lua/plenary.nvim" },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = {
      -- {
      --   "DrKJeff16/wezterm-types",
      --   version = false,
      --   lazy = true,
      --   name = "wezterm-types",
      -- },
    },
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
}
