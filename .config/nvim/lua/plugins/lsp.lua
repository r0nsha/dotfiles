local utils = require("utils")

-- servers
local servers = {
  emmylua_ls = {},
  tsc = {},
  cssls = { name = "css-lsp" },
  tailwindcss = { name = "tailwindcss-language-server" },
  clangd = {},
  rust_analyzer = { name = "rust-analyzer" },
  gopls = {},
  jsonls = { name = "json-lsp" },
  yamlls = { name = "yaml-language-server" },
  taplo = {},
  tinymist = {},
  markdown_oxide = { name = "markdown-oxide" },
  bashls = { name = "bash-language-server" },
  fish_lsp = { name = "fish-lsp" },
  sqls = {},
  basedpyright = {},
  zls = {},
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

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
    vim.keymap.set("n", "<c-w>gd", function()
      vim.cmd("vsplit")
      vim.lsp.buf.definition()
    end, opts("Go to definition (split)"))
    vim.keymap.set("n", "grd", vim.lsp.buf.declaration, opts("Declarations"))
    vim.keymap.set("n", "grr", vim.lsp.buf.references, opts("References"))
    vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, opts("Type definitions"))
    vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts("Implementations"))
    vim.keymap.set("n", "grs", vim.lsp.buf.workspace_symbol, opts("Workspace symbols"))
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
      opts("Organize imports")
    )
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts("Rename"))
    vim.keymap.set("n", "grA", vim.lsp.codelens.run, opts("Rename"))
    vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action, opts("Code action"))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))

    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts("Signature help"))
  end,
})

vim.keymap.set("n", "grh", function()
  local enable = not vim.lsp.inlay_hint.is_enabled()
  vim.lsp.inlay_hint.enable(enable)
  vim.notify("Inlay hints " .. utils.bool_to_enabled(enable))
end, { desc = "LSP: Toggle inlay hints" })

vim.keymap.set("n", "grc", function()
  local enable = not vim.lsp.codelens.is_enabled()
  vim.lsp.codelens.enable(enable)
  vim.notify("CodeLens " .. utils.bool_to_enabled(enable))
end, { desc = "LSP: Toggle CodeLens" })
