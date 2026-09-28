local augroup = require("augroup")

local exit_term_expr = [[<C-\><C-n>]]
vim.keymap.set("t", "<C-Esc>", exit_term_expr, { desc = "Exit terminal mode" })
vim.keymap.set("t", "<S-Esc>", exit_term_expr, { desc = "Exit terminal mode" })
vim.keymap.set("t", "<A-Esc>", exit_term_expr, { desc = "Exit terminal mode" })

-- :terminal-nested Nvim:
--
-- When Nvim runs inside a `:terminal` (parent), `$NVIM` points to the parent's
-- server address.  In that case we ask the parent to pass `<C-Esc>` (etc.)
-- through to us instead of consuming the key, so that TUI programs (e.g. pi)
-- running in this terminal receive the original escape sequence.
--
-- A headless Nvim (e.g. one spawned by servery.nvim via `nvim --headless
-- --listen`) also inherits `$NVIM` from the Nvim that spawned it, but it is not
-- running in a terminal, so there is no parent terminal to rewrite.
if vim.env.NVIM and not vim.tbl_contains(vim.v.argv, "--headless") then
  local ESC_LHS = { "<C-Esc>", "<S-Esc>", "<A-Esc>" }

  ---Connect to the parent ($NVIM) Nvim, if it is reachable.
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

  -- The parent runs this chunk to find and rewrite any "Exit terminal mode"
  -- t-mode mappings that this config created.  `maparg()` returns a
  -- serializable dict only for string mappings; a Lua `callback` function
  -- cannot cross the RPC boundary.  Only mappings whose rhs is exactly the
  -- child's exit expr are touched.
  local MAP_CODE = [==[
    local lhs_list, exit_expr = ...
    local changed = {}
    for _, lhs in ipairs(lhs_list) do
      local map = vim.fn.maparg(lhs, 't', false, true)
      if type(map) == 'table' and map.rhs == exit_expr then
        vim.keymap.set('t', lhs, lhs)
        changed[#changed + 1] = lhs
      end
    end
    return changed
  ]==]

  -- Best-effort: a dead / busy parent must never break Nvim startup.
  local changed ---@type string[]?
  local ok, err = pcall(function()
    local chan = parent_chan()
    if not chan then return end
    changed = parent_exec(chan, MAP_CODE, { ESC_LHS, exit_term_expr })
    vim.fn.chanclose(chan)
  end)
  if not ok then
    vim.notify_once("config.term: parent-nvim setup failed: " .. tostring(err), vim.log.levels.WARN)
  end

  if type(changed) == "table" and #changed > 0 then
    -- Restore the parent's original mappings when this Nvim exits.  Since
    -- the original mappings were string-based, we re-create them from the
    -- child's own definition (which is identical).
    local RESTORE_CODE = ([[
      local lhs_list, rhs = ...
      for _, lhs in ipairs(lhs_list) do
        vim.keymap.set('t', lhs, rhs, { desc = %q })
      end
    ]]):format("Exit terminal mode")

    vim.api.nvim_create_autocmd("VimLeave", {
      group = augroup,
      desc = "Restore parent nvim mappings",
      callback = function()
        local c = parent_chan()
        if c then
          parent_exec(c, RESTORE_CODE, { changed, exit_term_expr })
          vim.fn.chanclose(c)
        end
      end,
    })
  end
end

-- local term_prompt_ns = vim.api.nvim_create_namespace("config.term.prompt")

vim.api.nvim_create_autocmd("TermRequest", {
  group = augroup,
  desc = "Handles OSC 7 dir change requests and OSC 133 shell prompts",
  callback = function(ev)
    local dir, n = string.gsub(ev.data.sequence, "\027]7;file://[^/]*", "")
    if n > 0 then
      -- OSC 7: dir-change
      assert((vim.uv.fs_stat(dir) or {}).type == "directory", "invalid dir: " .. dir)
      if vim.api.nvim_get_current_buf() == ev.buf then vim.cmd.bcd(dir) end
    end

    -- if string.match(ev.data.sequence, "^\027]133;A") then
    --   -- OSC 133: shell-prompt
    --   local lnum = ev.data.cursor[1]
    --   vim.api.nvim_buf_set_extmark(ev.buf, term_prompt_ns, lnum - 1, 0, {
    --     sign_text = "∙",
    --     -- sign_hl_group = "SpecialChar",
    --   })
    -- end
  end,
})

-- Better terminal-mode behavior
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
    vim.api.nvim_create_autocmd({ "TermLeave", "InsertLeave" }, {
      desc = "Remember buffer was left out of insert/terminal mode",
      group = augroup,
      buffer = args.buf,
      callback = function() vim.b[args.buf].term_insert = false end,
    })
    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
      desc = "Resume insert/terminal mode when focusing a terminal buffer",
      group = augroup,
      buffer = args.buf,
      callback = function() enter_term_mode() end,
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

local state = {} ---@type { prevwin: integer? }

---@param win integer?
---@return integer # buffer shown in `win`, or -1 if `win` is invalid
local function win_buf(win)
  return win ~= nil and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) or -1
