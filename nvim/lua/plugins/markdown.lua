return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      local peek = require "peek"
      peek.setup {
        filetype = { "markdown", "conf" },
      }

      vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
      vim.api.nvim_create_user_command("PeekClose", peek.close, {})

      vim.keymap.set("n", "gpp", peek.open, { desc = "Peek: Open" })
      vim.keymap.set("n", "gpc", peek.close, { desc = "Peek: Close" })
    end,
  },
  { "jghauser/follow-md-links.nvim", ft = "markdown" },
}
