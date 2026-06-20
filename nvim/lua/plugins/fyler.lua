---@diagnostic disable: missing-fields
require("fyler").setup({
  auto_confirm_simple_mutation = true,
  use_as_default_explorer = true,
  integrations = {
    icon = "mini_icons",
  },
  mappings = {
    n = {
      ["<C-c>"] = { action = "close" },
    },
  },
  ui = {
    indent_guides = true,
  },
})

vim.keymap.set("n", "<leader>r", function() require("fyler").toggle() end, { desc = "Fyler" })