end

---@param win integer? window id
---@return boolean # whether `win` exists and could be focused
local function goto_win(win)
  if win == nil or not vim.api.nvim_win_is_valid(win) then return false end
  vim.api.nvim_set_current_win(win)
  return true
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

--- Open a window for :shell: a new tab when `cnt == 0`, else a `cnt`-row split.
---@param cnt integer
local function open_shell_win(cnt)
  if cnt == 0 then
    vim.cmd("tab split")
  else
    vim.cmd(("%dsplit"):format(cnt))
  end
end

local M = {}

--- Toggle the :shell buffer.
---@param cnt integer 0 opens a new tab, >0 opens a `cnt`-row split
---@param here boolean edit the :shell buffer in the current window
function M.shell(cnt, here)
  state.prevwin = state.prevwin or vim.api.nvim_get_current_win()
  local b = vim.fn.bufnr(":shell")
  local exists = vim.api.nvim_buf_is_valid(b)

  if exists and here then
    -- Edit the :shell buffer in this window.
    vim.api.nvim_set_current_buf(b)
    vim.bo[b].buflisted = false
    state.prevwin = vim.api.nvim_get_current_win()
    return
  end

  if vim.api.nvim_get_current_buf() == b then
    -- Return to previous window, maybe close the :shell tabpage.
    local tab = vim.api.nvim_get_current_tabpage()
    local term_prevwin = vim.api.nvim_get_current_win()
    if not goto_win(state.prevwin) then vim.cmd.wincmd("p") end
    local tabwins = vim.api.nvim_tabpage_list_wins(tab)
    if #tabwins == 1 and vim.api.nvim_get_current_tabpage() ~= tab then
      -- Close the :shell tabpage if it's the only window in the tabpage.
      vim.api.nvim_win_close(tabwins[1], true)
    end
    if vim.api.nvim_get_current_buf() == b then
      -- Edge-case: :shell buffer showing in multiple windows in curtab.
      -- Find a non-:shell window in curtab.
      local other = vim
        .iter(vim.api.nvim_tabpage_list_wins(0))
        :find(function(win) return vim.api.nvim_win_get_buf(win) ~= b end)
      if other then
        vim.api.nvim_set_current_win(other)
      else
        -- Last resort: can happen if :mksession restores an old :shell.
        if is_stale_shell(vim.api.nvim_get_current_buf()) then
          -- XXX: cleanup stale, empty :shell buffer (caused by :mksession).
          vim.api.nvim_buf_delete(0, { force = true })
          M.shell(cnt, here)
        end
        return
      end
    end
    state.prevwin = term_prevwin
    return
  end

  -- Go to existing :shell or create a new one.
  local curwin = vim.api.nvim_get_current_win()
  if cnt == 0 and exists and win_buf(state.prevwin) == b then
    -- Go to :shell displayed in the previous window.
    goto_win(state.prevwin)
  elseif exists then
    -- Go to existing :shell.
    local w = wins_showing(b, 0)[1]
    if cnt == 0 and w then
      -- Found in current tabpage.
      goto_win(w)
    else
      -- Not in current tabpage.
      local ws = wins_showing(b)
      if cnt == 0 and #ws > 0 then
        -- Found in another tabpage.
        goto_win(ws[1])
      else
        -- Not in any existing window; open a tabpage (or split-window if
        -- [count] was given).
        open_shell_win(cnt)
        vim.api.nvim_set_current_buf(b)
      end
    end
    if is_stale_shell(vim.api.nvim_get_current_buf()) then
      goto_win(state.prevwin)
      -- XXX: cleanup stale, empty :shell buffer (caused by :mksession).
      vim.api.nvim_buf_delete(b, { force = true })
      M.shell(cnt, here)
    end
  else
    -- Create new :shell.
    local origbuf = vim.api.nvim_get_current_buf()
    if not here then open_shell_win(cnt) end
    vim.cmd.terminal()
    local shellbuf = vim.api.nvim_get_current_buf()
    vim.bo[shellbuf].scrollback = -1
    vim.api.nvim_buf_set_name(shellbuf, ":shell")
    vim.bo[shellbuf].buflisted = false
    -- Set the alternate buffer to something intuitive.
    vim.fn.setreg("#", tostring(origbuf))
    vim.keymap.set(
      "t",
      "<C-s>",
      [[<C-\><C-n><cmd>let b:term_insert = v:true | lua require('config.term').shell(0, false)<cr>]],
      { buffer = shellbuf, desc = "Toggle :shell" }
    )
  end
  state.prevwin = curwin
end

vim.keymap.set("n", "<C-s>", function() M.shell(vim.v.count, false) end, { desc = "Toggle :shell" })
vim.keymap.set(
  "n",
  "'<C-s>",
  function() M.shell(vim.v.count, true) end,
  { desc = "Open :shell here" }
)

return M
