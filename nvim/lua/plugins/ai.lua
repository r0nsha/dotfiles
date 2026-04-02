local _99 = require("99")
_99.setup({
  completion = { source = "blink", custom_rules = {} },
  logger = {
    level = _99.DEBUG,
    path = "/tmp/" .. vim.fs.basename(vim.uv.cwd()) .. ".99.debug",
    print_on_error = true,
  },
  md_files = { "AGENT.md", "CLAUDE.md" },
  model = "anthropic/claude-sonnet-4-6",
  tmp_dir = "./tmp",
})

vim.keymap.set("n", "<A-t>", function() _99.tutorial({}) end, { desc = "99 tutorial" })
vim.keymap.set("v", "<A-v>", function() _99.visual({}) end, { desc = "99 visual" })
vim.keymap.set("n", "<A-f>", function() _99.search({}) end, { desc = "99 search" })
vim.keymap.set("n", "<A-x>", function() _99.stop_all_requests() end, { desc = "99 cancel all requests" })
vim.keymap.set("n", "<A-o>", function() _99.open() end, { desc = "99 open last result" })

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
    show_on_completion_menu = false,
  },
})
