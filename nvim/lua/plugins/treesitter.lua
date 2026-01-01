---@module "lazy"
---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function()
      require("nvim-treesitter").update()
    end,
    config = function()
      local ts = require "nvim-treesitter"

      local parsers = {
        "query",
        "lua",
        "luadoc",
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
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "yaml",
        "xml",
        "regex",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "make",
        "bash",
        "fish",
        "go",
        "gomod",
        "gowork",
        "diff",
        "http",
        "typst",
        "comment",
      }

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        once = true,
        callback = function()
          ts.install(parsers)
        end,
      })

      ---@param buf number
      ---@param ft string
      local function start_treesitter(buf, ft)
        local lang = vim.treesitter.language.get_lang(ft) or ft

        local ok = pcall(vim.treesitter.start, buf, lang)
        if not ok then
          return
        end

        ts.install { lang }

        vim.bo[buf].syntax = "on"
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      -- Auto-install parsers and enable highlighting for filetypes
      local group = vim.api.nvim_create_augroup("TreesitterInstall", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          start_treesitter(args.buf, args.match)
        end,
      })
      vim.api.nvim_create_user_command("TSStart", function()
        start_treesitter(0, vim.bo.filetype)
      end, {})

      vim.keymap.set("n", "<leader>ih", "<cmd>Inspect<cr>", { desc = "TS: Inspect" })
      vim.keymap.set("n", "<leader>ip", "<cmd>InspectTree<cr>", { desc = "TS: Inspect Tree" })
      vim.keymap.set("n", "<leader>iq", "<cmd>EditQuery<cr>", { desc = "TS: Edit Query" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      max_lines = 0,
      multiline_threshold = 2,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("ts_context_commentstring").setup {
        enable_autocmd = false,
      }

      local get_option = vim.filetype.get_option
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local treesj = require "treesj"
      treesj.setup { use_default_keymaps = false, max_join_length = 9000 }
      vim.keymap.set({ "n", "x" }, "gS", treesj.toggle, { desc = "Splitjoin" })
    end,
  },
}
