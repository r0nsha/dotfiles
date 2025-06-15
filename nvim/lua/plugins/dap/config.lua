local dap = require "dap"
dap.set_log_level "INFO"

require("persistent-breakpoints").setup {
  load_breakpoints_event = { "BufReadPost" },
}

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticError", linehl = "DapStoppedLine" })
