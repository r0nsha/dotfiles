require("minuet").setup({
  provider = "codestral",
  provider_options = {
    codestral = {
      optional = {
        max_tokens = 256,
        stop = { "\n\n" },
      },
    },
  },
  virtualtext = {
    auto_trigger_ft = { "*" },
    auto_trigger_ignore_ft = {
      "snacks_input",
      "snacks_picker_input",
      "mini_*",
      "lazy",
      "mason",
      "help",
      "lspinfo",
      "TelescopePrompt",
      "TelescopeResults",
      "neo-tree",
      "dashboard",
      "neo-tree-popup",
      "notify",
      "gitrebase",
    },
    keymap = {
      accept = "<A-y>",
      accept_line = nil,
      accept_n_lines = nil,
      prev = "<A-p>",
      next = "<A-n>",
      dismiss = "<A-r>",
    },
    show_on_completion_menu = true,
  },
  cmp = { enable_auto_complete = false },
  blink = { enable_auto_complete = false },
})
