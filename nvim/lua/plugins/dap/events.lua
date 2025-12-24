local dap = require "dap"
local dv = require "dap-view"
local hydra = require "plugins.dap.hydra"

---@type dap.RequestListener
local function enable()
  hydra:activate()
end

---@type dap.RequestListener
local function disable()
  hydra:exit_mode()
  dv.close(true)
end

local name = "dap-view-config"

dap.listeners.before.attach[name] = enable
dap.listeners.before.launch[name] = enable
dap.listeners.after.event_terminated[name] = disable
dap.listeners.after.event_exited[name] = disable

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("CustomHydraFT", { clear = true }),
  pattern = "*",
  callback = function()
    if not dap.session() then
      return
    end

    if vim.bo.filetype:startswith "dap-" then
      hydra:exit_mode()
    else
      hydra:activate()
    end
  end,
})
