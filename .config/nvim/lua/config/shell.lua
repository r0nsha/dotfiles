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

--- Last-used shell number, per program ("" is the default shell).
---@type table<string, integer>
local last_shell = {}

--- Toggle or create a :[N]Shell buffer.
---@param nr? integer 0 or nil toggles the last :Shell for `prg`, >0 opens the `nr`th.
---@param prg? string a program to run
local function shell(nr, prg)
  if prg == "" then prg = nil end
  local key = prg or ""
  nr = nr ~= nil and nr > 0 and nr or last_shell[key] or 1
  last_shell[key] = nr

  -- local curtab = vim.api.nvim_get_current_tabpage()
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
    -- local tabwins = plain_wins(curtab)
    -- if #tabwins == 1 and vim.api.nvim_get_current_tabpage() ~= curtab then
    --   vim.api.nvim_win_close(tabwins[1], true)
    -- end
    if vim.api.nvim_get_current_buf() == buf then
      -- :Shell is showing in more than one window in this tabpage.
      local other = plain_wins(0, buf)[1]
      if other then
        vim.api.nvim_set_current_win(other)
      else
        -- Last resort: can happen if :mksession restores an old :Shell.
        if is_stale_shell(curbuf) then
          vim.api.nvim_buf_delete(buf, { force = true })
          shell(nr, prg)
        end
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
      vim.api.nvim_buf_delete(buf, { force = true })
      shell(nr, prg)
    end
  else
    vim.cmd(string.format("tab split | tabmove $ | terminal %s", prg or ""))
    local shellbuf = vim.api.nvim_get_current_buf()
    vim.bo[shellbuf].scrollback = -1
    vim.api.nvim_buf_set_name(shellbuf, name)
    vim.bo[shellbuf].buflisted = false
    if prg then vim.b[shellbuf].shell_prg = prg end
    -- Set the alternate buffer to something intuitive.
    vim.fn.setreg("#", tostring(curbuf))
    vim.keymap.set(
      "t",
      "<C-s>",
      string.format([[<C-\><C-n><cmd>let b:term_insert = v:true | %dShell %s<cr>]], nr, prg or ""),
      { buffer = shellbuf, desc = string.format("Toggle %s", name) }
    )
  end

  push_prevwin(curwin)
end

vim.api.nvim_create_user_command("Shell", function(args) shell(args.count, args.args) end, {
  count = true,
  nargs = "?",
  desc = "Toggle or create a :[N]Shell buffer",
})

vim.keymap.set({ "n", "t" }, "<C-s>", "<cmd>1Shell<cr>", { desc = "Toggle :1Shell" })
vim.keymap.set({ "n", "t" }, "<C-S-S>", "<cmd>2Shell<cr>", { desc = "Toggle :2Shell" })

vim.keymap.set({ "n", "t" }, "<A-u>", "<cmd>1Shell pi<cr>", { desc = "Toggle 1st pi" })
vim.keymap.set({ "n", "t" }, "<A-i>", "<cmd>2Shell pi<cr>", { desc = "Toggle 2nd pi" })
vim.keymap.set({ "n", "t" }, "<A-o>", "<cmd>3Shell pi<cr>", { desc = "Toggle 3rd pi" })
