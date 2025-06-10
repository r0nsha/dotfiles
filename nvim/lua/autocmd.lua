-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = 40,
    }
  end,
  group = highlight_group,
  pattern = "*",
})

local gitconfig_group = vim.api.nvim_create_augroup("GitConfig", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = gitconfig_group,
  pattern = "*/git/config",
  callback = function()
    vim.cmd "set ft=gitconfig"
  end,
})

-- Reload kitty.conf when it's modified
local kitty_group = vim.api.nvim_create_augroup("KittyConfig", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = kitty_group,
  pattern = "*/kitty/kitty.conf",
  callback = function()
    local Job = require "plenary.job"
    local utils = require "utils"

    local pgrep = utils.is_macos() and "pgrep -a kitty" or "pgrep kitty"

    local reload_kitty_cfg = Job:new {
      command = "fish",
      args = { "-c", "kill -SIGUSR1 (" .. pgrep .. ")" },
    }

    local notify = vim.schedule_wrap(vim.notify)

    reload_kitty_cfg:after_success(function()
      notify "Reloaded kitty.conf"
    end)

    reload_kitty_cfg:after_failure(function()
      notify "Failed to reload kitty.conf"
    end)

    reload_kitty_cfg:start()
  end,
})

local bufenter_group = vim.api.nvim_create_augroup("CustomBufEnter", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = bufenter_group,
  pattern = "*",
  callback = function()
    -- Don't have `o` add a comment
    vim.opt.formatoptions:remove "o"
  end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
  group = vim.api.nvim_create_augroup("auto-hlsearch", { clear = true }),
  callback = function()
    if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
      vim.schedule(function()
        vim.cmd.nohlsearch()
      end)
    end
  end,
})
