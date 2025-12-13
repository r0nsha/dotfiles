-- Leader (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Unmap leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { remap = false })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { remap = false, desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { remap = false, desc = "Paste from clipboard" })
vim.keymap.set("n", "<c-g>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, true, true), "n", true)
  local file = require("plenary.path"):new(vim.fn.expand "%"):normalize()
  local line = vim.fn.line "."
  local ref = string.format("%s:%d", file, line)
  vim.fn.setreg("+", ref)
  vim.fn.setreg('"', ref)
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
vim.keymap.set({ "n", "x" }, "j", function()
  if vim.v.count == 0 then
    return "gj"
  else
    return "j"
  end
end, { expr = true })
vim.keymap.set({ "n", "x" }, "k", function()
  if vim.v.count == 0 then
    return "gk"
  else
    return "k"
  end
end, { expr = true })

-- replaced with mini.move
-- vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move Selection: Down" })
-- vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move Selection: Up" })

-- Splitjoin the line below the cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Splitjoin" })

-- Justify center page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Justify center search next/prev
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Stay in visual mode when indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Quickfix list remaps
vim.keymap.set("n", "<leader>q", "<cmd>copen<cr>", { desc = "Toggle quickfix" })
vim.keymap.set("n", "<a-n>", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<a-p>", "<cmd>cprev<cr>zz", { desc = "Previous quickfix item" })

-- Replace word under cursor (when LSP is not available)
vim.keymap.set("n", "grn", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Rename" })
vim.keymap.set("v", "grn", [["vy:%s/<C-r>v/<C-r>v/gI<Left><Left><Left>]], { desc = "Rename" })

-- Toggle conceal
vim.keymap.set("n", "<leader>cl", function()
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

-- Working with tabs
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<cr>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprev<cr>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- Trim whitespace
vim.keymap.set("n", "<leader>T", [[%s/\s\+$//e]], { desc = "Trim all whitespace" })

-- Remap inc/dec
vim.keymap.set("n", "+", "<c-a>", { desc = "Increment" })
vim.keymap.set("n", "-", "<c-x>", { desc = "Decrement" })
vim.keymap.set("v", "+", "<c-a>gv=gv", { desc = "Increment" })
vim.keymap.set("v", "-", "<c-x>gv=gv", { desc = "Decrement" })

-- Select entire buffer
vim.keymap.set("v", "v", "<esc>ggVG", { desc = "Select all" })

-- Easier to type toggle fold
vim.keymap.set("n", "zt", "za", { desc = "Toggle fold under cursor" })
vim.keymap.set("n", "zT", "za", { desc = "Toggle all folds under cursor" })

-- Spell
vim.keymap.set("n", "<leader>cc", "1z=", { desc = "Correct spelling" })

-- Terminal
vim.keymap.set("t", "<c-w>n", "<c-\\><c-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

-- Write
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
vim.keymap.set("n", "<leader>W", "<cmd>noau w<cr>", { desc = "Write without formatting" })

-- Jump to start and end of line using home row keys
vim.keymap.set("n", "H", "^", { desc = "Jump to start of line" })
vim.keymap.set("n", "L", "$", { desc = "Jump to end of line" })
