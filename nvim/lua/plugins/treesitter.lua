return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      local utils = require "utils"

      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "lua",
          "vim",
          "rust",
          "toml",
          "markdown",
          "markdown_inline",
          "c",
          "html",
          "css",
          "javascript",
          "typescript",
          "tsx",
          "json",
          "yaml",
          "regex",
          "bash",
          "fish",
        },
        matchup = { enable = true },
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
        context_commentstring = { enable = true },
        textobjects = { enable = true },
      }

      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

      if utils.is_windows() then
        local install = require "nvim-treesitter.install"
        install.prefer_git = false
        install.compilers = { "clang" }
      end
    end,
  },
}
