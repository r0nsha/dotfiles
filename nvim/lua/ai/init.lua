local notify = require("ai.notify")
local spinner = require("ai.spinner")
local utils = require("utils")

local group = vim.api.nvim_create_augroup("AiProgress", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "CodeCompanionRequestStarted" },
  callback = function(args)
    notify.start(args)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "CodeCompanionRequestFinished" },
  callback = function(args)
    notify.stop(args)
  end,
})

local start_spinner = utils.debounce(function()
  vim.schedule(function()
    spinner.start()
  end)
end, 1000)

local stop_spinner = function()
  start_spinner.cancel()
  vim.schedule(function()
    spinner.stop()
  end)
end

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "MinuetRequestStarted" },
  callback = function()
    start_spinner()
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "MinuetRequestFinished" },
  callback = function()
    stop_spinner()
  end,
})
