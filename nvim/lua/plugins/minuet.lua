return {
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- provider = "gemini",
    provider = "codestral",
    virtualtext = {
      auto_trigger_ft = {},
      keymap = {
        accept = "<a-y>",
        accept_line = "<a-l>",
        accept_n_lines = "<a-L>",
        prev = "<a-p>",
        next = "<a-n>",
        dismiss = "<a-r>",
      },
    },
  },
}
