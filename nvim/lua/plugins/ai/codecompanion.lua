local cc = require "codecompanion"

cc.setup {
  strategies = {
    chat = {
      adapter = "gemini",
      keymaps = {
        send = {
          modes = { n = "<cr>", i = "<a-cr>" },
          opts = {},
        },
      },
    },
    inline = {
      adapter = "gemini",
      keymaps = {
        accept_change = {
          modes = { n = "<a-y>" },
          description = "Accept the suggested change",
        },
        reject_change = {
          modes = { n = "<a-r>" },
          description = "Reject the suggested change",
        },
      },
    },
    cmd = {
      adapter = "gemini",
    },
  },
  display = {
    action_palette = {
      provider = "snacks",
    },
    chat = {
      intro_message = "  Press ? for options",
    },
    diff = {
      provider = "mini_diff",
    },
    inline = {
      layout = "vertical",
    },
  },
}

vim.keymap.set("n", "<a-c>", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "CodeCompanion: Chat" })
vim.keymap.set("n", "<a-p>", "<cmd>CodeCompanion<cr>", { desc = "CodeCompanion: Prompt" })
vim.keymap.set("v", "<a-p>", ":'<,'>CodeCompanion<cr>", { desc = "CodeCompanion: Prompt" })
vim.keymap.set("n", "<a-P>", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion: Actions" })
vim.keymap.set("n", "<a-C>", ":CodeCompanionCmd ", { desc = "CodeCompanion: Cmd" })

require("plugins.ai.codecompanion.progress_notify").setup()
require("plugins.ai.codecompanion.progress_spinner").setup()
