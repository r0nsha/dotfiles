local icons = require("utils").icons
local M = {}

local ns_id = vim.api.nvim_create_namespace "spinner"

M.config = {
  text = " ",
  hl_positions = {
    { 2, 5 }, -- First circle
    { 5, 8 }, -- Second circle
    { 8, 11 }, -- Third circle
  },
  interval = 100,
  hl_group = "String",
  hl_dim_group = "NonText",
}

local first_pos = M.config.hl_positions[1][1]
local last_pos = M.config.hl_positions[3][2]

local spinner_state = {
  timer = nil,
  win = nil,
  buf = nil,
  frame = 1,
}

local function create_spinner_window()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    row = -1,
    col = 0,
    width = 5,
    height = 1,
    style = "minimal",
    focusable = false,
    border = "none",
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { M.config.text })

  -- Set the icon highlight
  vim.api.nvim_buf_set_extmark(buf, ns_id, 0, 0, {
    end_col = 2,
    hl_group = M.config.hl_group,
    priority = vim.highlight.priorities.user - 1,
  })

  -- Set the dim highlight for the entire text
  vim.api.nvim_buf_set_extmark(buf, ns_id, 0, first_pos, {
    end_col = last_pos,
    hl_group = M.config.hl_dim_group,
    priority = vim.highlight.priorities.user - 1,
  })

  return buf, win, ns_id
end

function M.start()
  if spinner_state.timer then
    return
  end

  local buf, win = create_spinner_window()
  spinner_state.buf = buf
  spinner_state.win = win

  spinner_state.timer = vim.loop.new_timer()
  spinner_state.timer:start(
    0,
    M.config.interval,
    vim.schedule_wrap(function()
      if
        spinner_state.win == nil
        or spinner_state.buf == nil
        or not (vim.api.nvim_win_is_valid(spinner_state.win) and vim.api.nvim_buf_is_valid(spinner_state.buf))
      then
        M.stop()
        return
      end

      -- Update window position relative to cursor
      local ok = pcall(vim.api.nvim_win_set_config, spinner_state.win, {
        relative = "cursor",
        row = -1,
        col = 0,
      })

      -- If window update failed, stop the spinner
      if not ok then
        M.stop()
        return
      end
      vim.api.nvim_buf_clear_namespace(spinner_state.buf, ns_id, 0, -1)

      -- Set the icon highlight
      vim.api.nvim_buf_set_extmark(buf, ns_id, 0, 0, {
        end_col = 2,
        hl_group = M.config.hl_group,
        priority = vim.highlight.priorities.user - 1,
      })

      vim.api.nvim_buf_set_extmark(spinner_state.buf, ns_id, 0, first_pos, {
        end_col = last_pos,
        hl_group = M.config.hl_dim_group,
        priority = vim.highlight.priorities.user - 1,
      })

      -- Set animation highlight
      local hl_pos = M.config.hl_positions[spinner_state.frame]
      vim.api.nvim_buf_set_extmark(spinner_state.buf, ns_id, 0, hl_pos[1], {
        end_col = hl_pos[2],
        hl_group = M.config.hl_group,
        priority = vim.highlight.priorities.user + 1,
      })

      spinner_state.frame = (spinner_state.frame % #M.config.hl_positions) + 1
    end)
  )
end

function M.stop()
  if spinner_state.timer then
    spinner_state.timer:stop()
    spinner_state.timer:close()
    spinner_state.timer = nil
  end

  -- safely close the window if it exists and is valid
  if spinner_state.win then
    pcall(vim.api.nvim_win_close, spinner_state.win, true)
    spinner_state.win = nil
  end

  if spinner_state.buf then
    pcall(vim.api.nvim_buf_delete, spinner_state.buf, { force = true })
    spinner_state.buf = nil
  end
  spinner_state.frame = 1
end

return M
