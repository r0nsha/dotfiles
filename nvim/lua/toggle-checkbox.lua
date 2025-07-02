local checked_character = "x"

local checked_checkbox = "%[" .. checked_character .. "%]"
local unchecked_checkbox = "%[ %]"

local line_contains_unchecked = function(line)
  return line:find(unchecked_checkbox)
end

local line_contains_checked = function(line)
  return line:find(checked_checkbox)
end

local line_with_checkbox = function(line)
  -- return not line_contains_a_checked_checkbox(line) and not line_contains_an_unchecked_checkbox(line)
  return line:find("^%s*- " .. checked_checkbox)
    or line:find("^%s*- " .. unchecked_checkbox)
    or line:find("^%s*%d%. " .. checked_checkbox)
    or line:find("^%s*%d%. " .. unchecked_checkbox)
end

---@param line string
local function check(line)
  return line:gsub(unchecked_checkbox, checked_checkbox, 1)
end

---@param line string
local function uncheck(line)
  return line:gsub(checked_checkbox, unchecked_checkbox, 1)
end

---@param line string
local function make_checkbox(line)
  if not line:match("^%s*-%s.*$") and not line:match("^%s*%d%s.*$") then
    -- "xxx" -> "- [ ] xxx"
    return line:gsub("(%S+)", "- [ ] %1", 1)
  else
    -- "- xxx" -> "- [ ] xxx", "3. xxx" -> "3. [ ] xxx"
    return line:gsub("(%s*- )(.*)", "%1[ ] %2", 1):gsub("(%s*%d%. )(.*)", "%1[ ] %2", 1)
  end
end

local function get_toggled_line(line)
  if line == "" then
    return ""
  end

  if not line_with_checkbox(line) then
    return make_checkbox(line)
  elseif line_contains_unchecked(line) then
    return check(line)
  elseif line_contains_checked(line) then
    return uncheck(line)
  else
    return ""
  end
end

local M = {}

function M.toggle()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)

  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  for linenr = start_line, end_line do
    local start, _end = linenr - 1, linenr
    local line = vim.api.nvim_buf_get_lines(bufnr, start, _end, false)[1] or ""
    local new_line = get_toggled_line(line)
    vim.api.nvim_buf_set_lines(bufnr, start, _end, false, { new_line })
  end

  vim.api.nvim_win_set_cursor(0, cursor)
end

vim.api.nvim_create_user_command("ToggleCheckbox", M.toggle, {})

return M
