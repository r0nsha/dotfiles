local dap = require "dap"
local dv = require "dap-view"
local hydra = require "plugins.dap.hydra"

local function exit_hydra()
  if hydra.layer then
    hydra.layer:exit()
  else
    hydra:exit()
  end
end

---@type dap.RequestListener
local function enable()
  hydra:activate()
end

---@type dap.RequestListener
local function disable()
  exit_hydra()
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
      exit_hydra()
    else
      hydra:activate()
    end
  end,
})
