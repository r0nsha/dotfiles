local icons = require("config.icons")

local M = {}

local uv = vim.loop

-- active requests
local active = {}

M.config = {
  frames = { "", "", "", "", "", "" },
  speed = 80, -- milliseconds per frame
}

local function spinner_frame()
  local time = math.floor(uv.hrtime() / (1e6 * M.config.speed))
  local idx = time % #M.config.frames + 1
  local frame = M.config.frames[idx]

  return frame
end

local function refresh_notifications(key)
  return function()
    local req = active[key]
    if not req then
      return
    end

    vim.notify(req.msg, vim.log.levels.WARN, {
      id = "cc_progress",
      title = req.adapter,
      opts = function(notif)
        notif.icon = req.done and " " or spinner_frame()
        notif.msg = req.msg
      end,
    })
  end
end

local function request_key(data)
  local adapter = data.adapter or {}
  local name = adapter.formatted_name or adapter.name or "unknown"
  return string.format("%s:%s", name, data.id or "???")
end

---@param args vim.api.keyset.create_autocmd.callback_args
function M.start(args)
  local data = args.data or {}
  local key = request_key(data)
  local adapter = data.adapter and data.adapter.name or "CodeCompanion"
  local refresh = refresh_notifications(key)

  local timer = uv.new_timer()
  local req = {
    adapter = adapter,
    done = false,
    msg = "  Thinking...",
    refresh = refresh,
    timer = timer,
  }

  active[key] = req

  if timer then
    timer:start(0, 150, vim.schedule_wrap(refresh))
  end

  refresh()
end

---@param args vim.api.keyset.create_autocmd.callback_args
function M.stop(args)
  local data = args.data or {}
  local key = request_key(data)
  local req = active[key]

  if not req then
    return
  end

  req.done = true

  local msg = ""
  if data.status == "success" then
    msg = "Done"
  elseif data.status == "error" then
    msg = "Error :("
  else
    msg = "Cancelled"
  end

  req.msg = icons.ai .. "  " .. msg

  req.refresh()

  -- clear the finished request
  active[key] = nil
  if req.timer then
    req.timer:stop()
    req.timer:close()
  end
end

return M
