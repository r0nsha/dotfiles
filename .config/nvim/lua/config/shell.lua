local prevwins = {} ---@type  integer[]

--- last used shell `nr` per `prg`.
---@type table<string, integer>
local last = {}

--- Is `buf` a stale?
---@param buf integer
---@return boolean
local function stale(buf)
  return vim.bo[buf].buftype ~= "terminal"
    and vim.api.nvim_buf_line_count(buf) == 1
    and vim.api.nvim_buf_get_lines(buf, 0, 1, true)[1] == ""
end

local not_prevwin = {
  buftypes = { "help", "nofile", "nowrite", "prompt", "quickfix" },
  filetypes = { "cmd", "dialog", "msg", "pager" },
}

---@param win integer?
---@return boolean
local function is_not_prevwin(win)
  if win == nil or not vim.api.nvim_win_is_valid(win) then return false end
  local buf = vim.api.nvim_win_get_buf(win)
  return vim.list_contains(not_prevwin.buftypes, vim.bo[buf].buftype)
    or vim.list_contains(not_prevwin.filetypes, vim.bo[buf].filetype)
end

---@param win integer? window id
---@return boolean whether `win` exists and could be focused
local function goto_win(win)
  if win == nil or not vim.api.nvim_win_is_valid(win) or is_not_prevwin(win) then return false end
  vim.api.nvim_set_current_win(win)
  return true
end

--- Remember `win` as a place to return to when leaving the current shell.
--- Never remember a window already showing the shell being opened: `goto_prevwin`
--- would "succeed" by focusing the current window and consume the entry without
--- actually going anywhere, stranding the user in the shell.
---@param win integer?
---@param shell_buf? integer the buffer of the shell being opened
local function push_prevwin(win, shell_buf)
  if not win or not vim.api.nvim_win_is_valid(win) or is_not_prevwin(win) then return end
  if shell_buf ~= nil and vim.api.nvim_win_get_buf(win) == shell_buf then return end
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
      function(win) return not is_not_prevwin(win) and vim.api.nvim_win_get_buf(win) ~= skip_buf end
    )
    :totable()
end

--- Windows displaying `buf`, in `tabpage` or in every tabpage.
---@param buf integer
---@param tabpage? integer
---@return integer[]
local function wins_showing_buf(buf, tabpage)
  local wins = tabpage and vim.api.nvim_tabpage_list_wins(tabpage) or vim.api.nvim_list_wins()
  return vim
    .iter(wins)
    :filter(function(win) return vim.api.nvim_win_get_buf(win) == buf end)
    :totable()
end

---@class ShellToggleOpts
---@field nr integer? `0` or `nil` toggles the last shell for `prg`, `>0` opens the `nr`th.
---@field prg string? a program to run, or the default shell if `nil`

--- Toggle or create a `nr`th shell buffer.
---@param lhs string mapping to toggle out of shell
---@param opts ShellToggleOpts
local function toggle(lhs, opts)
  if opts.prg == "" then opts.prg = nil end
  local key = opts.prg or ""
  opts.nr = opts.nr ~= nil and opts.nr > 0 and opts.nr or last[key] or 1
  last[key] = opts.nr

  local curtab = vim.api.nvim_get_current_tabpage()
  local curwin = vim.api.nvim_get_current_win()
  local curbuf = vim.api.nvim_get_current_buf()

  local name = vim.trim(string.format("%s %d (%s)", opts.prg or "shell", opts.nr, lhs))
  local buf = -1
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    local bn = vim.api.nvim_buf_get_name(b)
    if bn ~= "" and vim.fn.fnamemodify(bn, ":t") == name then buf = b end
  end
  local exists = vim.api.nvim_buf_is_valid(buf)

  -- Make sure there is somewhere to return to.
  if #prevwins == 0 then
    local win = curwin ---@type integer?
    if is_not_prevwin(win) then
      local alt = vim.fn.win_getid(vim.fn.winnr("#"))
      win = alt ~= 0 and not is_not_prevwin(alt) and alt or plain_wins(0, buf)[1]
    end
    push_prevwin(win, buf)
  end

  if curbuf == buf then
    -- Return to the previous window, closing a dedicated shell tabpage.
    if not goto_prevwin() and not goto_win(plain_wins(0, buf)[1]) then vim.cmd.wincmd("p") end
    local tabwins = plain_wins(curtab)
    if #tabwins == 1 and vim.api.nvim_get_current_tabpage() ~= curtab then
      vim.api.nvim_win_close(tabwins[1], true)
    end
    if vim.api.nvim_get_current_buf() == buf then
      -- shell is showing in more than one window in this tabpage.
      local other = plain_wins(0, buf)[1]
      if other then
        vim.api.nvim_set_current_win(other)
      else
        -- Last resort: can happen if :mksession restores an old shell.
        if stale(curbuf) then
          vim.api.nvim_buf_delete(buf, { force = true })
          toggle(lhs, opts)
        end
        return
      end
    end
    return
  end

  if is_not_prevwin(curwin) then
    local alt = vim.fn.win_getid(vim.fn.winnr("#"))
    curwin = alt ~= 0 and not is_not_prevwin(alt) and alt or prevwins[#prevwins]
  end

  if exists and vim.fn.winbufnr(prevwins[#prevwins] or -1) == buf then
    goto_win(prevwins[#prevwins])
  elseif exists then
    local w = wins_showing_buf(buf, 0)[1]
    if w then
      goto_win(w)
    else
      local ws = wins_showing_buf(buf)
      if #ws > 0 then
        goto_win(ws[1])
      else
        vim.cmd("tab split")
        vim.api.nvim_set_current_buf(buf)
      end
    end
    if stale(buf) then
      goto_prevwin()
      vim.api.nvim_buf_delete(buf, { force = true })
      toggle(lhs, opts)
    end
  else
    vim.cmd(string.format("tab split | tabmove $ | terminal %s", opts.prg or ""))
    local shellbuf = vim.api.nvim_get_current_buf()
    vim.bo[shellbuf].scrollback = -1
    vim.api.nvim_buf_set_name(shellbuf, name)
    vim.bo[shellbuf].buflisted = false
    if opts.prg then vim.b[shellbuf].shell_prg = opts.prg end
    -- Set the alternate buffer to something intuitive.
    vim.fn.setreg("#", tostring(curbuf))
    vim.keymap.set("t", lhs, function()
      vim.b[shellbuf].term_insert = true
      toggle(lhs, opts)
    end, { buffer = shellbuf, desc = string.format("Toggle %s", name) })
  end

  push_prevwin(curwin, buf)
end

--- Assign a shell to `lhs`
---@param lhs string the shell's assigned mapping
---@param opts ShellToggleOpts
local function map_shell(lhs, opts)
  vim.keymap.set(
    { "n", "t" },
    lhs,
    function() toggle(lhs, opts) end,
    { desc = string.format("Toggle %s %s", opts.prg or "shell", tostring(opts.nr) or "last") }
  )
end

map_shell("<C-s>", { nr = 1 })
map_shell("<C-S-S>", { nr = 2 })
map_shell("<A-u>", { nr = 1, prg = "claude" })
map_shell("<A-i>", { nr = 2, prg = "claude" })
map_shell("<A-o>", { nr = 3, prg = "claude" })
