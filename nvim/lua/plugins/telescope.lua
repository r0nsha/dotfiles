return {
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      local builtin = require "telescope.builtin"

      telescope.setup {
        defaults = {
          path_display = { "smart" },
          mappings = {
            n = {
              ["q"] = actions.close,
            },
          },
          prompt_prefix = "   ",
          selection_caret = "󰅂 ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = { "node_modules" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        },
      }

      -- Extensions
      telescope.load_extension "fzy_native"
      telescope.load_extension "live_grep_args"
      telescope.load_extension "ui-select"
      telescope.load_extension "project"
      telescope.load_extension "live_grep_args"

      -- Mappings

      local wk = require "which-key"

      wk.register({
        f = {
          function()
            local _, ret, _ = require("telescope.utils").get_os_command_output {
              "git",
              "rev-parse",
              "--is-inside-work-tree",
            }

            local opts = { no_ignore = true, hidden = true }

            if ret == 0 then
              builtin.git_files(opts)
            else
              builtin.find_files(opts)
            end
          end,
          "Project files",
        },
        F = {
          function()
            builtin.find_files {
              no_ignore = true,
              hidden = true,
            }
          end,
          "Find files",
        },
        w = {
          function()
            builtin.grep_string {}
          end,
          "Grep word",
        },
        c = {
          function()
            builtin.commands {}
          end,
          "Commands",
        },
        t = {
          function()
            builtin.colorscheme {}
          end,
          "Colorscheme",
        },
        [";"] = {
          function()
            builtin.resume {}
          end,
          "W",
        },
        p = {
          function()
            telescope.extensions.project.project {
              display_type = "full",
              no_ignore = true,
              hidden_files = true,
            }
          end,
          "Project",
        },
        e = {
          function()
            builtin.diagnostics {}
          end,
          "Diagnostics",
        },
        o = {
          function()
            builtin.oldfiles {}
          end,
          "Recent files",
        },
        R = {
          function()
            telescope.extensions.live_grep_args.live_grep_args()
          end,
          "Live Grep w/ args",
        },
        b = {
          function()
            builtin.current_buffer_fuzzy_find { skip_empty_lines = false }
          end,
          "Current buffer fuzzy find",
        },
      }, {
        mode = "n",
        prefix = ";",
        buffer = nil,
        silent = false,
        remap = false,
        nowait = false,
      })

      wk.register({
        r = {
          function()
            local function get_visual_selection()
              vim.cmd 'noau normal! "vy"'
              local text = vim.fn.getreg "v"
              vim.fn.setreg("v", {})

              text = string.gsub(text, "\n", "")
              if #text > 0 then
                return text
              else
                return ""
              end
            end

            local selected_text = get_visual_selection()
            builtin.live_grep {
              default_text = selected_text,
            }
          end,
          "Live Grep",
        },
      }, {
        mode = { "n", "v" },
        prefix = ";",
        buffer = nil,
        silent = false,
        remap = false,
        nowait = false,
      })
    end,
  },
}
