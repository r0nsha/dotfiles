---@class ShellOpts
---@field lhs string mapping to toggle out of the shell
---@field prg string? a program to run, or the default shell if `nil`

local M = {}

--- Windows to return to when leaving a shell, in LIFO order.
local prevwins = {} ---@type integer[]

--- Buffer name of the shell described by `opts`, from which it can be recreated.
---@param opts ShellOpts
---@return string
local function shell_name(opts) return string.format("shell://%s/%s", opts.lhs, opts.prg or "") end

--- Parse a buffer name back into the `opts` of the shell it names.
---@param name string
---@return ShellOpts? opts `nil` if `name` isn't a shell's
local function parse_name(name)
  local lhs, prg = name:match("^shell://(.-)/(.*)$")
  if lhs then return { lhs = lhs, prg = prg ~= "" and prg or nil } end
end

--- Human-readable title for the shell named `name`.
---@param name string a buffer name
---@return string? title `nil` if `name` isn't a shell's
function M.title(name)
  local opts = parse_name(name)
  return opts and string.format("%s (%s)", opts.prg or "shell", opts.lhs)
end

--- Is `buf` one of our shells?
---@param buf integer
---@return boolean
local function is_shell(buf) return parse_name(vim.api.nvim_buf_get_name(buf)) ~= nil end

local plain_buftypes = { "help", "nofile", "nowrite", "prompt", "quickfix" }
local plain_filetypes = { "cmd", "dialog", "msg", "pager" }

--- Is `win` a valid, non-temporary window, i.e. somewhere worth returning to?
---@param win integer|false|nil
---@return boolean
local function is_plain(win)
  if not win or not vim.api.nvim_win_is_valid(win) then return false end
  local bo = vim.bo[vim.api.nvim_win_get_buf(win)]
  return not (
    vim.list_contains(plain_buftypes, bo.buftype) or vim.list_contains(plain_filetypes, bo.filetype)
  )
end

--- Does `tab` display `buf`?
---@param tab integer
---@param buf integer
---@return boolean
local function tab_shows(tab, buf)
  return vim
    .iter(vim.fn.win_findbuf(buf))
    :any(function(win) return vim.api.nvim_win_get_tabpage(win) == tab end)
end

--- Does `win`'s tabpage also display `shell_buf`?
---@param win integer
---@param shell_buf integer
---@return boolean
local function shares_tab(win, shell_buf)
  return tab_shows(vim.api.nvim_win_get_tabpage(win), shell_buf)
end

