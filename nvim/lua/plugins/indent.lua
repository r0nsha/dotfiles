return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("ibl").setup {
        indent = {
          char = "┊",
          highlight = { "Whitespace" },
        },
        scope = {
          char = "│",
          highlight = { "Normal" },
        },
        exclude = {
          filetypes = {
            "markdown",
            "lspinfo",
            "packer",
            "checkhealth",
            "man",
            "gitcommit",
            "TelescopePrompt",
            "TelescopeResults",
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
          },
        },
      }
    end,
  },
}
