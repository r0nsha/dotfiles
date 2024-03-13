return {
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require "fzf-lua"

      -- Borderless

      local hls = {
        bg = "PmenuSbar",
        sel = "PmenuSel",
      }

      fzf.setup {
        desc = "borderless and minimalistic",
        fzf_opts = {},
        winopts = {
          border = { " ", " ", " ", " ", " ", " ", " ", " " },
          preview = {
            scrollbar = "float",
            scrolloff = "-2",
            title_pos = "center",
          },
        },
        hls = {
          border = hls.bg,
          preview_border = hls.bg,
          preview_title = hls.sel,
          scrollfloat_e = "",
          scrollfloat_f = hls.sel,
        },
        fzf_colors = {
          ["gutter"] = { "bg", hls.bg },
          ["bg"] = { "bg", hls.bg },
          ["bg+"] = { "bg", hls.sel },
          ["fg+"] = { "fg", hls.sel },
        },
        defaults = {
          git_icons = false,
          file_icons = true,
        },
      }

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

      local default_fzf_args = {}

      vim.keymap.set("n", "<leader>sf", function()
        fzf.files(default_fzf_args)
      end, opts "Files")

      vim.keymap.set("n", "<leader>sF", function()
        local exit = os.execute "git rev-parse --is-inside-work-tree"

        if exit == 0 then
          fzf.git_files(default_fzf_args)
        else
          fzf.files(default_fzf_args)
        end
      end, opts "Git files")

      vim.keymap.set("n", "<leader>sc", function()
        fzf.colorschemes {}
      end, opts "Colorschemes")

      vim.keymap.set("n", "<leader>se", function()
        fzf.diagnostics_workspace {}
      end, opts "Diagnostics")

      vim.keymap.set("n", "<leader>so", function()
        fzf.oldfiles(default_fzf_args)
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
