local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.hl.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Reload kitty.conf when it's modified
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  pattern = "*/kitty/*.conf",
  callback = function()
    local Job = require("plenary.job")
    local utils = require("utils")

    local pgrep = utils.is_macos() and "pgrep -a kitty" or "pgrep kitty"

    local reload_kitty_cfg = Job:new({
      command = "fish",
      args = { "-c", "kill -SIGUSR1 (" .. pgrep .. ")" },
    })

    local notify = vim.schedule_wrap(vim.notify)

    reload_kitty_cfg:after_success(function()
      notify("Reloaded kitty.conf")
    end)

    reload_kitty_cfg:after_failure(function()
      notify("Failed to reload kitty.conf")
    end)

    reload_kitty_cfg:start()
  end,
})

-- Remove `o` from formatoptions when entering a buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = augroup,
  pattern = "*",
  callback = function()
    -- Don't have `o` add a comment
    vim.opt.formatoptions:remove("o")
  end,
})

-- Automatically remove hlsearch when moving the cursor
vim.api.nvim_create_autocmd("CursorMoved", {
  group = augroup,
  callback = function()
    if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
      vim.schedule(function()
        vim.cmd.nohlsearch()
      end)
    end
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 and not dir:startswith("oil:/") then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = "*/git/config",
  callback = function()
    vim.bo.filetype = "gitconfig"
  end,
})

-- Set relativenumber when in normal mode, but not in insert mode
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = augroup,
  pattern = "*",
  command = "if &nu && mode() != 'i' | set rnu | endif",
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = augroup,
  pattern = "*",
  command = "if &nu | set nornu | endif",
})

-- -- Enable spell when editing prose
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup,
--   pattern = {
--     "text",
--     "plaintext",
--     "tex",
--     "plaintex",
--     "markdown",
--     "typst",
--     "lex",
--     "latex",
--     "gitcommit",
--     "gitrebase",
--     "gitconfig",
--     "mail",
--   },
--   callback = function()
--     vim.opt.spell = true
--     vim.opt.spelloptions = { "camel" }
--     vim.opt.spellsuggest = "best"
--   end,
-- })
