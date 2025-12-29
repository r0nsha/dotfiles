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

      ---@param args vim.api.keyset.create_autocmd.callback_args
      local function start_treesitter(args)
        local lang = vim.treesitter.language.get_lang(args.match) or args.match

        local ok = pcall(vim.treesitter.start, args.buf, lang)
        if not ok then
          return
        end

        ts.install { lang }

        vim.bo[args.buf].syntax = "on"
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      -- Auto-install parsers and enable highlighting for filetypes
      local group = vim.api.nvim_create_augroup("TreesitterInstall", { clear = true })
      vim.api.nvim_create_autocmd("FileType", { group = group, pattern = parsers, callback = start_treesitter })
      vim.api.nvim_create_user_command("TSStart", start_treesitter, {})

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
