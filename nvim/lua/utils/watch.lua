local uv = vim.loop

local M = {}

---@class Opts
---@field is_oneshot boolean

---@alias Unwatch fun()
---@alias OnEvent fun(filename: string, events: table, unwatch: Unwatch)
---@alias OnError fun(error: function, unwatch: Unwatch)
---@alias Runnable string|{on_event: OnEvent, on_error: OnError}

---@param path string
---@param runnable Runnable
---@return OnError
local make_default_error_cb = function(path, runnable)
  return function(error, _)
    error("fwatch.watch(" .. path .. ", " .. runnable .. ")" .. "encountered an error: " .. error)
  end
end

--- @param path string
--- @param on_event function
--- @param on_error OnError
--- @param opts Opts
--- @return userdata
local function watch_with_function(path, on_event, on_error, opts)
  local handle = uv.new_fs_event()

  local unwatch_cb = function()
    uv.fs_event_stop(handle)
  end

  local event_cb = function(err, filename, events)
    if err then
      on_error(error, unwatch_cb)
    else
      on_event(filename, events, unwatch_cb)
    end
    if opts.is_oneshot then
      unwatch_cb()
    end
  end

  uv.fs_event_start(handle, path, {}, event_cb)

  return handle
end

--- @param path string
--- @param string string
--- @param opts Opts
--- @return userdata
local function watch_with_string(path, string, opts)
  local on_event = function(_, _)
    vim.schedule(function()
      vim.cmd(string)
    end)
  end
  local on_error = make_default_error_cb(path, string)
  return watch_with_function(path, on_event, on_error, opts)
end

--- @param path string
--- @param runnable Runnable
--- @param opts Opts
--- @return userdata
local function do_watch(path, runnable, opts)
  if type(runnable) == "string" then
    return watch_with_string(path, runnable, opts)
  elseif type(runnable) == "table" then
    assert(runnable.on_event, "must provide on_event to watch")
    assert(type(runnable.on_event) == "function", "on_event must be a function")

    if runnable.on_error == nil then
      table.on_error = make_default_error_cb(path, "on_event_cb")
    end

    return watch_with_function(path, runnable.on_event, runnable.on_error, opts)
  else
    error("Unknown runnable type given to watch," .. " must be string or {on_event = function, on_error = function}.")
  end
end

---@param path string
---@param runnable Runnable
---@return userdata
function M.watch(path, runnable)
  return do_watch(path, runnable, {
    is_oneshot = false,
  })
end

---@param handle userdata
---@return integer
function M.unwatch(handle)
  return uv.fs_event_stop(handle)
end

---@param path string
---@param runnable Runnable
---@return userdata
function M.once(path, runnable)
  return do_watch(path, runnable, {
    is_oneshot = true,
  })
end

return M
