local augroup = require("augroup")

local M = {}

-- Mappings shadowed for nested children. This lives in the *parent's* Lua
-- state; the module is cached there, so the table survives across RPC calls.
---@type table<string, { buf: integer?, saved: (string|table)[] }>
local passthrough = {}

--- Leave terminal mode, remembering not to re-enter it on focus.
local function exit_term_mode()
  vim.b.term_insert = false
  return [[<C-\><C-n>]]
end
for _, lhs in ipairs({ "<C-Esc>", "<S-Esc>", "<A-Esc>" }) do
  vim.keymap.set("t", lhs, exit_term_mode, { expr = true, desc = "Exit terminal mode" })
end

-- The hooks below are *not* called in this Nvim.  A nested Nvim invokes them on
-- its parent over RPC (`require('config.term').parent_start(...)`).  Keeping the
-- originals in the parent's own Lua state lets Lua callbacks -- which cannot be
-- serialized over RPC -- round-trip through `mapset()`.

--- Shadow the parent's terminal-mode mappings so keys reach a nested child.
--- Runs in the parent Nvim via RPC.
---@param token string unique per child (its pid)
---@param lhs_list string[] terminal-mode mappings the child handles
---@param ppid integer the child's parent process (= this terminal's shell)
---@return integer #mappings shadowed
function M.parent_start(token, lhs_list, ppid)
  -- The terminal buffer whose shell is the child's parent process.
  local buf ---@type integer?
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buftype == "terminal" and vim.b[b].terminal_job_pid == ppid then
      buf = b
      break
    end
  end
  if not buf then
    local cur = vim.api.nvim_get_current_buf()
    if vim.bo[cur].buftype == "terminal" then buf = cur end
  end

  -- Never clobber a mapping the user set directly in that buffer.
  local keep = {}
  if buf then
    for _, m in ipairs(vim.api.nvim_buf_get_keymap(buf, "t")) do
      keep[m.lhs] = true
    end
  end

  local saved = {}
  for _, lhs in ipairs(lhs_list) do
    local map = vim.fn.maparg(lhs, "t", false, true)
    if type(map) == "table" and next(map) ~= nil and not keep[lhs] then
      saved[#saved + 1] = buf and lhs or map
      if buf then
        vim.keymap.set("t", lhs, lhs, { buffer = buf }) -- pass the key through
      else
        vim.keymap.set("t", lhs, lhs)
      end
    end
  end
  passthrough[token] = { buf = buf, saved = saved }
  return #saved
end

--- Undo `M.parent_start`.  Runs in the parent Nvim via RPC.
---@param token string
---@return integer #mappings restored
function M.parent_stop(token)
  local entry = passthrough[token]
  if not entry then return 0 end
  passthrough[token] = nil
  local buf, saved = entry.buf, entry.saved
  for _, item in ipairs(saved) do
    if buf and vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.keymap.del, "t", item, { buffer = buf })
    elseif type(item) == "table" then
      pcall(vim.fn.mapset, "t", false, item)
    end
  end
  return #saved
end

-- :terminal-nested Nvim:
-- Handles both instances running inside a `:terminal`, and `nvim --headless --listen`
-- instances that inherit `$NVIM` (i.e. from `servery.nvim`)
local function setup_parent_passthrough()
  if not vim.env.NVIM or vim.tbl_contains(vim.v.argv, "--headless") then return end

  ---Connect to the parent $NVIM, if it is reachable.
  ---@return integer? chan
  local function parent_chan()
    local ok, chan = pcall(vim.fn.sockconnect, "pipe", vim.env.NVIM, { rpc = true })
    if not ok or chan == 0 then return nil end
    return chan --[[@as integer?]]
  end

  ---Ask the parent to run Lua code.  Returns the result, or nil if the parent
  ---could not run it (e.g. the connection died).  Never raises.
  ---@param chan integer
  ---@param code string
  ---@param args any[]
  ---@return any?
  local function parent_exec(chan, code, args)
    local ok, res = pcall(vim.rpcrequest, chan, "nvim_exec_lua", code, args)
    if not ok then return nil end
    return res
  end

  -- The parent owns the keyboard while this Nvim runs in one of its terminals,
  -- so forward every global terminal-mode mapping this session defines.  Only
  -- `lhs` strings cross the RPC boundary; the parent resolves them (including
  -- Lua callbacks) in its own table.
  local lhs_list = vim.tbl_map(function(m) return m.lhs end, vim.api.nvim_get_keymap("t"))
  if #lhs_list == 0 then return end

  -- These run in the parent Nvim; see M.parent_start / M.parent_stop.
  local START_CODE = "return require('config.term').parent_start(...)"
  local STOP_CODE = "return require('config.term').parent_stop(...)"

  local token = tostring(vim.uv.os_getpid())

  -- Best-effort: a dead / busy parent must never break Nvim startup.
  local n_saved ---@type integer?
  local ok, err = pcall(function()
    local chan = parent_chan()
    if not chan then return end
    n_saved = parent_exec(chan, START_CODE, { token, lhs_list, vim.uv.os_getppid() })
    vim.fn.chanclose(chan)
  end)
  if not ok then
    vim.notify_once("config.term: parent-nvim setup failed: " .. tostring(err), vim.log.levels.WARN)
  end

  if n_saved and n_saved > 0 then
    -- Restore the parent's original mappings when this Nvim exits.
    vim.api.nvim_create_autocmd("VimLeave", {
      group = augroup,
      desc = "Restore parent nvim mappings",
      callback = function()
        local c = parent_chan()
        if c then
          parent_exec(c, STOP_CODE, { token })
          vim.fn.chanclose(c)
        end
      end,
    })
  end
end

setup_parent_passthrough()

vim.api.nvim_create_autocmd("TermRequest", {
  group = augroup,
  desc = "Handles OSC 7 dir change requests",
  callback = function(ev)
    local data = ev.data ---@type vim.event.termrequest.data
    local dir, n = string.gsub(data.sequence, "\027]7;file://[^/]*", "")
    if n > 0 then
      -- OSC 7: dir-change
      if
        (vim.uv.fs_stat(dir) or {}).type == "directory"
        and vim.api.nvim_get_current_buf() == ev.buf
      then
        vim.cmd.bcd(dir)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function(args)
    local enter_term_mode = vim.schedule_wrap(function()
      if vim.api.nvim_get_current_buf() == args.buf and vim.b[args.buf].term_insert ~= false then
        vim.cmd.startinsert()
      end
    end)

    enter_term_mode()

    vim.api.nvim_create_autocmd({ "TermEnter", "InsertEnter" }, {
      desc = "Remember buffer was left in insert/terminal mode",
      group = augroup,
      buffer = args.buf,
      callback = function() vim.b[args.buf].term_insert = true end,
    })
    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
      desc = "Resume insert/terminal mode when focusing a terminal buffer",
      group = augroup,
      buffer = args.buf,
      callback = enter_term_mode,
    })
  end,
})

return M
