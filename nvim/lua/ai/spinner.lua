local icons = require "config.icons"

local M = {}

local ns_id = vim.api.nvim_create_namespace "spinner"

local config = {
  text = icons.ai .. " ",
  width = 5,
  row = -1,
  col = 0,
  hl_positions = {
    { 2, 5 }, -- First circle
    { 5, 8 }, -- Second circle
    { 8, 11 }, -- Third circle
  },
  interval = 75,
  hl = {
    on = "DiagnosticWarn",
    off = "NonText",
  },
}

local first_pos = config.hl_positions[1][1]
local last_pos = config.hl_positions[#config.hl_positions][2]

local state = {
  timer = nil,
  win = nil,
  buf = nil,
  frame = 1,
}

local function set_icon_hl(buf)
  vim.api.nvim_buf_set_extmark(buf, ns_id, 0, 0, {
    end_col = 2,
    hl_group = config.hl.on,
    priority = vim.hl.priorities.user - 1,
  })
end

local function reset_text_hl(buf)
  vim.api.nvim_buf_set_extmark(buf, ns_id, 0, first_pos, {
    end_col = last_pos,
    hl_group = config.hl.off,
    priority = vim.hl.priorities.user - 1,
  })
end

local function tick()
  if
    state.win == nil
    or state.buf == nil
    or not (vim.api.nvim_win_is_valid(state.win) and vim.api.nvim_buf_is_valid(state.buf))
  then
    M.stop()
    return
  end

  local buf = state.buf

  -- Update window position relative to cursor
  local ok = pcall(vim.api.nvim_win_set_config, state.win, {
    relative = "cursor",
    row = config.row,
    col = config.col,
  })

  -- If window update failed, stop the spinner
  if not ok then
    M.stop()
    return
  end

  vim.api.nvim_buf_clear_namespace(state.buf, ns_id, 0, -1)

  set_icon_hl(buf)
  reset_text_hl(buf)

  -- Set animation highlight
  local hl_pos = config.hl_positions[state.frame]
  vim.api.nvim_buf_set_extmark(state.buf, ns_id, 0, hl_pos[1], {
    end_col = hl_pos[2],
    hl_group = config.hl.on,
    priority = vim.hl.priorities.user + 1,
  })

  state.frame = (state.frame % #config.hl_positions) + 1
end

function M.start()
  if state.timer then
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    row = config.row,
    col = config.col,
    width = config.width,
    height = 1,
    style = "minimal",
    focusable = false,
    border = "none",
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { config.text })

  set_icon_hl(buf)
  reset_text_hl(buf)

  state.buf = buf
  state.win = win
  state.timer = vim.uv.new_timer()
  state.timer:start(0, config.interval, vim.schedule_wrap(tick))
end

function M.stop()
  if state.timer then
    state.timer:stop()
    state.timer:close()
    state.timer = nil
  end

  -- safely close the window if it exists and is valid
  if state.win then
    pcall(vim.api.nvim_win_close, state.win, true)
    state.win = nil
  end

  if state.buf then
    pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
    state.buf = nil
  end
  state.frame = 1
end

return M
