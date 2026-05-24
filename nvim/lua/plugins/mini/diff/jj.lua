---@class mini.diff.jj.CacheEntry
---@field fs_event uv.uv_fs_event_t?
---@field timer uv.uv_timer_t?

local CACHE_TIMEOUT = 50

local MiniDiff = require("mini.diff")

---@type table<number, mini.diff.jj.CacheEntry>
local cache = {}

---@param buf_id integer
---@return string
local function buf_path(buf_id) return vim.uv.fs_realpath(vim.api.nvim_buf_get_name(buf_id)) or "" end

---@param cwd string
---@return string?
local function repo_root(cwd)
  local result = vim.system({ "jj", "--ignore-working-copy", "root" }, { cwd = cwd }):wait()
  return result.code == 0 and vim.trim(result.stdout) or nil
end

local function stop_handles(entry)
  if entry.fs_event then entry.fs_event:stop() end
  if entry.timer then entry.timer:stop() end
end

local function invalidate(buf_id)
  local entry = cache[buf_id]
  if entry then
    stop_handles(entry)
    cache[buf_id] = nil
  end
end

---@param buf_id integer
---@param file_path string
---@param cwd string
local function set_ref_text(buf_id, file_path, cwd)
  vim.system(
    { "jj", "file", "show", "-r", "@-", file_path },
    { cwd = cwd, text = true },
    vim.schedule_wrap(function(res)
      if res.code == 0 then
        MiniDiff.set_ref_text(buf_id, res.stdout)
      elseif res.stderr:find("No such path") then
        MiniDiff.set_ref_text(buf_id, "\n")
      else
        MiniDiff.set_ref_text(buf_id, {})
      end
    end)
  )
end

---@param buf_id integer
---@param file_path string
---@return boolean?
local function watch(buf_id, file_path)
  local cwd = vim.fs.dirname(file_path)
  local repo = repo_root(cwd)
  if not repo then return false end

  local watch_path = vim.fs.joinpath(repo, ".jj/working_copy")
  local fs_event = vim.uv.new_fs_event()
  local timer = vim.uv.new_timer()

  local function tick()
    if not timer then return end
    timer:stop()
    timer:start(CACHE_TIMEOUT, 0, function() set_ref_text(buf_id, file_path, cwd) end)
  end

  local function on_change(_, filename)
    if filename == "checkout" and timer then tick() end
  end

  if fs_event then fs_event:start(watch_path, {}, on_change) end

  invalidate(buf_id)
  cache[buf_id] = { fs_event = fs_event, timer = timer }

  set_ref_text(buf_id, file_path, cwd)

  return true
end

---@param buf_id integer
---@return boolean?
local function attach(buf_id)
  if cache[buf_id] then return false end
  local path = buf_path(buf_id)
  if path == "" then return false end
  return watch(buf_id, path)
end

---@param buf_id integer
local function detach(buf_id) invalidate(buf_id) end

return { name = "jj", attach = attach, detach = detach }
