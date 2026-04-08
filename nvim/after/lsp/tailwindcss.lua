local util = require("lspconfig.util")

local root_files = {
  "tailwind.config.js",
  "tailwind.config.cjs",
  "tailwind.config.mjs",
  "tailwind.config.ts",
  "postcss.config.js",
  "postcss.config.cjs",
  "postcss.config.mjs",
  "postcss.config.ts",
  "theme/static_src/tailwind.config.js",
  "theme/static_src/tailwind.config.cjs",
  "theme/static_src/tailwind.config.mjs",
  "theme/static_src/tailwind.config.ts",
  "theme/static_src/postcss.config.js",
}

---@type vim.lsp.Config
return {
  before_init = function(_, config)
    config.settings = config.settings or {}
    config.settings.editor = config.settings.editor or {}

    if not config.settings.editor.tabSize then config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop() end

    -- Avoid the upstream repo-wide CSS scan, which can block large TS workspaces.
    config.settings.tailwindCSS = config.settings.tailwindCSS or {}
    config.settings.tailwindCSS.experimental = config.settings.tailwindCSS.experimental or {}
  end,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local markers = util.insert_package_json(vim.deepcopy(root_files), "tailwindcss", fname)
    local root = vim.fs.find(markers, { path = fname, upward = true })[1]

    if root then on_dir(vim.fs.dirname(root)) end
  end,
}
