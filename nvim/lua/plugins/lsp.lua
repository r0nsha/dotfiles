local utils = require("utils")

-- servers
local servers = {
  lua_ls = { name = "lua-language-server" },
  tsgo = {},
  cssls = { name = "css-lsp" },
  tailwindcss = { name = "tailwindcss-language-server" },
  clangd = {},
  rust_analyzer = { name = "rust-analyzer" },
  gopls = {},
  jsonls = { name = "json-lsp" },
  yamlls = { name = "yaml-language-server" },
  taplo = {},
  marksman = {},
  tinymist = {},
  mdx_analyzer = { name = "mdx-analyzer" },
  bashls = { name = "bash-language-server" },
  fish_lsp = { name = "fish-lsp" },
  terraformls = { name = "terraform-ls" },
  dockerls = { name = "docker-language-server" },
  sqls = {},
  helm_ls = { name = "helm-ls" },
}

require("mason").setup()

local ensure_installed = {
  -- formatters
  "prettierd",
  "taplo",
  "stylua",
  "shfmt",
  "xmlformatter",
  "clang-format",
  "yamlfmt",
  "gofumpt",
  "goimports",
  "goimports-reviser",
  "golines",
  "ruff",
  "typstyle",
  "sqruff",
  "kdlfmt",

  -- dap
  "js-debug-adapter",
  "codelldb",

  -- linters
  "eslint_d",
}

for name, config in pairs(servers) do
  ---@type string
  local server_name
  if type(config) == "table" and config.name then
    server_name = config.name
  else
    server_name = name
  end
  table.insert(ensure_installed, server_name)
end

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

vim.lsp.enable(vim.tbl_keys(servers))

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or "done" } }, false, {
      id = "lsp." .. ev.data.params.token,
      kind = "progress",
      source = "vim.lsp",
      title = value.title,
      status = value.kind ~= "end" and "running" or "success",
      percent = value.percentage,
    })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(args)
    local buf = args.buf
    local id = vim.tbl_get(args, "data", "client_id")
    local client = id and vim.lsp.get_client_by_id(id)

    if client == nil then return end

    vim.lsp.inlay_hint.enable(false, { bufnr = buf })
    vim.lsp.codelens.enable(false, { bufnr = buf })

    ---@param desc string
    local opts = function(desc) return { buffer = buf, desc = "LSP: " .. desc } end

    vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, opts("Go to Definition"))
    vim.keymap.set("n", "<c-w>gd", function()
      vim.cmd("vsplit")
      vim.lsp.buf.definition()
    end, opts("Go to Definition (split)"))
    vim.keymap.set("n", "grd", Snacks.picker.lsp_declarations, opts("Declarations"))
    vim.keymap.set("n", "grr", Snacks.picker.lsp_references, opts("References"))
    vim.keymap.set("n", "grt", Snacks.picker.lsp_type_definitions, opts("Type Definitions"))
    vim.keymap.set("n", "gri", Snacks.picker.lsp_implementations, opts("Implementations"))
    vim.keymap.set("n", "grs", Snacks.picker.lsp_workspace_symbols, opts("Workspace Symbols"))
    vim.keymap.set("n", "grS", Snacks.picker.lsp_symbols, opts("Symbols"))
    vim.keymap.set(
      "n",
      "grm",
      function()
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" }, diagnostics = {} },
          apply = true,
        })
      end,
      opts("Organize Imports")
    )
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts("Rename"))
    vim.keymap.set("n", "grA", vim.lsp.codelens.run, opts("Rename"))
    vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action, opts("Code Action"))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))

    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts("Signature Help"))
  end,
})

vim.keymap.set("n", "grh", function()
  local enable = not vim.lsp.inlay_hint.is_enabled()
  vim.lsp.inlay_hint.enable(enable)
  vim.notify("Inlay hints " .. utils.bool_to_enabled(enable))
end, { desc = "LSP: Toggle Inlay Hints" })

vim.keymap.set("n", "grc", function()
  local enable = not vim.lsp.codelens.is_enabled()
  vim.lsp.codelens.enable(enable)
  vim.notify("CodeLens " .. utils.bool_to_enabled(enable))
end, { desc = "LSP: Toggle CodeLens" })

-- diagnostic

local icons = require("config.icons")

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = icons.hint,
      [vim.diagnostic.severity.INFO] = icons.info,
      [vim.diagnostic.severity.WARN] = icons.warning,
      [vim.diagnostic.severity.ERROR] = icons.error,
    },
  },
})

require("tiny-inline-diagnostic").setup({
  preset = "minimal",
  transparent_bg = true,
  transparent_cursorline = false,
  options = {
    show_source = { enabled = true },
    use_icons_from_diagnostic = false,
    multilines = {
      enabled = true,
      always_show = false,
      trim_whitespaces = true,
    },
    show_all_diags_on_cursorline = false,
  },
})

local qf_severity = {
  E = vim.diagnostic.severity.ERROR,
  W = vim.diagnostic.severity.WARN,
  I = vim.diagnostic.severity.INFO,
  H = vim.diagnostic.severity.HINT,
}

local function set_sorted_qflist(opts)
  opts = vim.tbl_extend("force", { open = false }, opts or {})
  local diagnostics = vim.diagnostic.get(nil, opts)
  local items = vim.diagnostic.toqflist(diagnostics)
  table.sort(
    items,
    function(a, b) return (qf_severity[a.type] or math.huge) < (qf_severity[b.type] or math.huge) end
  )
  vim.fn.setqflist({}, " ", { items = items, title = "Diagnostics" })
  vim.cmd.copen()
end

vim.keymap.set("n", "grq", set_sorted_qflist, { desc = "Show Diagnostics" })
vim.keymap.set("n", "grQ", function()
  vim.ui.select(
    { "Error", "Warn", "Info", "Hint" },
    { prompt = "Select minimum severity" },
    ---@param severity string?
    function(severity)
      if not severity then return end
      set_sorted_qflist({
        severity = {
          min = vim.diagnostic.severity[severity:upper()],
          max = vim.diagnostic.severity.ERROR,
        },
      })
    end
  )
end, { desc = "Show Diagnostics (Filtered)" })
vim.keymap.set("n", "gre", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })

-- local icons = require("config.icons")

-- vim.diagnostic.config({
--   virtual_text = { current_line = true },
--   virtual_lines = false,
--   signs = {
--     text = {
--       [vim.diagnostic.severity.HINT] = icons.hint,
--       [vim.diagnostic.severity.INFO] = icons.info,
--       [vim.diagnostic.severity.WARN] = icons.warning,
--       [vim.diagnostic.severity.ERROR] = icons.error,
--     },
--   },
-- })

-- local function enable_virtual_lines()
--   vim.notify("Virtual lines enabled")
--   vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
-- end

-- local function disable_virtual_lines()
--   vim.notify("Virtual lines disabled")
--   vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })
-- end

-- vim.keymap.set("n", "grl", function()
--   local config = vim.diagnostic.config() or {}
--   if config.virtual_lines then
--     disable_virtual_lines()
--   else
--     enable_virtual_lines()
--   end
-- end, { desc = "LSP: Toggle line diagnostics" })

-- vim.api.nvim_create_autocmd("User", {
--   group = require("augroup"),
--   pattern = "DiagnosticChanged",
--   callback = function()
--     if vim.diagnostic.count() == 0 then disable_virtual_lines() end
--   end,
-- })
