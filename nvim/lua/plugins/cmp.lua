local blink = require("blink.cmp")

---@type blink.cmp.KeymapConfig
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
    nerd_font_variant = "normal",
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 100,
    },
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
    menu = {
      auto_show = function(ctx) return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype()) end,
      draw = {
        -- We don't need label_description now because label and label_description are already
        -- combined together in label by colorful-menu.nvim.
        columns = {
          { "kind_icon" },
          { "label", gap = 1 },
        },
        components = {
          label = {
            text = function(ctx) return require("colorful-menu").blink_components_text(ctx) end,
            highlight = function(ctx) return require("colorful-menu").blink_components_highlight(ctx) end,
          },
        },
      },
    },
    ghost_text = { enabled = false },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
    prebuilt_binaries = {
      download = true,
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
    default = {
      "lazydev",
      "dadbod",
      "lsp",
      "snippets",
      "path",
      "buffer",
    },
    per_filetype = {
      codecompanion = { "codecompanion" },
    },
    providers = {
      lazydev = {
        name = "lazydev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
      dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
      lsp = {
        -- always show `buffer` source
        fallbacks = {},
      },
      path = {
        opts = {
          show_hidden_files_by_default = true,
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
