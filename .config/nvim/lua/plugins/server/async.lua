---AI-generated slop for https://github.com/wurli/servery.nvim/issues/16.
---Not part of servery.nvim; delete this file once the issue is fixed upstream.
---
---Non-blocking replacement for `servery.list_sessions`.
---
---servery's built-in discovery makes blocking, unbounded `vim.rpcrequest()`
---calls to every server (five per server, no timeout) and uses
---`vim.fn.serverlist({ peer = true })`, which also blocks on unresponsive
---peers. A busy / starting / shutting-down session therefore stalls `:Sv`
---for as long as it stays unresponsive.
---
---This reimplements discovery over `vim.uv` pipes + `vim.mpack`: all sessions
---are probed concurrently with a timeout, results are cached, and we never
---wait more than `PROBE_WAIT` ms. `M.install()` swaps it in as
---`servery.list_sessions` and as the `servers` enumerator.
local M = {}

local Session = require("servery.session")

---@class servery_async.ServerInfo
---@field socket string
---@field pid integer?
---@field original_cwd string?
---@field useractive integer?
---@field starttime integer?

-- ---------------------------------------------------------------------------
-- Non-blocking msgpack-rpc (one request per socket)
-- ---------------------------------------------------------------------------

---@param addr string
---@param method string
---@param params any[]
---@param timeout integer  milliseconds
---@param cb fun(err: string?, result: any)
local function request(addr, method, params, timeout, cb)
  local pipe = vim.uv.new_pipe(false)
  local timer = vim.uv.new_timer()
  local chunks = {}
  local done = false

  local function finish(err, result)
    if done then return end
    done = true
    if timer and not timer:is_closing() then
      timer:stop()
      timer:close()
    end
    timer = nil
    if pipe and not pipe:is_closing() then
      pcall(function()
        pipe:read_stop()
        pipe:close()
      end)
    end
    pipe = nil
    cb(err, result)
  end

  timer:start(timeout, 0, function() finish("timeout") end)

  pipe:connect(addr, function(err)
    if err then return finish(err) end

    local ok, payload = pcall(vim.mpack.encode, { 0, 1, method, params })
    if not ok then return finish("encode error: " .. tostring(payload)) end

    pipe:write(payload, function(werr)
      if werr then finish(werr) end
    end)

    pipe:read_start(function(rerr, data)
      if rerr then return finish(tostring(rerr)) end
      if not data then return finish("connection closed") end

      chunks[#chunks + 1] = data
      local decoded, msg = pcall(vim.mpack.decode, table.concat(chunks))
      if decoded then
        local rpc_err = msg[3]
        if rpc_err == vim.NIL then rpc_err = nil end
        finish(rpc_err, msg[4])
      elseif not tostring(msg):find("incomplete", 1, true) then
        finish("decode error: " .. tostring(msg))
      end
      -- otherwise: incomplete message, keep buffering
    end)
  end)
end

-- ---------------------------------------------------------------------------
-- Discovery
-- ---------------------------------------------------------------------------

local INFO_TTL = 1000 -- reuse a successful result for this long (ms)
local INFO_BACKOFF = 5000 -- don't re-probe a failed server for this long (ms)
local RPC_TIMEOUT = 3000 -- abandon a background request after this long (ms)
local PROBE_WAIT = 100 -- max time `list_sessions` waits for fresh info (ms)

---Fetched from each peer in a single round trip.
local info_lua = [[
local ok_orig, orig = pcall(function() return require("servery").cwd() end)
local ok_ua, ua = pcall(function() return vim.v.useractive end)
local ok_st, st = pcall(function() return vim.v.starttime end)
return {
  cwd = vim.fn.getcwd(),
  pid = vim.fn.getpid(),
  original_cwd = (ok_orig and orig ~= nil) and orig or vim.NIL,
  useractive = (ok_ua and ua ~= nil) and ua or vim.NIL,
  starttime = (ok_st and st ~= nil) and st or vim.NIL,
}
]]

---@class servery_async.CacheEntry
---@field cwd string?
---@field server servery_async.ServerInfo
---@field ts integer
---@field ok boolean
---@field err string?

---@type table<string, servery_async.CacheEntry>
local cache = {}
---@type table<string, integer>  socket -> time the in-flight request started
local inflight = {}
local suppress_wait = false

local function or_nil(v) return (v ~= nil and v ~= vim.NIL) and v or nil end

local function is_dead(err)
  if not err then return false end
  local s = tostring(err):lower()
  return s:find("refused", 1, true) ~= nil
    or s:find("no such file", 1, true) ~= nil
    or s:find("enoent", 1, true) ~= nil
end

local function probe(addr)
  if inflight[addr] then return end

  if addr == vim.v.servername then
    local ok_ua, ua = pcall(function() return vim.v.useractive end)
    local ok_st, st = pcall(function() return vim.v.starttime end)
    cache[addr] = {
      cwd = vim.fn.getcwd(),
      server = {
        socket = addr,
        pid = vim.fn.getpid(),
        original_cwd = require("servery").cwd(),
        useractive = ok_ua and ua or nil,
        starttime = ok_st and st or nil,
      },
      ts = vim.uv.now(),
      ok = true,
    }
    return
  end

  inflight[addr] = vim.uv.now()
  request(addr, "nvim_exec_lua", { info_lua, {} }, RPC_TIMEOUT, function(err, res)
    inflight[addr] = nil
    if err or type(res) ~= "table" then
      local prev = cache[addr]
      cache[addr] = {
        cwd = prev and prev.cwd,
        server = (prev and prev.server) or { socket = addr },
        ts = vim.uv.now(),
        ok = false,
        err = err or "invalid response",
      }
      return
    end
    cache[addr] = {
      cwd = res.cwd,
      server = {
        socket = addr,
        pid = res.pid,
        original_cwd = or_nil(res.original_cwd),
        useractive = or_nil(res.useractive),
        starttime = or_nil(res.starttime),
      },
      ts = vim.uv.now(),
      ok = true,
    }
  end)
end

local function usable(addr)
  local c = cache[addr]
  if c then
    local age = vim.uv.now() - c.ts
    if c.ok then return age < INFO_TTL end
    -- Recent failure: give up on it for a while rather than stalling every call
    return age < INFO_BACKOFF
  end
  -- No result yet. Once an in-flight probe has had its full wait budget,
  -- treat it as usable so we don't stall again on the same request.
  local started = inflight[addr]
  return started ~= nil and (vim.uv.now() - started) >= PROBE_WAIT
end

---Fast, non-blocking replacement for the default `servers`.
---
---Enumerates peer sockets in `stdpath('run')` plus servery's managed
---`session_dir`, instead of `vim.fn.serverlist({ peer = true })`.
---@return string[]
function M.servers()
  local servery = require("servery")
  local out, seen = {}, {}

  local function add(path)
    if path and not seen[path] then
      seen[path] = true
      out[#out + 1] = path
    end
  end

  local run = vim.fn.stdpath("run")
  if vim.fn.isdirectory(run) == 1 then
    for name, ty in vim.fs.dir(run) do
      if ty == "socket" and vim.startswith(name, "nvim.") then add(vim.fs.joinpath(run, name)) end
    end
  end

  local session_dir = servery.get_cfg().session_dir
  if vim.fn.isdirectory(session_dir) == 1 then
    for name, ty in vim.fs.dir(session_dir) do
      if ty == "socket" then add(vim.fs.joinpath(session_dir, name)) end
    end
  end

  return out
end

---@param wait boolean
---@return servery.Session[]
local function list_servers(wait)
  local addrs = require("servery").get_cfg().servers()

  for _, addr in ipairs(addrs) do
    if not usable(addr) then probe(addr) end
  end

  if wait and not vim.in_fast_event() then
    vim.wait(PROBE_WAIT, function()
      for _, addr in ipairs(addrs) do
        if not usable(addr) then return false end
      end
      return true
    end, 2)
  end

  local out = {} ---@type servery.Session[]
  for _, addr in ipairs(addrs) do
    local c = cache[addr]
    if not (c and not c.ok and is_dead(c.err)) then
      out[#out + 1] = Session.new(c and c.cwd, (c and c.server) or { socket = addr })
    end
  end
  return out
end

---@return servery.Session[]
local function list_dirs()
  local cfg = require("servery").get_cfg()
  local dirs = type(cfg.dirs) == "table" and cfg.dirs or cfg.dirs()
  return vim.tbl_map(Session.new, dirs)
end

---Drop-in, non-blocking replacement for `servery.list_sessions`.
---@param status? "any" | "active" | "inactive"
---@param opts? { wait?: boolean }
---@return servery.Session[]
function M.list_sessions(status, opts)
  status = status or "any"
  local wait = not suppress_wait and not (opts and opts.wait == false)
  -- Never wait while the user is tab-completing `:Sv`
  if vim.fn.getcmdtype() ~= "" then wait = false end

  local out = {} ---@type servery.Session[]
  if status == "any" or status == "active" then vim.list_extend(out, list_servers(wait)) end
  if status == "any" or status == "inactive" then
    -- `cfg.dirs()` may itself call `list_sessions("active")`; the pass above
    -- already waited for fresh info, so don't wait a second time.
    local prev = suppress_wait
    suppress_wait = true
    vim.list_extend(out, list_dirs())
    suppress_wait = prev
  end

  table.sort(out, function(a, b)
    if a.server and not b.server then return true end
    if b.server and not a.server then return false end
    if a.server and b.server then
      if a.server.socket == vim.v.servername then return true end
      if b.server.socket == vim.v.servername then return false end
      local key = vim.fn.has("nvim-0.13") == 1 and "useractive" or "pid"
      return (a.server[key] or 0) > (b.server[key] or 0)
    end
    return (a.cwd or "") < (b.cwd or "")
  end)

  return out
end

---Install the non-blocking implementation into servery.
function M.install()
  local servery = require("servery")
  servery.get_cfg().servers = M.servers
  servery.list_sessions = M.list_sessions

  -- Sessions whose info hasn't arrived yet have no `cwd`; upstream's
  -- `display_name()` doesn't handle that and renders `v:null`.
  if not M._patched_display_name then
    M._patched_display_name = true
    local orig = Session.display_name
    function Session:display_name()
      if not self.cwd then return self.server and vim.fs.basename(self.server.socket) or "?" end
      return orig(self)
    end
  end
end

return M
