return {
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
  {
    "bngarren/checkmate.nvim",
    ft = "markdown",
    opts = {
      files = {
        "todo",
        "TODO",
        "todo.md",
        "TODO.md",
        "*.todo",
        "*.todo.md",
      },
      keys = {
        ["<c-space>"] = "toggle",
        ["<leader>Tt"] = "toggle",
        ["<leader>Tc"] = "check",
        ["<leader>Tu"] = "uncheck",
        ["<leader>Tn"] = "create",
        ["<leader>TR"] = "remove_all_metadata",
        ["<leader>Ta"] = "archive",
      },
    },
  },
}
