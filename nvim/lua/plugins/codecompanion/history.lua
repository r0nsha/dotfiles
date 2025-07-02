return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "ravitemer/codecompanion-history.nvim",
  },
  opts = {
    extensions = {
      history = {
        enabled = true,
        opts = {
          keymap = "gh",
          save_chat_keymap = "gS",
          auto_generate_title = false,
          continue_last_chat = false,
          delete_on_clearing_chat = false,
          picker = "snacks",
          enable_logging = false,
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          auto_save = true,
        },
      },
    },
  },
}
