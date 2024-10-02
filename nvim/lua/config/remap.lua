-- Leader (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Unmap leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { remap = false })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { remap = false, desc = "Yank to clipboard" })
vim.keymap.set("n", "<bar>", "<cmd>vsplit<cr>", { remap = false, desc = "Split window vertically" })

vim.keymap.set("n", "<leader>p", '"+p', { remap = false, desc = "Paste from clipboard" })

-- Window mappings when tmux is not available
if vim.fn.executable "tmux" ~= 1 then
  vim.keymap.set("n", "<c-h>", "<c-w>h", { remap = false, desc = "Move Window: Left" })
  vim.keymap.set("n", "<c-j>", "<c-w>j", { remap = false, desc = "Move Window: Down" })
  vim.keymap.set("n", "<c-k>", "<c-w>k", { remap = false, desc = "Move Window: Up" })
  vim.keymap.set("n", "<c-l>", "<c-w>l", { remap = false, desc = "Move Window: Right" })
end

-- Remap for dealing with word wrap
-- vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { remap = false, desc = "Move Visual Selection: Down" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { remap = false, desc = "Move Visual Selection: Up" })

-- splitjoin
vim.keymap.set("n", "J", "mzJ`z", { remap = false, desc = "Splitjoin" })

-- Justify center page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { remap = false })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { remap = false })

-- Justify center search next/prev
vim.keymap.set("n", "n", "nzzzv", { remap = false })
vim.keymap.set("n", "N", "Nzzzv", { remap = false })

-- Stay in visual mode when indenting
vim.keymap.set("v", "<", "<gv", { remap = false })
vim.keymap.set("v", ">", ">gv", { remap = false })

-- Don't yank when using 'p' in visual mode
vim.keymap.set("v", "p", '"_dP', { remap = false })

-- Don't yank when using 'c' or 'C'
-- vim.keymap.set("n", "c", '"_c', { remap = false })
-- vim.keymap.set("n", "C", '"_C', { remap = false })

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

-- Quickfix list remaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    local init_bufnr = vim.fn.bufnr "#"
    vim.keymap.set("n", "<C-n>", function()
      if vim.fn.line "." == vim.fn.line "$" then
        vim.notify("E553: No more items", vim.log.levels.ERROR)
        return
      end
      vim.cmd "wincmd p" -- jump to current displayed file
      vim.cmd(
        (vim.fn.bufnr "%" ~= init_bufnr and vim.bo.filetype ~= "qf")
            and ("bd | wincmd p | cn | res %d"):format(
              math.floor(
                (vim.o.lines - vim.o.cmdheight - (vim.o.laststatus == 0 and 0 or 1) - (vim.o.tabline == "" and 0 or 1))
                    / 3
                    * 2
                  + 0.5
              ) - 1
            )
          or "cn"
      )
      vim.cmd "normal! zz"
      if vim.bo.filetype ~= "qf" then
        vim.cmd "wincmd p"
      end
    end, opts)

    vim.keymap.set("n", "<C-p>", function()
      if vim.fn.line "." == 1 then
        vim.notify("E553: No more items", vim.log.levels.ERROR)
        return
      end
      vim.cmd "wincmd p" -- jump to current displayed file
      vim.cmd(
        (vim.fn.bufnr "%" ~= init_bufnr and vim.bo.filetype ~= "qf")
            and ("bd | wincmd p | cN | res %d"):format(
              math.floor(
                (vim.o.lines - vim.o.cmdheight - (vim.o.laststatus == 0 and 0 or 1) - (vim.o.tabline == "" and 0 or 1))
                    / 3
                    * 2
                  + 0.5
              ) - 1
            )
          or "cN"
      )
      vim.cmd "normal! zz"
      if vim.bo.filetype ~= "qf" then
        vim.cmd "wincmd p"
      end
    end, opts)
  end,
})
