---@param follow boolean is follow-mode on?
local function update_mcursor_hl(follow)
  local bg = vim.api.nvim_get_hl(0, { name = "NorBg" }).bg
  if follow then
    vim.api.nvim_set_hl(
      0,
      "MCursor",
      { fg = bg, bg = vim.api.nvim_get_hl(0, { name = "NorOrangeFg" }).fg }
    )
  else
    vim.api.nvim_set_hl(
      0,
      "MCursor",
      { fg = bg, bg = vim.api.nvim_get_hl(0, { name = "NorFgDim" }).fg }
    )
  end
end

vim.opt.follow = true
update_mcursor_hl(vim.opt.follow)

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

vim.keymap.set({ "n", "x" }, ",", "zq")

---@param dir "next" | "prev"
---@return string?
local function rotate_cursor(dir)
  if not has_mcursors() then return nil end
  return (dir == "next" and "]" or "[") .. "C"
end

vim.keymap.set(
  { "n", "x" },
  "(",
  function() return rotate_cursor("prev") or "(" end,
  { expr = true, desc = "Previous cursor" }
)
vim.keymap.set(
  { "n", "x" },
  ")",
  function() return rotate_cursor("next") or ")" end,
  { expr = true, desc = "Next cursor" }
)

vim.keymap.set(
  { "n", "x" },
  "<Left>",
  function() return rotate_cursor("prev") or "<Left>" end,
  { expr = true, desc = "Previous cursor" }
)
vim.keymap.set(
  { "n", "x" },
  "<Right>",
  function() return rotate_cursor("next") or "<Right>" end,
  { expr = true, desc = "Next cursor" }
)

vim.keymap.set({ "n", "x" }, "<C-q>", "q=", { desc = "Toggle follow-mode" })

vim.keymap.set("n", "<Up>", "Qk", { desc = "Add cursor above" })
vim.keymap.set("n", "<Down>", "Qj", { desc = "Add cursor below" })

---@param backwards boolean?
local function cursor_add_match_normal(backwards)
  local char =
    vim.fn.strcharpart(vim.api.nvim_get_current_line(), vim.api.nvim_win_get_cursor(0)[2], 1)
  if char == "" then return end

  local pattern = vim.fn.match(char, "\\k") == 0 and ("\\V\\<" .. vim.fn.expand("<cword>") .. "\\>")
    or ("\\V" .. vim.fn.escape(char, "\\"))

  vim.cmd("normal! wb1Q")
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

---@param pattern string
local function cursor_place_search_matches(pattern)
  if pattern ~= "" then vim.fn.setreg("/", pattern) end
  vim.cmd.nohlsearch()
  vim.cmd("normal! zqgn")
end

vim.keymap.set("c", "<C-q>", function()
  local ctype = vim.fn.getcmdtype()
  if ctype ~= "/" and ctype ~= "?" then return "<C-q>" end

  local pattern = vim.fn.getcmdline()
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  vim.schedule(function() cursor_place_search_matches(pattern) end)
  return ""
end, { expr = true, desc = "Place cursor at every search match" })

vim.keymap.set("x", "<C-n>", function()
  local region =
    vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = "v", exclusive = false })
  local text = table.concat(region, "\n")
  if text == "" then return end
  local pattern = vim.fn.escape(text, [[\/]]):gsub("\n", "\\n")
  vim.api.nvim_feedkeys(vim.keycode(string.format("<Esc>zq/\\V%s<cr>gv", pattern)), "n", false)
end, { desc = "Place cursor at every visual selection match" })

---@param append boolean
---@return string
local function visual_edge_cursors(append)
  if vim.fn.mode() ~= "\22" then return append and "zqjA" or "zqjI" end
  local anchor, cursor = vim.fn.virtcol("v"), vim.fn.virtcol(".")
  local on_left_edge = cursor <= anchor
  local swap = append == on_left_edge
  return (swap and "o" or "") .. (append and "zqja" or "zqji")
end

vim.keymap.set("x", "I", function() return visual_edge_cursors(false) end, {
  expr = true,
  desc = "Place cursors at start of visual selection",
})
vim.keymap.set("x", "A", function() return visual_edge_cursors(true) end, {
  expr = true,
  desc = "Place cursors at end of visual selection",
})

vim.api.nvim_create_autocmd("OptionSet", {
  group = require("augroup"),
  desc = "Change MCursor highlight based on follow-mode",
  pattern = "follow",
  callback = function()
    local follow = vim.v.option_new --[[@type boolean]]
    update_mcursor_hl(follow)
  end,
})
