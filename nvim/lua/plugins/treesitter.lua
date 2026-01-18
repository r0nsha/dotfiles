vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("TreesitterUpdate", { clear = true }),
  once = true,
  callback = function(args)
    if args.data.spec.name == "nvim-treesitter" then require("nvim-treesitter").update() end
  end,
})

local ts = require("nvim-treesitter")

local parsers = {
  "query",
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "rust",
  "go",
  "toml",
  "markdown",
  "markdown_inline",
  "c",
  "cpp",
  "python",
  "html",
  "css",
  "scss",
  "javascript",
  "typescript",
  "tsx",
  "json",
  "yaml",
  "xml",
  "regex",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "make",
  "bash",
  "fish",
  "go",
  "gomod",
  "gowork",
  "diff",
  "http",
  "typst",
  "comment",
  "prisma",
}

ts.install(parsers)

---@param buf number
---@param ft string
local function start_treesitter(buf, ft)
  local lang = vim.treesitter.language.get_lang(ft) or ft

  local ok = pcall(vim.treesitter.start, buf, lang)
  if not ok then return end

  ts.install({ lang })

  vim.bo[buf].syntax = "on"
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

-- Auto-install parsers and enable highlighting for filetypes
local group = vim.api.nvim_create_augroup("TreesitterInstall", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args) start_treesitter(args.buf, args.match) end,
})
vim.api.nvim_create_user_command("TSStart", function() start_treesitter(0, vim.bo.filetype) end, {})

vim.keymap.set("n", "<leader>ih", "<cmd>Inspect<cr>", { desc = "TS: Inspect" })
vim.keymap.set("n", "<leader>ip", "<cmd>InspectTree<cr>", { desc = "TS: Inspect Tree" })
vim.keymap.set("n", "<leader>iq", "<cmd>EditQuery<cr>", { desc = "TS: Edit Query" })

require("treesitter-context").setup({ enable = true, max_lines = 1 })

require("ts_context_commentstring").setup({ enable_autocmd = false })

local get_option = vim.filetype.get_option
---@diagnostic disable-next-line: duplicate-set-field
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
    or get_option(filetype, option)
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("TreeSJSetup", { clear = true }),
  once = true,
  callback = function()
    local treesj = require("treesj")
    treesj.setup({ use_default_keymaps = false, max_join_length = 9000 })
    vim.keymap.set({ "n", "x" }, "gs", treesj.toggle, { desc = "Splitjoin" })
  end,
})
