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

dap.listeners.before.attach["dap-view-config"] = enable
dap.listeners.before.launch["dap-view-config"] = enable
dap.listeners.after.event_terminated["dap-view-config"] = disable
dap.listeners.after.event_exited["dap-view-config"] = disable
