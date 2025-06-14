local dap = require "dap"
local dv = require "dap-view"

dap.set_log_level "INFO"

dap.listeners.before.attach["dap-view-config"] = dv.open
dap.listeners.before.launch["dap-view-config"] = dv.open
dap.listeners.after.event_terminated["dap-view-config"] = dv.close
dap.listeners.after.event_exited["dap-view-config"] = dv.close

require("persistent-breakpoints").setup {
  load_breakpoints_event = { "BufReadPost" },
}

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticError", linehl = "DapStoppedLine" })
