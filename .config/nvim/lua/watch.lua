local uv = vim.uv

local M = {}

---@class Opts
---@field is_oneshot boolean

---@alias Unwatch fun()
---@alias OnEvent fun(filename: string, events: table, unwatch: Unwatch)
---@alias OnError fun(error: function, unwatch: Unwatch)
---@alias Runnable {on_event: OnEvent, on_error: OnError}

--- @param path string
--- @param on_event function
--- @param on_error OnError
--- @param opts Opts
--- @return uv.uv_fs_event_t|nil
local function _watch(path, on_event, on_error, opts)
  local handle = uv.new_fs_event()
  if not handle then return nil end

  local unwatch_cb = function() uv.fs_event_stop(handle) end

  local event_cb = function(err, filename, events)
    if err then
      on_error(error, unwatch_cb)
    else
      on_event(filename, events, unwatch_cb)
    end
    if opts.is_oneshot then unwatch_cb() end
  end

  uv.fs_event_start(handle, path, {}, event_cb)

  return handle
end

--- @param path string
--- @param runnable Runnable
--- @param opts Opts
--- @return uv.uv_fs_event_t|nil
local function do_watch(path, runnable, opts)
  if runnable.on_error == nil then
    runnable.on_error = function(error, _)
      error('watch("' .. path .. '", ...) ' .. "encountered an error: " .. error)
    end
  end

  return _watch(path, runnable.on_event, runnable.on_error, opts)
end

---@param path string
---@param runnable Runnable
---@return uv.uv_fs_event_t|nil
function M.watch(path, runnable)
  return do_watch(path, runnable, {
    is_oneshot = false,
  })
end

---@param handle uv.uv_fs_event_t|nil
---@return integer|nil
function M.unwatch(handle)
  if not handle then return nil end
  local err, _, _ = uv.fs_event_stop(handle)
  return err
end

---@param path string
---@param runnable Runnable
---@return uv.uv_fs_event_t|nil
function M.once(path, runnable) return do_watch(path, runnable, { is_oneshot = true }) end

return M
