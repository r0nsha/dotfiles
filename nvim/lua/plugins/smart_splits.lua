---@diagnostic disable-next-line: missing-fields
require("smart-splits").setup({})

-- move
vim.keymap.set(
  { "n", "t" },
  "<C-h>",
  function() require("smart_splits").move_cursor_left() end,
  { desc = "Move cursor left" }
)
vim.keymap.set(
  { "n", "t" },
  "<C-j>",
  function() require("smart_splits").move_cursor_down() end,
  { desc = "Move cursor down" }
)
vim.keymap.set(
  { "n", "t" },
  "<C-k>",
  function() require("smart_splits").move_cursor_up() end,
  { desc = "Move cursor up" }
)
vim.keymap.set(
  { "n", "t" },
  "<C-l>",
  function() require("smart_splits").move_cursor_right() end,
  { desc = "Move cursor right" }
)
vim.keymap.set(
  { "n", "t" },
  "<C-\\>",
  function() require("smart_splits").move_cursor_previous() end,
  { desc = "Move cursor previous" }
)

-- resize
vim.keymap.set({ "n", "t" }, "<A-h>", function() require("smart_splits").resize_left() end, { desc = "Resize left" })
vim.keymap.set({ "n", "t" }, "<A-j>", function() require("smart_splits").resize_down() end, { desc = "Resize down" })
vim.keymap.set({ "n", "t" }, "<A-k>", function() require("smart_splits").resize_up() end, { desc = "Resize up" })
vim.keymap.set({ "n", "t" }, "<A-l>", function() require("smart_splits").resize_right() end, { desc = "Resize right" })
