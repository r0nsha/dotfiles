local notify = require("ai.notify")
local spinner = require("ai.spinner")

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

-- vim.api.nvim_create_autocmd("User", {
--   group = group,
--   pattern = { "MinuetRequestStarted" },
--   callback = function()
--     spinner.start()
--   end,
-- })

-- vim.api.nvim_create_autocmd("User", {
--   group = group,
--   pattern = { "MinuetRequestFinished" },
--   callback = function()
--     spinner.stop()
--   end,
-- })
