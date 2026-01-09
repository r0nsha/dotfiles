-- Leader (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Unmap leader key
vim.keymap.set({ "n", "x" }, "<Space>", "<Nop>", { remap = false })

vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { remap = false, desc = "Yank to clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>Y", '"+Y', { remap = false, desc = "Yank to clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { remap = false, desc = "Paste from clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>P", '"+P', { remap = false, desc = "Paste from clipboard" })
vim.keymap.set({ "n", "x" }, "gy", '""y', { remap = false, desc = "Yank to unnamed register" })
vim.keymap.set({ "n", "x" }, "gY", '""Y', { remap = false, desc = "Yank to unnamed register" })
vim.keymap.set({ "n", "x" }, "gp", '""p', { remap = false, desc = "Paste from unnamed register" })
vim.keymap.set({ "n", "x" }, "gP", '""P', { remap = false, desc = "Paste from unnamed register" })

-- Don't yank when using 'p' in visual mode
vim.keymap.set("x", "p", '"_dP', { remap = false })

---@param lines string
local function copy_line_reference(lines)
  local file = require("plenary.path"):new(vim.fn.expand "%"):normalize()
  local ref = string.format("%s:%s", file, lines)
  vim.fn.setreg("+", ref)
  vim.fn.setreg('"', ref)
  vim.notify "Yanked line reference"
end

vim.keymap.set("n", "<c-g>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, true, true), "n", true)
  local line = vim.fn.line "."
  copy_line_reference(tostring(line))
end, { remap = false, desc = "Copy line reference to clipboard" })

vim.keymap.set("x", "<c-g>", function()
  local start_line, end_line = require("utils").get_visual_range()
  copy_line_reference(string.format("%d-%d", start_line, end_line))
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
end, { remap = false, desc = "Copy line reference to clipboard" })

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
-- vim.keymap.set("x", "J", ":m '>+1<cr>gv=gv", { desc = "Move Selection: Down" })
-- vim.keymap.set("x", "K", ":m '<-2<cr>gv=gv", { desc = "Move Selection: Up" })

-- Splitjoin the line below the cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Splitjoin" })

-- Justify center page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Justify center search next/prev
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Clear hlsearch
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlight" })

-- Stay in visual mode when indenting
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- Quickfix remaps
vim.keymap.set("n", "<leader>q", "<cmd>copen<cr>", { desc = "Quickfix" })
vim.keymap.set("n", "<A-n>", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<A-p>", "<cmd>cprev<cr>zz", { desc = "Previous quickfix item" })

-- Loclist remaps
vim.keymap.set("n", "<leader>Q", "<cmd>lopen<cr>", { desc = "Loclist" })
vim.keymap.set("n", "<A-N>", "<cmd>lnext<cr>zz", { desc = "Next loclist item" })
vim.keymap.set("n", "<A-P>", "<cmd>lprev<cr>zz", { desc = "Previous loclist item" })

-- Replace word under cursor (when LSP is not available)
vim.keymap.set("n", "grn", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Rename" })
vim.keymap.set("x", "grn", [["vy:%s/<C-r>v/<C-r>v/gI<Left><Left><Left>]], { desc = "Rename" })

-- Toggle conceal
vim.keymap.set("n", "<leader>cl", function()
  if vim.wo.conceallevel == 0 then
    vim.wo.conceallevel = 2
  else
    vim.wo.conceallevel = 0
  end

  local utils = require "utils"
  local conceal_enabled = utils.bool_to_enabled(vim.wo.conceallevel == 2)

  vim.notify("Conceal " .. conceal_enabled)
end, { desc = "Toggle conceal" })

-- Tabs
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
vim.keymap.set("n", "[t", "<cmd>tabprev<cr>", { desc = "Previous tab" })
vim.keymap.set("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab" })

-- Trim whitespace
vim.keymap.set("n", "<leader>T", [[%s/\s\+$//e]], { desc = "Trim all whitespace" })

-- Remap inc/dec
vim.keymap.set("n", "+", "<c-a>", { desc = "Increment" })
vim.keymap.set("n", "-", "<c-x>", { desc = "Decrement" })
vim.keymap.set("x", "+", "<c-a>gv=gv", { desc = "Increment" })
vim.keymap.set("x", "-", "<c-x>gv=gv", { desc = "Decrement" })

-- Select entire buffer
vim.keymap.set("x", "v", "<esc>ggVG", { desc = "Select all" })

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

-- Cmdline remaps
vim.keymap.set("c", "<C-h>", "<Left>", { desc = "Move cursor left", noremap = true })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "Move cursor down", noremap = true })
vim.keymap.set("c", "<C-k>", "<Up>", { desc = "Move cursor up", noremap = true })
vim.keymap.set("c", "<C-l>", "<Right>", { desc = "Move cursor right", noremap = true })
vim.keymap.set("c", "<C-w>", "<S-Right>", { desc = "Next word", noremap = true })
vim.keymap.set("c", "<C-b>", "<S-Left>", { desc = "Previous word", noremap = true })
vim.keymap.set("c", "<C-S-I>", "<C-b>", { desc = "Insert at start", noremap = true })
vim.keymap.set("c", "<C-S-A>", "<C-e>", { desc = "Insert at end", noremap = true })
vim.keymap.set("c", "<C-x>", "<Del>", { desc = "Delete character", noremap = true })
vim.keymap.set("c", "<C-d>", "<C-u>", { desc = "Delete to start", noremap = true })
