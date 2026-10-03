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
    local dir, n = string.gsub(ev.data.sequence, "\027]7;file://[^/]*", "")
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

--- Is `buf` a stale, empty non-terminal buffer (left over from :mksession)?
---@param buf integer
---@return boolean
local function is_stale_shell(buf)
  return vim.bo[buf].buftype ~= "terminal"
    and vim.api.nvim_buf_line_count(buf) == 1
    and vim.api.nvim_buf_get_lines(buf, 0, 1, true)[1] == ""
end

local prevwins = {} ---@type  integer[]

--- Scratch and temporary buffers are not places to land when leaving :Shell.
local tmp_buftypes = { "help", "nofile", "nowrite", "prompt", "quickfix" }
local tmp_filetypes = { "cmd", "dialog", "msg", "pager" }

---@param win integer?
---@return boolean
local function is_tmp_win(win)
  if win == nil or not vim.api.nvim_win_is_valid(win) then return false end
  local buf = vim.api.nvim_win_get_buf(win)
  return vim.list_contains(tmp_buftypes, vim.bo[buf].buftype)
    or vim.list_contains(tmp_filetypes, vim.bo[buf].filetype)
end

---@param win integer? window id
---@return boolean whether `win` exists and could be focused
local function goto_win(win)
  if win == nil or not vim.api.nvim_win_is_valid(win) or is_tmp_win(win) then return false end
  vim.api.nvim_set_current_win(win)
  return true
end

