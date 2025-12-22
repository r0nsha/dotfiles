---@module "lazy"
---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          max_lines = 0,
          multiline_threshold = 2,
          -- enable = true,
          -- multiwindow = false,
          -- min_window_height = 0,
          -- line_numbers = true,
          -- multiline_threshold = 20,
          -- trim_scope = "outer",
          -- mode = "cursor",
          -- max_lines = 4,
        },
      },
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "query",
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
          "go",
          "gomod",
          "gowork",
          "diff",
          "http",
        },
        sync_install = false,
        auto_install = true,
        matchup = { enable = true },
        indent = { enable = true },
        highlight = {
          enable = true,
          disable = function(lang, buf)
            _ = lang
            local max_filesize = 20 * 1024 -- 20 KB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              vim.notify(
                "File larger than 20KB treesitter disabled for performance",
                vim.log.levels.WARN,
                { title = "Treesitter" }
              )
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = { "markdown" },
        },
      }

      local parsers = require "nvim-treesitter.parsers"
      local parser_config = parsers.get_parser_configs()
      parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

      vim.keymap.set("n", "<leader>ih", "<cmd>Inspect<cr>", { desc = "TS: Inspect" })
      vim.keymap.set("n", "<leader>ip", "<cmd>InspectTree<cr>", { desc = "TS: Inspect Tree" })
      vim.keymap.set("n", "<leader>iq", "<cmd>EditQuery<cr>", { desc = "TS: Edit Query" })

      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local treesj = require "treesj"

      treesj.setup {
        use_default_keymaps = false,
        max_join_length = 9000,
      }

      vim.keymap.set({ "n", "v" }, "<leader>j", treesj.toggle, { desc = "Toggle Split/Join" })
    end,
  },
}
