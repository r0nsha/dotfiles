return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      chat = {
        keymaps = {
          send = { modes = { n = "<cr>", i = "<a-cr>" }, opts = {} },
        },
      },
      inline = {
        keymaps = {
          accept_change = { modes = { n = "<a-y>" }, description = "Accept the suggested change" },
          reject_change = { modes = { n = "<a-r>" }, description = "Reject the suggested change" },
        },
      },
    },
    display = {
      action_palette = {
        provider = "snacks",
      },
      chat = {
        intro_message = "  Press ? for options",
      },
      inline = {
        layout = "vertical",
      },
    },
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionAdd",
  },
  keys = {
    { "<leader>aa", ":CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Chat" },
    { "<leader>ai", ":CodeCompanion<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Prompt" },
    { "<leader>ad", ":CodeCompanion /doc<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Docs" },
    { "<leader>ar", ":CodeCompanion /refactor<cr>", mode = { "v" }, desc = "CodeCompanion: Refactor" },
    { "<leader>ao", ":CodeCompanion /optimize<cr>", mode = { "v" }, desc = "CodeCompanion: Optimize" },
    { "<leader>af", ":CodeCompanion /fix<cr>", mode = { "v" }, desc = "CodeCompanion: Fix" },
    {
      "<leader>ac",
      ":CodeCompanion /commit_staged<cr>",
      mode = { "n", "v" },
      desc = "CodeCompanion: Commit",
      ft = { "gitcommit" },
    },
    { "<leader>as", ":CodeCompanion /spell<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Spell" },
    { "<leader>at", ":CodeCompanion /tests<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Generate Tests" },
    { "<leader>al", ":CodeCompanion /lsp<cr>", mode = { "n", "v" }, desc = "CodeCompanion: LSP" },
    { "<leader>aA", ":CodeCompanionActions<cr>", mode = { "n" }, desc = "CodeCompanion: Actions" },
    { "<a-a>", ":CodeCompanionChat Add<cr>", mode = { "v" }, desc = "CodeCompanion: Add Context" },
  },
  config = function(_, opts)
    local cc = require "codecompanion"
    cc.setup(opts)

    require("plugins.codecompanion.utils.progress_notify").setup()
    require("plugins.codecompanion.utils.progress_spinner").setup()
  end,
}
