-- Stripped down version of smart-splits.nvim window resizing (MIT)
-- https://github.com/smart-splits-nvim/smart-splits.nvim/blob/master/lua/smart-splits/resize.lua

---@alias Direction "left" | "right" | "up" | "down"

local M = {}

local WinPosition = { start = 0, middle = 1, last = 2 }
local DirectionKeys = { left = "h", right = "l", up = "k", down = "j" }
local WincmdResizeDirection = { bigger = "+", smaller = "-" }

--- Default resize step, multiplied by the count (e.g. `10<C-S-l>`)
M.amount = 2

local function is_floating_window() return vim.api.nvim_win_get_config(0).relative ~= "" end

--- Bounding box (in screen cells) of the current tabpage's non-floating windows
---@return { top: integer, left: integer, bottom: integer, right: integer }
local function tabpage_bounds()
  local top, left, bottom, right = math.huge, math.huge, -math.huge, -math.huge
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      local row, col = unpack(vim.api.nvim_win_get_position(win))
      top = math.min(top, row)
      left = math.min(left, col)
      bottom = math.max(bottom, row + vim.api.nvim_win_get_height(win))
      right = math.max(right, col + vim.api.nvim_win_get_width(win))
    end
  end
  return { top = top, left = left, bottom = bottom, right = right }
end

--- Which tabpage edges the current window touches
---@return { top: boolean, bottom: boolean, left: boolean, right: boolean }
local function current_win_edges()
  local bounds = tabpage_bounds()
  local row, col = unpack(vim.api.nvim_win_get_position(0))
  return {
    top = row == bounds.top,
    bottom = row + vim.api.nvim_win_get_height(0) == bounds.bottom,
    left = col == bounds.left,
    right = col + vim.api.nvim_win_get_width(0) == bounds.right,
  }
end

---@param dir Direction
---@return integer
local function win_position(dir)
  local edges = current_win_edges()
  if dir == "left" or dir == "right" then
    if edges.left then return WinPosition.start end
    if edges.right then return WinPosition.last end
    return WinPosition.middle
  end

  if edges.top then return WinPosition.start end
  if edges.bottom then return WinPosition.last end
  return WinPosition.middle
end

--- Move to the window in the given direction, keeping the cursor line visually in place
---@param dir string direction key, e.g. "h"|"j"|"k"|"l"
local function next_window(dir)
  if dir == DirectionKeys.down or dir == DirectionKeys.up then
    vim.cmd("wincmd " .. dir)
    return
  end

  local offset = vim.fn.winline() + vim.api.nvim_win_get_position(0)[1]
  vim.cmd("wincmd " .. dir)
  local view = vim.fn.winsaveview()
  offset = offset - vim.api.nvim_win_get_position(0)[1]
  vim.cmd("normal! " .. offset .. "H")
  return view
end

---@param dir Direction
---@return string
local function compute_dir_vertical(dir)
  local current_pos = win_position(dir)
  if current_pos == WinPosition.start or current_pos == WinPosition.middle then
    return dir == "down" and WincmdResizeDirection.bigger or WincmdResizeDirection.smaller
  end
  return dir == "down" and WincmdResizeDirection.smaller or WincmdResizeDirection.bigger
end

---@param dir Direction
---@return string
local function compute_dir_horizontal(dir)
  local current_pos = win_position(dir)
  if current_pos == WinPosition.start or current_pos == WinPosition.middle then
    return dir == "right" and WincmdResizeDirection.bigger or WincmdResizeDirection.smaller
  end
  return dir == "right" and WincmdResizeDirection.smaller or WincmdResizeDirection.bigger
end

--- Resize the current window, treating the split at `direction` as the divisor to move
---@param dir Direction
---@param amount integer|nil
function M.resize(dir, amount)
  amount = amount or M.amount

  -- floating windows have no splits to resize
  if is_floating_window() then return end

  if dir == "down" or dir == "up" then
    -- vertically
    local plus_minus = compute_dir_vertical(dir)
    local cur_win_pos = vim.api.nvim_win_get_position(0)
    vim.cmd(string.format("resize %s%s", plus_minus, amount))
    if win_position(dir) ~= WinPosition.middle then return end

    local new_win_pos = vim.api.nvim_win_get_position(0)
    local adjustment_plus_minus
    if cur_win_pos[1] < new_win_pos[1] and plus_minus == WincmdResizeDirection.smaller then
      adjustment_plus_minus = WincmdResizeDirection.bigger
    elseif cur_win_pos[1] > new_win_pos[1] and plus_minus == WincmdResizeDirection.bigger then
      adjustment_plus_minus = WincmdResizeDirection.smaller
    end

    if current_win_edges().bottom then
      if plus_minus == WincmdResizeDirection.bigger then
        vim.cmd(string.format("resize -%s", amount))
        next_window(DirectionKeys.down)
        vim.cmd(string.format("resize -%s", amount))
      else
        vim.cmd(string.format("resize +%s", amount))
        next_window(DirectionKeys.down)
        vim.cmd(string.format("resize +%s", amount))
      end
      return
    end

    if adjustment_plus_minus ~= nil then
      vim.cmd(string.format("resize %s%s", adjustment_plus_minus, amount))
      next_window(DirectionKeys.up)
      vim.cmd(string.format("resize %s%s", adjustment_plus_minus, amount))
      next_window(DirectionKeys.down)
    end
  else
    -- horizontally
    local plus_minus = compute_dir_horizontal(dir)
    local cur_win_pos = vim.api.nvim_win_get_position(0)
    vim.cmd(string.format("vertical resize %s%s", plus_minus, amount))
    if win_position(dir) ~= WinPosition.middle then return end

    local new_win_pos = vim.api.nvim_win_get_position(0)
    local adjustment_plus_minus
    if cur_win_pos[2] < new_win_pos[2] and plus_minus == WincmdResizeDirection.smaller then
      adjustment_plus_minus = WincmdResizeDirection.bigger
    elseif cur_win_pos[2] > new_win_pos[2] and plus_minus == WincmdResizeDirection.bigger then
      adjustment_plus_minus = WincmdResizeDirection.smaller
    end
    if adjustment_plus_minus ~= nil then
      vim.cmd(string.format("vertical resize %s%s", adjustment_plus_minus, amount))
      next_window(DirectionKeys.right)
      vim.cmd(string.format("vertical resize %s%s", adjustment_plus_minus, amount))
      next_window(DirectionKeys.left)
    end
  end
end

---@param dir Direction
---@param by integer?
local function resize_direction(dir, by) M.resize(dir, by or vim.v.count1 * M.amount) end

function M.resize_left(amount) resize_direction("left", amount) end

function M.resize_right(amount) resize_direction("right", amount) end

function M.resize_up(amount) resize_direction("up", amount) end

function M.resize_down(amount) resize_direction("down", amount) end

return M