--- Remember `win` as a place to return to when leaving the current shell.
---@param win integer?
local function push_prevwin(win)
  if not win or not vim.api.nvim_win_is_valid(win) or is_tmp_win(win) then return end
  local wins = prevwins
  if wins[#wins] ~= win then wins[#wins + 1] = win end
end

--- Focus the most recent window on the stack, dropping stale entries as we go.
---@return integer? win the window focused, if any
local function goto_prevwin()
  local wins = prevwins
  while #wins > 0 do
    local win = wins[#wins]
    wins[#wins] = nil
    if goto_win(win) then return win end
  end
  return nil
end

--- Non-temporary windows in `tabpage` (0 = current), optionally skipping `buf`.
---@param tabpage? integer
---@param skip_buf? integer
---@return integer[]
local function plain_wins(tabpage, skip_buf)
  return vim
    .iter(vim.api.nvim_tabpage_list_wins(tabpage or 0))
    :filter(
      function(win) return not is_tmp_win(win) and vim.api.nvim_win_get_buf(win) ~= skip_buf end
    )
    :totable()
end

--- Windows displaying `buf`, in `tabpage` or in every tabpage.
---@param buf integer
---@param tabpage? integer
---@return integer[]
local function wins_showing(buf, tabpage)
  local wins = tabpage and vim.api.nvim_tabpage_list_wins(tabpage) or vim.api.nvim_list_wins()
  return vim
    .iter(wins)
    :filter(function(win) return vim.api.nvim_win_get_buf(win) == buf end)
    :totable()
end

--- Delete a stale `:Shell` buffer (see is_stale_shell) and retry.
---@param buf integer
---@param nr integer
---@param prg string?
local function drop_stale_shell(buf, nr, prg)
  vim.api.nvim_buf_delete(buf, { force = true })
  M.shell(nr, prg)
end

--- Last-used shell number, per program ("" is the default shell).
---@type table<string, integer>
local last_shell = {}

--- Toggle or create a :[N]Shell buffer.
---@param nr? integer 0 or nil toggles the last :Shell for `prg`, >0 opens the `nr`th.
---@param prg? string a program to run
function M.shell(nr, prg)
  if prg == "" then prg = nil end
  local key = prg or ""
  nr = nr ~= nil and nr > 0 and nr or last_shell[key] or 1
  last_shell[key] = nr

  local curtab = vim.api.nvim_get_current_tabpage()
  local curwin = vim.api.nvim_get_current_win()
  local curbuf = vim.api.nvim_get_current_buf()

  -- Make sure there is somewhere to return to.
  if #prevwins == 0 then
    local win = curwin ---@type integer?
    if is_tmp_win(win) then
      local alt = vim.fn.win_getid(vim.fn.winnr("#"))
      win = alt ~= 0 and not is_tmp_win(alt) and alt or plain_wins(0)[1]
    end
    push_prevwin(win)
  end

  local name = vim.trim(string.format(":%dShell %s", nr, prg or ""))
  local buf = -1
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    local bn = vim.api.nvim_buf_get_name(b)
    if bn ~= "" and vim.fn.fnamemodify(bn, ":t") == name then buf = b end
  end
  local exists = vim.api.nvim_buf_is_valid(buf)

  if curbuf == buf then
    -- Return to the previous window, closing a dedicated :Shell tabpage.
    if not goto_prevwin() and not goto_win(plain_wins(0, buf)[1]) then vim.cmd.wincmd("p") end
    local tabwins = plain_wins(curtab)
    if #tabwins == 1 and vim.api.nvim_get_current_tabpage() ~= curtab then
      vim.api.nvim_win_close(tabwins[1], true)
    end
    if vim.api.nvim_get_current_buf() == buf then
      -- :Shell is showing in more than one window in this tabpage.
      local other = plain_wins(0, buf)[1]
      if other then
        vim.api.nvim_set_current_win(other)
      else
        -- Last resort: can happen if :mksession restores an old :Shell.
        if is_stale_shell(curbuf) then drop_stale_shell(0, nr, prg) end
        return
      end
    end
    return
  end

  if is_tmp_win(curwin) then
    local alt = vim.fn.win_getid(vim.fn.winnr("#"))
    curwin = alt ~= 0 and not is_tmp_win(alt) and alt or prevwins[#prevwins]
  end

  if exists and vim.fn.winbufnr(prevwins[#prevwins] or -1) == buf then
    goto_win(prevwins[#prevwins])
  elseif exists then
    local w = wins_showing(buf, 0)[1]
    if w then
      goto_win(w)
    else
      local ws = wins_showing(buf)
      if #ws > 0 then
        goto_win(ws[1])
      else
        vim.cmd("tab split")
        vim.api.nvim_set_current_buf(buf)
      end
    end
    if is_stale_shell(buf) then
      goto_prevwin()
      drop_stale_shell(buf, nr, prg)
    end
  else
    local origbuf = curbuf
    vim.cmd("tab split")
    vim.cmd.terminal(prg)
    local shellbuf = vim.api.nvim_get_current_buf()
    vim.bo[shellbuf].scrollback = -1
    vim.api.nvim_buf_set_name(shellbuf, name)
    vim.bo[shellbuf].buflisted = false
    if prg then vim.b[shellbuf].shell_prg = prg end
    -- Set the alternate buffer to something intuitive.
    vim.fn.setreg("#", tostring(origbuf))
    vim.keymap.set(
      "t",
      "<C-s>",
      string.format([[<C-\><C-n><cmd>let b:term_insert = v:true | %dShell %s<cr>]], nr, prg or ""),
      { buffer = shellbuf, desc = string.format("Toggle %s", name) }
    )
  end

  push_prevwin(curwin)
end

vim.api.nvim_create_user_command("Shell", function(args) M.shell(args.count, args.args) end, {
  count = true,
  nargs = "?",
  desc = "Toggle or create a :[N]Shell buffer",
})

vim.keymap.set({ "n", "t" }, "<C-s>", "<cmd>1Shell<cr>", { desc = "Toggle :Shell" })
vim.keymap.set({ "n", "t" }, "<C-S-S>", "<cmd>2Shell<cr>", { desc = "Toggle :2Shell" })

-- vim.keymap.set({ "n", "t" }, "<A-u>", function() M.shell(1, "pi") end, { desc = "Toggle 1st pi" })
-- vim.keymap.set({ "n", "t" }, "<A-i>", function() M.shell(2, "pi") end, { desc = "Toggle 2nd pi" })
-- vim.keymap.set({ "n", "t" }, "<A-o>", function() M.shell(3, "pi") end, { desc = "Toggle 3rd pi" })

return M
