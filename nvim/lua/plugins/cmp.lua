return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  version = "*",
  dependencies = {
    -- snippets
    "rafamadriz/friendly-snippets",
    "echasnovski/mini.snippets",

    -- sources
    "Kaiser-Yang/blink-cmp-git",
    "mgalliou/blink-cmp-tmux",
    "ribru17/blink-cmp-spell",

    -- misc
    "xzbdmw/colorful-menu.nvim",
  },
  config = function()
    local blink = require("blink.cmp")

    local keymaps = {
      prev = {
        "select_prev",
        "show",
        "fallback_to_mappings",
      },

      next = {
        "select_next",
        "show",
        "fallback_to_mappings",
      },

      scroll_documentation_up = { "scroll_documentation_up", "fallback" },
      scroll_documentation_down = { "scroll_documentation_down", "fallback" },

      toggle_signature = { "show_signature", "hide_signature", "fallback" },
    }

    blink.setup({
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = {
              { "kind_icon" },
              { "label", gap = 1 },
            },
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
        ghost_text = { enabled = false },
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
        ["<C-c>"] = { "cancel", "fallback_to_mappings" },
        ["<C-y>"] = { "select_and_accept" },

        ["<C-p>"] = keymaps.prev,
        ["<C-n>"] = keymaps.next,
        ["<Up>"] = keymaps.prev,
        ["<Down>"] = keymaps.next,

        ["<C-b>"] = keymaps.scroll_documentation_up,
        ["<C-f>"] = keymaps.scroll_documentation_down,
        ["<C-u>"] = keymaps.scroll_documentation_up,
        ["<C-d>"] = keymaps.scroll_documentation_down,

        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      },
      snippets = {
        preset = "mini_snippets",
      },
      sources = {
        default = { "lazydev", "lsp", "snippets", "spell", "path", "buffer", "tmux", "git" },
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          lsp = {
            -- always show `buffer` source
            fallbacks = {},
          },
          -- snippets = {
          --   enabled = function()
          --     return not utils.repo_too_large()
          --   end,
          -- },
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
          tmux = {
            module = "blink-cmp-tmux",
            name = "tmux",
            opts = {},
          },
          spell = {
            name = "spell",
            module = "blink-cmp-spell",
            opts = {
              -- EXAMPLE: Only enable source in `@spell` captures, and disable it in `@nospell` captures.
              -- enable_in_context = function()
              --   local curpos = vim.api.nvim_win_get_cursor(0)
              --   local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
              --   local in_spell_capture = false
              --   for _, cap in ipairs(captures) do
              --     if cap.capture == "spell" then
              --       in_spell_capture = true
              --     elseif cap.capture == "nospell" then
              --       return false
              --     end
              --   end
              --   return in_spell_capture
              -- end,
              use_cmp_spell_sorting = true,
            },
          },
        },
      },
      cmdline = {
        keymap = { preset = "cmdline" },
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
    })

    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
  end,
}
