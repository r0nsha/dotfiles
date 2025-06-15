local dap = require "dap"
local dv = require "dap-view"
local hydra = require "plugins.dap.hydra"

local function enable()
  hydra:activate()
end

local function disable()
  dv.close()
  hydra:exit()
end

local name = "dap-view-config"

dap.listeners.before.attach[name] = enable
dap.listeners.before.launch[name] = enable
dap.listeners.after.event_terminated[name] = disable
dap.listeners.after.event_exited[name] = disable
