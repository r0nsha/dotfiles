local spinner = require "ai.spinner"
local notify = require "ai.notify"

local state = { minuets = 0, companions = 0 }

local group = vim.api.nvim_create_augroup("AiProgress", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "MinuetRequestStarted" },
  ---@diagnostic disable-next-line: unused-local
  callback = function(args)
    state.minuets = state.minuets + 1
    spinner.start()
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "MinuetRequestFinished" },
  ---@diagnostic disable-next-line: unused-local
  callback = function(args)
    state.minuets = math.max(state.minuets - 1, 0)
    if state.minuets == 0 then
      spinner.stop()
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "CodeCompanionRequestStarted" },
  callback = function(args)
    state.companions = state.companions + 1
    notify.start(args)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "CodeCompanionRequestFinished" },
  callback = function(args)
    state.companions = math.max(state.companions - 1, 0)
    if state.companions == 0 then
      notify.stop(args)
    end
  end,
})
