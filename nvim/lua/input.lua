---@class input.Config
---@field prompt string
---@field default string
---@field padding integer
---@field max_width integer
---@field max_height integer
---@field win vim.api.keyset.win_config

local M = {}

local augroup = vim.api.nvim_create_augroup("WrapInput", { clear = true })

local default_prompt = "Input: "

---@type input.Config
local defaults = {
  prompt = default_prompt,
  default = "",
  padding = 10,
  max_width = 50,
  max_height = 8,
  win = {
    title = default_prompt,
    style = "minimal",
    focusable = true,
    relative = "cursor",
    col = 0,
    height = 1,
  },
}

---@return vim.api.keyset.win_config
local function get_relative_win_config()
  local curr_win = vim.api.nvim_get_current_win()
  local cursor_row = vim.api.nvim_win_get_cursor(curr_win)[1]
  if cursor_row == 1 then
    return { anchor = "NW", row = 1 }
  else
    return { anchor = "SW", row = 0 }
  end
end

---@param s string
---@param len integer
---@return string[]
local function split_string_by_len(s, len)
  local subs = {}
  for i = 1, #s, len do
    table.insert(subs, s:sub(i, i + len - 1))
  end
  return subs
end

---@param winnr integer
---@param bufnr integer
---@param config input.Config
local function setup_autocmds(winnr, bufnr, config)
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]

      if line == "" then
        vim.api.nvim_win_set_width(winnr, config.padding)
        vim.api.nvim_win_set_height(winnr, 1)
        return
      end

      local lines = split_string_by_len(line, config.max_width)
      local lens = vim.tbl_map(function(l)
        return vim.fn.strdisplaywidth(l)
      end, lines)

      local width = math.max(unpack(lens)) + config.padding
      width = width > config.max_width and config.max_width or width
      vim.api.nvim_win_set_width(winnr, width + 1)

      local height = #lines
      height = height > config.max_height and config.max_height or height
      vim.api.nvim_win_set_height(winnr, height)
    end,
  })
end

---@param config input.Config
---@param on_confirm fun(input: string?)
function M.input(config, on_confirm)
  config = vim.tbl_deep_extend("force", defaults, config)

  -- Calculate a minimal width with a bit of buffer
  local default_width = vim.str_utfindex(config.default, "utf-8") + config.padding
  local prompt_width = vim.str_utfindex(config.prompt, "utf-8") + config.padding
  local width = default_width > prompt_width and default_width or prompt_width
  width = width > config.max_width and config.max_width or width

  local relative_win_config = get_relative_win_config()
  config = vim.tbl_deep_extend("keep", config, { win = relative_win_config }, { win = { width = width } })

  on_confirm = on_confirm or function() end

  -- Create buffer and floating window.
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("buftype", "prompt", { buf = bufnr })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
  vim.fn.prompt_setprompt(bufnr, "")

  local winnr = vim.api.nvim_open_win(bufnr, true, config.win)
  vim.api.nvim_set_option_value("wrap", true, { win = winnr })
  vim.api.nvim_set_option_value("linebreak", true, { win = winnr })

  -- Write default value
  vim.api.nvim_buf_set_text(bufnr, 0, 0, 0, 0, { config.default })

  -- Put cursor at the end of the default value
  vim.cmd "startinsert"
  vim.api.nvim_win_set_cursor(winnr, { 1, vim.str_utfindex(config.default, "utf-8") + 1 })

  -- Enter to confirm
  vim.keymap.set({ "n", "i", "v" }, "<cr>", function()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
    vim.cmd "stopinsert"
    vim.api.nvim_win_close(winnr, true)
    on_confirm(lines[1])
  end, { buffer = bufnr })

  -- Esc or q to close
  vim.keymap.set("n", "<esc>", function()
    vim.cmd "stopinsert"
    vim.api.nvim_win_close(winnr, true)
    on_confirm(nil)
  end, { buffer = bufnr })

  vim.keymap.set("n", "q", function()
    vim.cmd "stopinsert"
    vim.api.nvim_win_close(winnr, true)
    on_confirm(nil)
  end, { buffer = bufnr })

  setup_autocmds(winnr, bufnr, config)
end

vim.ui.input = function(opts, on_confirm)
  M.input(opts or {}, on_confirm)
end
