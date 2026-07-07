local augroup = require("augroup")

vim.api.nvim_create_autocmd({ "TextYankPost", "TextPutPost" }, {
  group = augroup,
  desc = "Highlight yank/put",
  pattern = "*",
  callback = function() vim.hl.hl_op({ timeout = 50 }) end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Return to last edit position when opening files",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  desc = "Reload kitty.conf when it's modified",
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

    reload_kitty_cfg:after_success(function() notify("Reloaded kitty.conf") end)

    reload_kitty_cfg:after_failure(function() notify("Failed to reload kitty.conf") end)

    reload_kitty_cfg:start()
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = augroup,
  desc = "Remove `o` from formatoptions when entering a buffer",
  pattern = "*",
  callback = function()
    -- Don't have `o` add a comment
    vim.opt.formatoptions:remove("o")
  end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
  group = augroup,
  desc = "Clear search highlight when moving cursor",
  callback = function()
    if vim.v.hlsearch == 1 then
      local ok, sc = pcall(vim.fn.searchcount)
      if ok and sc.exact_match == 0 then vim.schedule(function() vim.cmd.nohlsearch() end) end
    end
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  desc = "Auto-resize splits when window is resized",
  callback = function() vim.cmd("tabdo wincmd =") end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  desc = "Create directories when saving files",
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 and not dir:startswith("oil:/") then vim.fn.mkdir(dir, "p") end
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  desc = "Set gitconfig filetype",
  pattern = "*/git/config",
  callback = function() vim.bo.filetype = "gitconfig" end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = augroup,
  desc = "Set relativenumber when in normal mode, but not in insert mode",
  pattern = "*",
  command = "if &nu && mode() != 'i' | set rnu | endif",
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = augroup,
  desc = "Disable relativenumber when in insert mode",
  pattern = "*",
  command = "if &nu | set nornu | endif",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  desc = "Enable spell checking for prose",
  pattern = {
    "text",
    "plaintext",
    "tex",
    "plaintex",
    "markdown",
    "typst",
    "lex",
    "latex",
    "mail",
  },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelloptions = { "camel" }
    vim.opt_local.spellsuggest = "best"
  end,
})

vim.api.nvim_create_autocmd("LspProgress", {
  group = augroup,
  command = "redrawstatus",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup,
  desc = "Disable swapfile, backup, and undofile for pass files",
  pattern = { "/dev/shm/pass*", "/private/**/pass**" },
  callback = function()
    vim.opt_local.swapfile = false
    vim.opt_local.backup = false
    vim.opt_local.undofile = false
    vim.opt_local.shada = ""
  end,
})

vim.api.nvim_create_autocmd({ "TermRequest" }, {
  desc = "Handles OSC 7 dir change requests",
  callback = function(ev)
    local val, n = string.gsub(ev.data.sequence, "\027]7;file://[^/]*", "")
    if n > 0 then
      -- OSC 7: dir-change
      local dir = val
      if vim.fn.isdirectory(dir) == 0 then
        vim.notify("invalid dir: " .. dir)
        return
      end
      vim.b[ev.buf].osc7_dir = dir
      -- if vim.api.nvim_get_current_buf() == ev.buf then vim.cmd.lcd(dir) end
    end
  end,
})
