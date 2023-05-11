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

      local function key(k)
        return ";" .. k
      end

      local function opts(desc)
        return {
          silent = false,
          remap = false,
          desc = desc,
        }
      end

      vim.keymap.set("n", key "f", function()
        local _, ret, _ = require("telescope.utils").get_os_command_output {
          "git",
          "rev-parse",
          "--is-inside-work-tree",
        }

        if ret == 0 then
          builtin.git_files { no_ignore = true, hidden = true }
        else
          builtin.find_files { no_ignore = true, hidden = true }
        end
      end, opts "Find files")

      vim.keymap.set("n", key "F", function()
        builtin.find_files {
          no_ignore = true,
          hidden = true,
        }
      end, opts "Find all files")

      vim.keymap.set("n", key "c", function()
        builtin.commands {}
      end, opts "Commands")

      vim.keymap.set("n", key "t", function()
        builtin.colorscheme {}
      end, opts "Colorschemes")

      vim.keymap.set("n", key ";", function()
        builtin.resume {}
      end, opts "Resume")

      vim.keymap.set("n", key "p", function()
        telescope.extensions.project.project {
          display_type = "full",
          no_ignore = true,
          hidden_files = true,
        }
      end, opts "Projects")

      vim.keymap.set("n", key "e", function()
        builtin.diagnostics {}
      end, opts "Diagnostics")

      vim.keymap.set("n", key "o", function()
        builtin.oldfiles {}
      end, opts "Recent files")

      vim.keymap.set("n", key "w", function()
        builtin.grep_string {}
      end, opts "Find word")

      vim.keymap.set("n", key "b", function()
        builtin.current_buffer_fuzzy_find { skip_empty_lines = false }
      end, opts "Search in buffer")

      vim.keymap.set({ "n", "v" }, key "r", function()
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
      end, opts "Search")

      vim.keymap.set("n", key "R", function()
        telescope.extensions.live_grep_args.live_grep_args()
      end, opts "Search w/ args")
    end,
  },
}
