-- Leader (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Unmap leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { remap = false })

vim.keymap.set("n", "<bar>", "<cmd>vsplit<cr>", { desc = "Split window vertically" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { remap = false, desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { remap = false, desc = "Yank line to clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { remap = false, desc = "Paste from clipboard" })
vim.keymap.set("n", "<c-g>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, true, true), "n", true)
  local file = vim.fn.expand "%"
  local line = vim.fn.line "."
  vim.fn.setreg("+", string.format("%s:%d", file, line))
  vim.notify "Copied line reference to clipboard"
end, { remap = false, desc = "Copy line reference to clipboard" })

-- Don't yank when using 'p' in visual mode
vim.keymap.set("v", "p", '"_dP', { remap = false })

-- Window mappings when tmux is not available
if vim.fn.executable "tmux" ~= 1 then
  vim.keymap.set("n", "<c-h>", "<c-w>h", { remap = false, desc = "Move Window: Left" })
  vim.keymap.set("n", "<c-j>", "<c-w>j", { remap = false, desc = "Move Window: Down" })
  vim.keymap.set("n", "<c-k>", "<c-w>k", { remap = false, desc = "Move Window: Up" })
  vim.keymap.set("n", "<c-l>", "<c-w>l", { remap = false, desc = "Move Window: Right" })
end

-- Deal with word wrap
vim.keymap.set("n", "j", function()
  if vim.v.count == 0 then
    return "gj"
  else
    return "j"
  end
end, { expr = true })
vim.keymap.set("n", "k", function()
  if vim.v.count == 0 then
    return "gk"
  else
    return "k"
  end
end, { expr = true })

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move Selection: Down" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move Selection: Up" })

-- Splitjoin the line below the cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Splitjoin" })

-- Justify center page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Justify center search next/prev
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

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

-- Quickfix list remaps
vim.keymap.set("n", "<m-P>", "<cmd>cprev<cr>zz", { desc = "Quickfix: Prev" })
vim.keymap.set("n", "<m-N>", "<cmd>cnext<cr>zz", { desc = "Quickfix: Next" })

-- Replace word under cursor (when LSP is not available)
vim.keymap.set("n", "grn", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Rename" })
vim.keymap.set("v", "grn", [["vy:%s/<C-r>v/<C-r>v/gI<Left><Left><Left>]], { desc = "Rename" })

-- Toggle conceal
vim.keymap.set("n", "<leader>c", function()
  if vim.wo.conceallevel == 0 then
    vim.wo.conceallevel = 2
  else
    vim.wo.conceallevel = 0
  end

  local cloak = require "cloak"
  cloak.toggle()

  local utils = require "utils"
  local conceal_enabled = utils.bool_to_enabled(vim.wo.conceallevel == 2)
  local cloak_enabled = utils.bool_to_enabled(cloak.opts.enabled)

  vim.notify("Conceal " .. conceal_enabled .. ", Cloak " .. cloak_enabled)
end, { desc = "Toggle conceal" })