--- Remember `win` as a place to return to, unless it is `plain` or in `shell_buf`'s
--- tabpage.
---@param win integer|false|nil
---@param shell_buf integer the shell buffer being toggled
local function push_prevwin(win, shell_buf)
  if not is_plain(win) or shares_tab(win, shell_buf) then return end
  if prevwins[#prevwins] ~= win then prevwins[#prevwins + 1] = win end
end

--- Focus the most recent window on the stack outside `shell_buf`'s tabpage,
--- popping unusable ones as we go.
---@param shell_buf integer the buffer of the shell being left
---@return integer? win the window focused, if any
local function goto_prevwin(shell_buf)
  while #prevwins > 0 do
    local win = prevwins[#prevwins]
    prevwins[#prevwins] = nil
    if is_plain(win) and not shares_tab(win, shell_buf) then
      vim.api.nvim_set_current_win(win)
      return win
    end
  end
  return nil
end

--- Close `tab`, splits and all. Fails silently, e.g. on a modified buffer with 'nohidden'.
---@param tab integer a valid tabpage other than the current one
local function close_tab(tab) pcall(vim.cmd.tabclose, vim.api.nvim_tabpage_get_number(tab)) end

--- Toggle or create a shell buffer.
---@param opts ShellOpts
function M.toggle(opts)
  local curtab = vim.api.nvim_get_current_tabpage()
  local curwin = vim.api.nvim_get_current_win()
  local curbuf = vim.api.nvim_get_current_buf()
  local altwin = vim.fn.win_getid(vim.fn.winnr("#")) ---@type integer?
  if altwin == 0 then altwin = nil end
  local alttab = vim.api.nvim_list_tabpages()[vim.fn.tabpagenr("#")] ---@type integer?
  if alttab == curtab then alttab = nil end

  local name = shell_name(opts)
  local buf = vim
    .iter(vim.api.nvim_list_bufs())
    :find(function(b) return vim.api.nvim_buf_get_name(b) == name end) or -1
  local exists = buf ~= -1

  -- Make sure there is somewhere to return to.
  if #prevwins == 0 then
    for _, win in ipairs({
      curwin,
      altwin or false,
      alttab and vim.api.nvim_tabpage_get_win(alttab) or false,
      vim.iter(vim.api.nvim_tabpage_list_wins(0)):find(is_plain),
    }) do
      push_prevwin(win, buf)
      if #prevwins > 0 then break end
    end
  end

  if tab_shows(curtab, buf) then
    if not goto_prevwin(buf) then
      if alttab then
        vim.api.nvim_set_current_tabpage(alttab)
      elseif #vim.api.nvim_list_tabpages() > 1 then
        vim.cmd.tabprevious()
      end
    end
    if vim.api.nvim_get_current_tabpage() ~= curtab then close_tab(curtab) end
    return
  end

  if not is_plain(curwin) then curwin = is_plain(altwin) and altwin or prevwins[#prevwins] end

  if exists then
    -- Return to the shell's tabpage as it was left, e.g. focusing a split in it.
    local w = vim.fn.win_findbuf(buf)[1]
    if w then
      vim.api.nvim_set_current_tabpage(vim.api.nvim_win_get_tabpage(w))
    else
      -- Loads the shell if it is unloaded, e.g. listed by :mksession.
      vim.cmd("tab sbuffer " .. buf)
    end
  else
    vim.cmd("$tabedit " .. vim.fn.fnameescape(name))
    -- Make the buffer we came from the alternate file (`#`, <C-^>).
    vim.fn.setreg("#", tostring(curbuf))
  end

  -- Jumping straight from another shell's tabpage: close it, as toggling out of it
  -- would have, instead of remembering it.
  if vim.api.nvim_tabpage_is_valid(curtab) and curtab ~= vim.api.nvim_get_current_tabpage() then
    local is_shell_tab = vim
      .iter(vim.api.nvim_tabpage_list_wins(curtab))
      :any(function(win) return is_shell(vim.api.nvim_win_get_buf(win)) end) ---@type boolean
    if is_shell_tab then
      close_tab(curtab)
      return
    end
  end

  push_prevwin(curwin, buf)
end

vim.api.nvim_create_autocmd("BufReadCmd", {
  group = vim.api.nvim_create_augroup("config.shell", {}),
  pattern = "shell://*",
  nested = true, -- for TermOpen
  desc = "Start the shell named by the buffer, e.g. when restored by :mksession",
  callback = function(ev)
    local opts = parse_name(ev.match)
    if not opts then return end
    vim.fn.jobstart(opts.prg or { vim.o.shell }, { term = true })
    -- `jobstart` renamed the buffer to term://…: restore its name, and wipe the
    -- buffer that renaming leaves behind under the old one.
    local term_name = vim.api.nvim_buf_get_name(ev.buf)
    vim.api.nvim_buf_set_name(ev.buf, ev.match)
    local old = vim.fn.bufnr("#")
    if old ~= -1 and vim.api.nvim_buf_get_name(old) == term_name then
      vim.api.nvim_buf_delete(old, { force = true })
    end
    vim.bo[ev.buf].scrollback = -1
    vim.bo[ev.buf].buflisted = false

    local function exit() M.toggle(opts) end
    for _, mapping in ipairs({ opts.lhs, "<A-Esc>" }) do
      vim.keymap.set(
        "t",
        mapping,
        exit,
        { buffer = ev.buf, desc = string.format("Toggle %s", M.title(ev.match)) }
      )
    end
  end,
})

--- Map `lhs` to toggle the shell described by `opts`.
---@param opts ShellOpts
function M.new(opts)
  vim.keymap.set(
    { "n", "t" },
    opts.lhs,
    function() M.toggle(opts) end,
    { desc = string.format("Toggle %s", M.title(shell_name(opts))) }
  )
end

return M
