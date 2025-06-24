local spinner = require "ai.spinner"
local notify = require "ai.notify"

local state = { autocompletions = 0, prompts = 0 }

local group = vim.api.nvim_create_augroup("AiProgress", { clear = true })

-- vim.api.nvim_create_autocmd("User", {
--   group = group,
--   pattern = { "MinuetRequestStarted" },
--   ---@diagnostic disable-next-line: unused-local
--   callback = function(args)
--     state.autocompletions = state.autocompletions + 1
--     spinner.start()
--   end,
-- })

-- vim.api.nvim_create_autocmd("User", {
--   group = group,
--   pattern = { "MinuetRequestFinished" },
--   ---@diagnostic disable-next-line: unused-local
--   callback = function(args)
--     state.autocompletions = math.max(state.autocompletions - 1, 0)
--     if state.autocompletions == 0 then
--       spinner.stop()
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "CodeCompanionRequestStarted" },
  callback = function(args)
    state.prompts = state.prompts + 1
    spinner.start()
    notify.start(args)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "CodeCompanionRequestFinished" },
  callback = function(args)
    state.prompts = math.max(state.prompts - 1, 0)
    if state.prompts == 0 then
      spinner.stop()
      notify.stop(args)
    end
  end,
})
