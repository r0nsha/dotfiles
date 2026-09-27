local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")

---@return boolean
local function has_mcursors() return #vim.api.nvim_buf_get_extmarks(0, mc_ns, 0, -1) > 0 end

vim.keymap.set("n", "<Esc>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd.nohlsearch()
    return
  end

  if has_mcursors() then
    vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
    return ""
  end

  return "<Esc>"
end, { expr = true })

---@param dir "next" | "prev"
---@return string?
local function rotate_cursor(dir)
  if not has_mcursors() then return nil end
  return (dir == "next" and "]" or "[") .. "C"
end

vim.keymap.set(
  "n",
  "(",
  function() return rotate_cursor("prev") or "(" end,
  { expr = true, desc = "Previous cursor" }
)
vim.keymap.set(
  "n",
  ")",
  function() return rotate_cursor("next") or ")" end,
  { expr = true, desc = "Next cursor" }
)

vim.keymap.set(
  "n",
  "<Left>",
  function() return rotate_cursor("prev") or "<Left>" end,
  { expr = true, desc = "Previous cursor" }
)
vim.keymap.set(
  "n",
  "<Right>",
  function() return rotate_cursor("next") or "<Right>" end,
  { expr = true, desc = "Next cursor" }
)

vim.keymap.set({ "n", "x" }, "<C-q>", "q=", { desc = "Toggle follow-mode" })

vim.keymap.set("n", "<Up>", "Qk1q=", { desc = "Add cursor above" })
vim.keymap.set("n", "<Down>", "Qj1q=", { desc = "Add cursor below" })

---@param backwards boolean?
local function cursor_add_match_normal(backwards)
  local char =
    vim.fn.strcharpart(vim.api.nvim_get_current_line(), vim.api.nvim_win_get_cursor(0)[2], 1)
  if char == "" then return end

  local pattern = vim.fn.match(char, "\\k") == 0 and ("\\V\\<" .. vim.fn.expand("<cword>") .. "\\>")
    or ("\\V" .. vim.fn.escape(char, "\\"))

  local row, col = unpack(vim.fn.searchpos(pattern, "bcnW"))
  vim.api.nvim_mcursor(0, { row, col - 1 })
  vim.fn.setreg("/", pattern)
  vim.fn.search(pattern, backwards and "b" or "")
end

vim.keymap.set("n", "<C-n>", cursor_add_match_normal, { desc = "Add cursor match next" })
vim.keymap.set(
  "n",
  "<C-S-N>",
  function() cursor_add_match_normal(true) end,
  { desc = "Add cursor match previous" }
)

-- Move primary cursor to the mcursor nearest to its position
local function set_cursor_to_nearest_mcursor()
  local origin = vim.api.nvim_win_get_cursor(0)
  local origin_row, origin_col = origin[1] - 1, origin[2]

  ---@param a vim.api.keyset.get_extmark_item
  ---@param b vim.api.keyset.get_extmark_item
  ---@return boolean
  local function closer(a, b)
    local a_row, a_col = math.abs(a[2] - origin_row), math.abs(a[3] - origin_col)
    local b_row, b_col = math.abs(b[2] - origin_row), math.abs(b[3] - origin_col)
    return a_row < b_row or (a_row == b_row and a_col < b_col)
  end

  ---@type vim.api.keyset.get_extmark_item?
  local nearest = vim.iter(vim.api.nvim_buf_get_extmarks(0, mc_ns, 0, -1)):fold(
    nil,
    ---@param best vim.api.keyset.get_extmark_item?
    ---@param mark vim.api.keyset.get_extmark_item
    ---@return vim.api.keyset.get_extmark_item
    function(best, mark)
      if best == nil or closer(mark, best) then return mark end
      return best
    end
  )

  if nearest then
    local id, row, col = unpack(nearest)
    vim.api.nvim_buf_del_extmark(0, mc_ns, id) -- avoids mcursor behind primary cursor
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
  end
end

---@param pattern string
local function cursor_place_search_matches(pattern)
  if pattern ~= "" then vim.fn.setreg("/", pattern) end
  vim.cmd.nohlsearch()
  vim.cmd("normal! 1Q1q=") -- Place cursor at every match and enable follow-mode
  set_cursor_to_nearest_mcursor()
end

vim.keymap.set("c", "<C-q>", function()
  local ctype = vim.fn.getcmdtype()
  if ctype ~= "/" and ctype ~= "?" then return "<C-q>" end

  local pattern = vim.fn.getcmdline()
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  vim.schedule(function() cursor_place_search_matches(pattern) end)
  return ""
end, { expr = true, desc = "Place cursor at every search match" })

vim.keymap.set("n", "mn", function()
  cursor_place_search_matches(vim.fn.getreg("/") --[[@as string]])
end, { desc = "Place cursor at every search match" })

vim.keymap.set(
  "n",
  "mm",
  function() cursor_place_search_matches("\\V\\<" .. vim.fn.expand("<cword>") .. "\\>") end,
  { desc = "Place cursor at every search match" }
)

vim.keymap.set("x", "m", function()
  vim.ui.input({ prompt = "pattern", scope = "cursor" }, function(input)
    if not input then return end
    input = vim.trim(input)
    if input == "" then return end
    vim.schedule(function() cursor_place_search_matches(input) end)
  end)
end, { desc = "Place cursor at every search match" })

vim.keymap.set("x", "M", function()
  local region =
    vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = "v", exclusive = false })
  local text = table.concat(region, "\n")
  if text == "" then return end
  local escaped = vim.fn.escape(text, [[\/]]):gsub("\n", "\\n")
  local pattern = text:match("^[%w_]+$") and ("\\V\\<" .. escaped .. "\\>") or ("\\V" .. escaped)
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  vim.schedule(function() cursor_place_search_matches(pattern) end)
end, { desc = "Place cursor at every visual selection match" })

---@param pos "start" | "end"
local function cursor_add_at_visual_sel(pos)
  local is_start = pos == "start"
  local place = vim.api.nvim_win_get_cursor(0)[1]
  local l1, l2 = math.min(vim.fn.line("v"), place), math.max(vim.fn.line("v"), place)

  local col
  local mode = vim.api.nvim_get_mode().mode
  local linewise, blockwise = mode == "V", mode == "\22"
  if linewise then
    col = is_start and 0 or 0x7fffffff
  else
    local c1, c2 = vim.fn.col("v"), vim.api.nvim_win_get_cursor(0)[2] + 1
    col = is_start and math.min(c1, c2) - 1 or math.max(c1, c2)
  end

  vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  vim.schedule(function()
    for l = l1, l2 do
      if
        l ~= place and not (blockwise and vim.api.nvim_buf_get_lines(0, l - 1, l, false)[1] == "")
      then
        vim.api.nvim_mcursor(0, { l, col })
      end
    end
    vim.api.nvim_win_set_cursor(0, { place, col })
    vim.schedule(
      function() vim.api.nvim_feedkeys("1q=" .. (is_start and "i" or "a"), "n", false) end
    )
  end)
end

vim.keymap.set(
  "x",
  "I",
  function() cursor_add_at_visual_sel("start") end,
  { desc = "Place cursor at start of visual selection" }
)

vim.keymap.set(
  "x",
  "A",
  function() cursor_add_at_visual_sel("end") end,
  { desc = "Place cursor at end of visual selection" }
)
