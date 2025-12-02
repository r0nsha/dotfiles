-- local codelldb_path, liblldb_path = require("utils").get_codelldb_paths()

local servers = {
  lua_ls = { name = "lua-language-server" },
  -- ts_ls = { name = "typescript-language-server" },
  cssls = { name = "css-lsp" },
  tailwindcss = { name = "tailwindcss-language-server" },
  -- biome = {},
  clangd = {},
  rust_analyzer = { name = "rust-analyzer" },
  gopls = {},
  jsonls = { name = "json-lsp" },
  yamlls = { name = "yaml-language-server" },
  basedpyright = {},
  marksman = {},
  tinymist = {},
  astro = { name = "astro-language-server" },
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

  -- dap
  "delve",
  -- "codelldb",

  -- linters
  "eslint_d",
}

-- Add server names from servers with name field
for _, config in pairs(servers) do
  if type(config) == "table" and config.name then
    table.insert(ensure_installed, config.name)
  end
end

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

vim.lsp.enable(vim.tbl_keys(servers))

vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
})

for server, config in pairs(servers) do
  if type(config) == "table" then
    vim.lsp.enable(server, true)
  end
end
