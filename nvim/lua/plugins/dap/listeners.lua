local dap = require("dap")
local dv = require("dap-view")

local function enable() end

local function disable() end

dap.listeners.before.attach["dap-view-config"] = dv.open
dap.listeners.before.launch["dap-view-config"] = dv.open
dap.listeners.after.event_terminated["dap-view-config"] = dv.close
dap.listeners.after.event_exited["dap-view-config"] = dv.close
