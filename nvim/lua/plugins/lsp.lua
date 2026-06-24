local utils = require("utils")

-- servers
local servers = {
  emmylua_ls = {},
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
    local opts = function(desc) return { buf = buf, desc = "LSP: " .. desc } end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to Definition"))
    vim.keymap.set("n", "<c-w>gd", function()
      vim.cmd("vsplit")
      vim.lsp.buf.definition()
    end, opts("Go to Definition (split)"))
    vim.keymap.set("n", "grd", vim.lsp.buf.declaration, opts("Declarations"))
    vim.keymap.set("n", "grr", vim.lsp.buf.references, opts("References"))
    vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, opts("Type Definitions"))
    vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts("Implementations"))
    vim.keymap.set("n", "grs", vim.lsp.buf.workspace_symbol, opts("Workspace Symbols"))
    vim.keymap.set("n", "grS", vim.lsp.buf.document_symbol, opts("Symbols"))
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
vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })

local qf_severity = {
  E = vim.diagnostic.severity.ERROR,
  W = vim.diagnostic.severity.WARN,
  I = vim.diagnostic.severity.INFO,
  H = vim.diagnostic.severity.HINT,
}

---@param opts vim.diagnostic.GetOpts?
local function set_sorted_qflist(opts)
  opts = vim.tbl_extend("force", { open = false }, opts or {})
  local diagnostics = vim.diagnostic.get(nil, opts)
  if #diagnostics == 0 then
    vim.notify("No diagnostics found", vim.log.levels.INFO)
    vim.fn.setqflist({}, " ", { items = {}, title = "Diagnostics" })
    vim.cmd.cclose()
    return
  end
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
    function(severity)
      if not severity then return end
      set_sorted_qflist({
        severity = {
          min = vim.diagnostic.severity[severity:upper()],
          max = vim.diagnostic.severity.ERROR,
        },
      } --[[@as vim.diagnostic.GetOpts]])
    end
  )
end, { desc = "Show Diagnostics (Filtered)" })

---@param enabled boolean
local function enable_virtual_lines(enabled)
  vim.notify("Virtual lines " .. utils.bool_to_enabled(enabled))
  if enabled then
    vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
  else
    vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })
  end
end

vim.keymap.set("n", "grl", function()
  local config = vim.diagnostic.config() or {}
  enable_virtual_lines(not config.virtual_lines)
end, { desc = "LSP: Toggle line diagnostics" })

vim.api.nvim_create_autocmd("User", {
  group = require("augroup"),
  pattern = "DiagnosticChanged",
  callback = function()
    if vim.diagnostic.count() == 0 then enable_virtual_lines(false) end
  end,
})
