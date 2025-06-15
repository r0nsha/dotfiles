local dap = require "dap"
local dv = require "dap-view"
local hydra = require "plugins.dap.hydra"

---@type dap.RequestListener
local function enable()
  hydra:activate()
end

---@type dap.RequestListener
local function disable()
  hydra:exit()

  dv.close()
  local bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(bufs) do
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if ft:startswith "dap" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

local name = "dap-view-config"

dap.listeners.before.attach[name] = enable
dap.listeners.before.launch[name] = enable
dap.listeners.after.event_terminated[name] = disable
dap.listeners.after.event_exited[name] = disable
