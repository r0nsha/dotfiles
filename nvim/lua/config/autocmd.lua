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

    local reload_kitty_cfg = Job:new {
      command = "fish",
      args = { "-c", "kill -SIGUSR1 (pgrep kitty)" },
    }

    local notify = vim.schedule_wrap(vim.notify)

    reload_kitty_cfg:after_success(function()
      notify "Reloaded kitty.conf"
    end)

    reload_kitty_cfg:after_failure(function()
      notify "Failed to reload kitty.conf"
    end)

    reload_kitty_cfg:start()
    -- vim.cmd [[silent !kill -SIGUSR1 (pgrep kitty)]]
  end,
})
