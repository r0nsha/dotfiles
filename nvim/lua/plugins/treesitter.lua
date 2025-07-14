return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          vim.g.skip_ts_context_commentstring_module = true
          require("treesitter-context").setup({
            enable = true,
            multiwindow = false,
            max_lines = 0,
            min_window_height = 0,
            line_numbers = true,
            multiline_threshold = 20,
            trim_scope = "outer",
            mode = "cursor",
          })
        end,
      },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          require("ts_context_commentstring").setup({})
        end,
      },
      {
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle" },
        keys = { { "<leader>ip", "<cmd>TSPlaygroundToggle<cr>", desc = "TS: Playground" } },
      },
    },
    config = function()
      local utils = require("utils")

      require("nvim-treesitter.configs").setup({
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
        },
        sync_install = false,
        auto_install = true,
        matchup = { enable = true },
        indent = { enable = true },
        highlight = {
          enable = true,
          disable = function(lang, buf)
            _ = lang

            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              vim.notify(
                "File larger than 100KB treesitter disabled for performance",
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
        context_commentstring = { enable = true, enable_autocmd = false },
      })

      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

      if utils.is_windows() then
        local install = require("nvim-treesitter.install")
        install.prefer_git = false
        install.compilers = { "clang" }
      end

      vim.keymap.set("n", "<leader>ih", "<cmd>Inspect<cr>", { desc = "TS: Inspect" })
      vim.keymap.set("n", "<leader>iq", "<cmd>EditQuery<cr>", { desc = "TS: Edit Query" })
    end,
  },
  {
    "razak17/tailwind-fold.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "svelte", "astro", "vue", "javascriptreact", "typescriptreact", "php", "blade" },
    config = function()
      require("tailwind-fold").setup({
        min_chars = 30,
        symbol = "…",
      })
      vim.keymap.set("n", "<leader>cn", "<cmd>TailwindFoldToggle<cr>", { desc = "Tailwind Fold: Toggle" })
    end,
  },
}
