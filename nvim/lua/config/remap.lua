-- Leader (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Unmap leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { remap = false })

vim.keymap.set("n", "<bar>", "<cmd>vsplit<cr>", { remap = false, desc = "Split window vertically" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { remap = false, desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { remap = false, desc = "Paste from clipboard" })

-- Window mappings when tmux is not available
if vim.fn.executable "tmux" ~= 1 then
  vim.keymap.set("n", "<c-h>", "<c-w>h", { remap = false, desc = "Move Window: Left" })
  vim.keymap.set("n", "<c-j>", "<c-w>j", { remap = false, desc = "Move Window: Down" })
  vim.keymap.set("n", "<c-k>", "<c-w>k", { remap = false, desc = "Move Window: Up" })
  vim.keymap.set("n", "<c-l>", "<c-w>l", { remap = false, desc = "Move Window: Right" })
end

-- Deal with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { remap = false, desc = "Move Selection: Down" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { remap = false, desc = "Move Selection: Up" })

-- Splitjoin the line below the cursor
vim.keymap.set("n", "J", "mzJ`z", { remap = false, desc = "Splitjoin" })

-- Justify center page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { remap = false })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { remap = false })

-- Justify center search next/prev
vim.keymap.set("n", "n", "nzzzv", { remap = false })
vim.keymap.set("n", "N", "Nzzzv", { remap = false })

-- Stay in visual mode when indenting
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "norg" then
      return
    end

    vim.keymap.set("v", "<", "<gv", { buffer = true })
    vim.keymap.set("v", ">", ">gv", { buffer = true })
  end,
})

-- Don't yank when using 'p' in visual mode
vim.keymap.set("v", "p", '"_dP', { remap = false })

-- Quickfix list remaps
vim.keymap.set("n", "<A-l>", "<cmd>cprev<cr>", { desc = "Quickfix: Prev" })
vim.keymap.set("n", "<A-h>", "<cmd>cnext<cr>", { desc = "Quickfix: Next" })
