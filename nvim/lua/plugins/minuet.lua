return {
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  enabled = false,
  opts = {
    -- provider = "gemini",
    provider = "codestral",
    throttle = 1000,
    debounce = 400,
    virtualtext = {
      -- auto_trigger_ft = { "*" },
      -- auto_trigger_ignore_ft = {
      --   "snacks_input",
      --   "snacks_picker_input",
      --   "mini_*",
      --   "lazy",
      --   "mason",
      --   "help",
      --   "lspinfo",
      --   "TelescopePrompt",
      --   "TelescopeResults",
      --   "neo-tree",
      --   "dashboard",
      --   "neo-tree-popup",
      --   "notify",
      --   "gitrebase",
      -- },
      keymap = {
        accept = "<a-y>",
        accept_line = "<a-l>",
        accept_n_lines = "<a-L>",
        prev = "<a-p>",
        next = "<a-n>",
        dismiss = "<a-r>",
      },
      show_on_completion_menu = true,
    },
    cmp = { enable_auto_complete = false },
    blink = { enable_auto_complete = false },
  },
}
