local opts = { remap = false }

-- Leader (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", opts)

-- Unmap arrow keys
vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>", opts)

-- Yank to clipboard
vim.keymap.set("n", "<leader>y", '"+y', opts)

-- Paste from clipboard
vim.keymap.set("n", "<leader>p", '"+p', opts)

-- Window mappings when tmux is not available
if vim.fn.executable "tmux" ~= 1 then
  vim.keymap.set("n", "<c-h>", "<c-w>h", opts)
  vim.keymap.set("n", "<c-j>", "<c-w>j", opts)
  vim.keymap.set("n", "<c-k>", "<c-w>k", opts)
  vim.keymap.set("n", "<c-l>", "<c-w>l", opts)
end

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move visual selection
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

-- splitjoin
vim.keymap.set("n", "J", "mzJ`z")

-- Justify center page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Justify center search next/prev
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Don't put yanked objects when using 'c' or 'C'
vim.keymap.set("n", "c", '"_c', opts)
vim.keymap.set("n", "C", '"_C', opts)

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})
