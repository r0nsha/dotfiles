local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    javascript = { "oxfmt" },
    javascriptreact = { "oxfmt" },
    typescript = { "oxfmt" },
    typescriptreact = { "oxfmt" },
    json = { "oxfmt" },
    jsonc = { "oxfmt" },
    vue = { "oxfmt" },
    css = { "oxfmt" },
    scss = { "oxfmt" },
    less = { "oxfmt" },
    html = { "oxfmt" },
    graphql = { "oxfmt" },
    handlebars = { "oxfmt" },
    markdown = { "oxfmt" },
    astro = { "oxfmt" },
    c = { "qmkfmt", "clang-format", stop_after_first = true },
    cpp = { "clang-format" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    fish = { "fish_indent" },
    toml = { "taplo" },
    yaml = { "oxfmt", "yamlfmt", stop_after_first = true },
    xml = { "xmlformatter" },
    go = {
      "gofumpt",
      "goimports-reviser",
      "golines",
    },
    typst = { "typstyle" },
    sql = { "sqruff" },
    kdl = { "kdlfmt" },
    ["_"] = { "trim_whitespace" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end

    return {
      lsp_format = "fallback",
      timeout_ms = 2500,
    }
  end,
  formatters = {
    qmkfmt = {
      command = "qmkfmt",
      args = { "$FILENAME" },
      stdin = false,
      condition = function(_, ctx)
        if ctx.filename:find("[qmk_firmware|qmk_userspace]") == nil then return false end

        if ctx.filename:find("[keymap.c]") == nil then return false end

        return true
      end,
    },
  },
})

vim.keymap.set(
  { "n", "x" },
  "<leader>f",
  function() conform.format({ async = true, lsp_format = "fallback" }) end,
  { remap = false, desc = "Conform: Format" }
)

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
