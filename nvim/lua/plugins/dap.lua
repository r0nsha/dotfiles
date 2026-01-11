local dap = require("dap")
dap.set_log_level("INFO")

local dv = require("dap-view")
dv.setup({
  winbar = {
    controls = {
      enabled = true,
      position = "right",
    },
  },
  windows = {
    height = 12,
    position = "below",
    terminal = {
      position = "right",
      width = 0.25,
      start_hidden = true,
    },
  },
})

require("nvim-dap-virtual-text").setup({
  virt_text_pos = "",
})

require("persistent-breakpoints").setup({
  load_breakpoints_event = { "BufReadPost" },
})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticError", linehl = "DapStoppedLine" })

require("plugins.dap.adapters")

local mode = require("plugins.dap.mode")

-- Keymaps to start debugging
vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "Debug: Start" })
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run last" })
vim.keymap.set("n", "<leader>dm", function() mode:activate() end, { desc = "Debug: Toggle mode", nowait = true })
vim.keymap.set(
  "n",
  "<leader>dv",
  function() require("osv").launch({ port = 8086 }) end,
  { desc = "Debug: Start OSV server" }
)

---@type dap.RequestListener
local function enable() mode:activate() end

---@type dap.RequestListener
local function disable()
  mode:exit_mode()
  dv.close(true)
end

local name = "dap-mode-config"

dap.listeners.before.attach[name] = enable
dap.listeners.before.launch[name] = enable
dap.listeners.after.event_terminated[name] = disable
dap.listeners.after.event_exited[name] = disable

-- vim.api.nvim_create_autocmd("BufEnter", {
--   group = vim.api.nvim_create_augroup("CustomDebugModeFT", { clear = true }),
--   pattern = "*",
--   callback = function()
--     if not dap.session() then return end
--
--     ---@diagnostic disable-next-line: param-type-mismatch
--     if vim.bo.filetype:startswith("dap-") then
--       mode:exit_mode()
--     else
--       mode:activate()
--     end
--   end,
-- })
