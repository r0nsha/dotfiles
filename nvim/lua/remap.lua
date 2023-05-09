local opts = { remap = false }

-- Leader (Space)
vim.g.mapleader = " "

vim.keymap.set("n", "<Space>", "<Nop>", opts)

-- Unmap arrow keys
vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>", opts)

-- Unmap visual block in favor of <c-q>
vim.keymap.set("n", "<c-v>", "<Nop>", opts)

-- Yank entire buffer
vim.keymap.set("n", "<leader>y", 'ggVG"+y', opts)

-- Window mappings when tmux is not available
if vim.fn.executable "tmux" ~= 1 then
  vim.keymap.set("n", "<c-h>", "<c-w>h", opts)
  vim.keymap.set("n", "<c-j>", "<c-w>j", opts)
  vim.keymap.set("n", "<c-k>", "<c-w>k", opts)
  vim.keymap.set("n", "<c-l>", "<c-w>l", opts)
end

-- Cancel highlight
vim.keymap.set("n", "/\\", ":noh<cr>", opts)

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
