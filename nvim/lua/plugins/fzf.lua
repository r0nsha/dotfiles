return {
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require "fzf-lua"

      fzf.setup {
        { "skim" },
        winopts = {
          border = "single",
          -- preview = {
          --   border = "single",
          -- },
        },
        keymaps = {
          fzf = {
            ["ctrl-u"] = "preview-page-up",
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-q"] = "select-all+accept",
          },
        },
      }

      ---@param desc string
      local function opts(desc)
        return {
          silent = false,
          remap = false,
          desc = "Fzf: " .. desc,
        }
      end

      ---@param mode "n" | "v"
      ---@param key string
      ---@param fn function
      ---@param desc string
      local function keymap(mode, key, fn, desc)
        vim.keymap.set(mode, "<leader>s" .. key, fn, opts(desc))
      end

      vim.keymap.set("n", "<leader><leader>", function()
        fzf.resume()
      end, opts "Resume")

      keymap("n", "f", function()
        local utils = require "utils"
        local in_git_repo = os.execute "git rev-parse --is-inside-work-tree" == 0

        -- don't show file icons in very (VERY) large repos, for performance
        local local_opts = utils.repo_too_large() and { git_icons = false, file_icons = false } or {}

        if in_git_repo then
          fzf.git_files(local_opts)
        else
          fzf.files(local_opts)
        end
      end, "Files")

      keymap("n", "F", function()
        fzf.files()
      end, "Git files")

      keymap("n", "c", function()
        fzf.colorschemes {}
      end, "Colorschemes")

      keymap("n", "h", function()
        fzf.helptags {}
      end, "Helptags")

      keymap("n", "o", function()
        fzf.oldfiles()
      end, "Oldfiles")

      keymap("n", "w", function()
        fzf.grep_cword {}
      end, "Grep word")

      keymap("n", "W", function()
        fzf.grep_cWORD {}
      end, "Grep WORD")

      keymap("n", "b", function()
        fzf.buffers {}
      end, "Buffers")

      keymap("n", "s", function()
        fzf.live_grep()
      end, "Live grep")

      keymap("v", "s", function()
        fzf.grep_visual()
      end, "Grep visual selection")

      keymap("n", "S", function()
        fzf.live_grep_glob()
      end, "Live grep (Glob)")
    end,
  },
}
