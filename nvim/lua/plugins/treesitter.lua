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
          "vimdoc",
          "rust",
          "go",
          "toml",
          "markdown",
          "markdown_inline",
          "c",
          "cpp",
          "python",
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
        context_commentstring = { enable = true, enable_autocmd = false },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["ip"] = "@parameter.inner",
            },
            swap_previous = {
              ["iP"] = "@parameter.inner",
            },
          },
        },
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
