local ts = require("nvim-treesitter")

vim.api.nvim_create_autocmd("PackChanged", {
  group = require("augroup"),
  once = true,
  callback = function(args)
    if args.data.spec.name == "nvim-treesitter" then ts.update() end
  end,
})

local parsers = {
  "query",
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "rust",
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
  "ron",
  "kdl",
}

ts.install(parsers)

---@type string[]
local langs_need_syntax = { "jsx", "tsx" }

---@param buf number
---@param lang string
local function start_treesitter(buf, lang)
  if not vim.treesitter.language.add(lang) then return end

  vim.treesitter.start(buf, lang)
  if vim.tbl_contains(langs_need_syntax, lang) then vim.bo[buf].syntax = "on" end

  if vim.treesitter.query.get(lang, "idnents") then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local available_parsers = ts.get_available()

-- Auto-install parsers and enable highlighting for filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = require("augroup"),
  callback = function(args)
    local buf, ft = args.buf, args.match
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then return end

    local installed_parsers = ts.get_installed("parsers")

    if vim.tbl_contains(installed_parsers, lang) then
      start_treesitter(buf, lang)
    elseif vim.tbl_contains(available_parsers, lang) then
      ts.install(lang):await(function() start_treesitter(buf, lang) end)
    end
  end,
})
vim.api.nvim_create_user_command("TSStart", function() start_treesitter(0, vim.bo.filetype) end, {})

vim.keymap.set("n", "<leader>ih", "<cmd>Inspect<cr>", { desc = "TS: Inspect" })
vim.keymap.set("n", "<leader>ip", "<cmd>InspectTree<cr>", { desc = "TS: Inspect Tree" })
vim.keymap.set("n", "<leader>iq", "<cmd>EditQuery<cr>", { desc = "TS: Edit Query" })

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = require("augroup"),
  once = true,
  callback = function()
    local treesj = require("treesj")
    treesj.setup({ use_default_keymaps = false, max_join_length = 9000 })
    vim.keymap.set({ "n", "x" }, "gs", treesj.toggle, { desc = "Splitjoin" })
  end,
})
