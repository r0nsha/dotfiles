return {
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require "fzf-lua"
      fzf.setup { "borderless_full" }

      local function opts(desc)
        return {
          silent = false,
          remap = false,
          desc = desc,
        }
      end

      vim.keymap.set("n", "<leader><leader>", function()
        fzf.resume()
      end, opts "Resume")

      vim.keymap.set("n", "<leader>sf", function()
        fzf.files {}
      end, opts "Files")

      vim.keymap.set("n", "<leader>sF", function()
        local exit = os.execute "git rev-parse --is-inside-work-tree"

        if exit == 0 then
          fzf.git_files {}
        else
          fzf.files {}
        end
      end, opts "Git files")

      vim.keymap.set("n", "<leader>sc", function()
        fzf.colorschemes {}
      end, opts "Colorschemes")

      vim.keymap.set("n", "<leader>se", function()
        fzf.diagnostics_workspace {}
      end, opts "Diagnostics")

      vim.keymap.set("n", "<leader>so", function()
        fzf.oldfiles {}
      end, opts "Oldfiles")

      vim.keymap.set("n", "<leader>sw", function()
        fzf.grep_cword {}
      end, opts "Grep word")

      vim.keymap.set("n", "<leader>sW", function()
        fzf.grep_cWORD {}
      end, opts "Grep WORD")

      vim.keymap.set("n", "<leader>sb", function()
        fzf.buffers {}
      end, opts "Buffers")

      vim.keymap.set("n", "<leader>ss", function()
        fzf.live_grep_native()
      end, opts "Live grep")

      vim.keymap.set("v", "<leader>ss", function()
        fzf.grep_visual()
      end, opts "Grep visual selection")
    end,
  },
}
