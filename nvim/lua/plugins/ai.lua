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

vim.g.opencode_opts = {
  auto_reload = true,
  provider = { enabled = "tmux" },
}

-- Required for `vim.g.opencode_opts.auto_reload`.
vim.o.autoread = true

local opencode = require("opencode")

vim.keymap.set(
  { "n", "x" },
  "ga",
  function() opencode.ask("@this: ", { submit = true }) end,
  { desc = "Opencode: Prompt about this" }
)

vim.keymap.set({ "n", "x" }, "gA", function() opencode.ask("", { submit = true }) end, { desc = "Opencode: Prompt" })

vim.keymap.set({ "n", "x" }, "gs", function() opencode.select() end, { desc = "Opencode: Select prompt" })

vim.keymap.set({ "n", "x" }, "g.", function() opencode.prompt("@this") end, { desc = "Opencode: Add this" })
