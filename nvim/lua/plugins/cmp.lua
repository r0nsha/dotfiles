return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  version = "*",
  dependencies = {
    -- snippets
    "rafamadriz/friendly-snippets",
    { "echasnovski/mini.snippets" },

    -- sources
    "Kaiser-Yang/blink-cmp-git",

    -- misc
    "xzbdmw/colorful-menu.nvim",
  },
  config = function()
    local blink = require "blink.cmp"
    local utils = require "utils"

    local keymaps = {
      prev = {
        "snippet_backward",
        "select_prev",
        "show",
        "fallback_to_mappings",
      },

      next = {
        "snippet_forward",
        "select_next",
        "show",
        "fallback_to_mappings",
      },

      scroll_documentation_up = { "scroll_documentation_up", "fallback" },
      scroll_documentation_down = { "scroll_documentation_down", "fallback" },

      toggle_signature = { "show_signature", "hide_signature", "fallback" },
    }

    blink.setup {
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
        accept = {
          auto_brackets = {
            kind_resolution = {
              blocked_filetypes = { "typescriptreact", "javascriptreact", "vue", "codecompanion" },
            },
          },
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        prebuilt_binaries = {
          download = false,
        },
        sorts = { "exact", "score", "sort_text", "kind", "label" },
      },
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-c>"] = { "hide", "fallback" },
        ["<C-y>"] = { "select_and_accept" },

        ["<C-p>"] = keymaps.prev,
        ["<C-n>"] = keymaps.next,
        ["<Up>"] = keymaps.prev,
        ["<Down>"] = keymaps.next,

        ["<C-b>"] = keymaps.scroll_documentation_up,
        ["<C-f>"] = keymaps.scroll_documentation_down,
        ["<C-u>"] = keymaps.scroll_documentation_up,
        ["<C-d>"] = keymaps.scroll_documentation_down,

        ["<C-h>"] = keymaps.toggle_signature,
        ["<C-k>"] = { "show_documentation", "hide_documentation" },
      },
      snippets = {
        preset = "mini_snippets",
      },
      sources = {
        default = { "lazydev", "lsp", "snippets", "git", "path", "buffer" },
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          snippets = {
            enabled = function()
              return not utils.repo_too_large()
            end,
            -- enabled = true,
          },
          git = {
            name = "Git",
            module = "blink-cmp-git",
            enabled = function()
              -- Allow git completions in specific filetypes
              if vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype) then
                return true
              end

              -- Otherwise, only allow git completions in comments/strings
              local row, column = unpack(vim.api.nvim_win_get_cursor(0))
              local success, node = pcall(vim.treesitter.get_node, {
                pos = { row - 1, math.max(0, column - 1) },
                ignore_injections = false,
              })
              local accepted_nodes =
                { "comment", "line_comment", "block_comment", "string_start", "string_content", "string_end" }
              if success and node and vim.tbl_contains(accepted_nodes, node:type()) then
                return true
              end

              return false
            end,
            opts = {},
          },
        },
      },
      cmdline = {
        completion = {
          ghost_text = { enabled = true },
          list = {
            selection = {
              preselect = true,
              auto_insert = false,
            },
          },
          menu = { auto_show = true },
        },
      },
      signature = { enabled = true },
    }

    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
  end,
}
