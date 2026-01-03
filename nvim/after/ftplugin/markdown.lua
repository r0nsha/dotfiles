local utils = require "utils"

local function toggle_checkbox()
  local line = vim.api.nvim_get_current_line()

  if line:match "^%s*%- %[ %]" then
    local new_line = line:gsub("%[ %]", "[x]")
    vim.api.nvim_set_current_line(new_line)
  elseif line:match "^%s*%- %[x%]" then
    local new_line = line:gsub("%[x%]", "[ ]")
    vim.api.nvim_set_current_line(new_line)
  end
end

local function toggle_checkboxes_visual()
  local start_line, end_line = utils.get_visual_range()
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)

  local checkbox_lines = {}
  local all_on = true
  local all_off = true

  for i, line in ipairs(lines) do
    if line:match "^%s*%- %[ %]" then
      all_on = false
      table.insert(checkbox_lines, i)
    elseif line:match "^%s*%- %[x%]" then
      all_off = false
      table.insert(checkbox_lines, i)
    end
  end

  -- early return
  if #checkbox_lines == 0 then
    return
  end

  -- decide target
  local turn_on
  if all_off then
    turn_on = true
  elseif all_on then
    turn_on = false
  else
    turn_on = true
  end

  for _, i in ipairs(checkbox_lines) do
    if turn_on then
      lines[i] = lines[i]:gsub("%[ %]", "[x]")
    else
      lines[i] = lines[i]:gsub("%[x%]", "[ ]")
    end
  end

  vim.api.nvim_buf_set_lines(0, start_line, end_line + 1, false, lines)
end

vim.keymap.set("n", "<C-x>", toggle_checkbox, { desc = "Toggle checkbox" })
vim.keymap.set("x", "<C-x>", toggle_checkboxes_visual, { desc = "Toggle checkbox" })
