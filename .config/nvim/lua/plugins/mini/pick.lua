local MiniExtra = require("mini.extra")
local MiniIcons = require("mini.icons")
local MiniPick = require("mini.pick")

---@return string? query_str
---@return integer? caret
local function get_query_str_and_caret()
  local state = MiniPick.get_picker_state()
  local query = MiniPick.get_picker_query()
  if not state or not query then return nil end
  return table.concat(query), state.caret --[[@as integer]]
end

local move_caret = function(next_caret)
  local state = MiniPick.get_picker_state()
  local query = MiniPick.get_picker_query()
  if not state or not query then return end
  local caret = state.caret --[[@as integer]]
  next_caret = math.max(1, math.min(next_caret, #query + 1))
  local move = next_caret - caret
  vim.api.nvim_input(string.rep(move >= 0 and "<Right>" or "<Left>", math.abs(move) or 1))
end

-- NOTE: ((not keyword and not space)+ OR keyword+)space*$
local prev_word_regex = vim.regex([=[\([^[:keyword:][:space:]]\+\|\k\+\)\s*$]=])

-- NOTE: ^((not keyword and not space)+ OR keyword+)space*
local next_word_regex = vim.regex([=[^\([^[:keyword:][:space:]]\+\|\k\+\)\s*]=])

MiniPick.setup({
  mappings = {
    choose_all_in_quickfix = {
      char = "<C-q>",
      func = function()
        local matches = MiniPick.get_picker_matches() or {}
        MiniPick.default_choose_marked(matches.all or {})
        return true
      end,
    },
    prev_word = {
      char = "<C-h>",
      func = function()
        local query_str, caret = get_query_str_and_caret()
        if not query_str or not caret then return end
        local from, _ = prev_word_regex:match_str(string.sub(query_str, 1, caret - 1))
        move_caret(from and from + 1 or 1)
      end,
    },
    next_word = {
      char = "<C-l>",
      func = function()
        local query_str, caret = get_query_str_and_caret()
        if not query_str or not caret then return end
        local _, to = next_word_regex:match_str(string.sub(query_str, caret))
        move_caret(to and to + caret or #query_str + 1)
      end,
    },
    scroll_left = "<C-Left>",
    scroll_right = "<C-Right>",
  },
  -- ivy layout
  window = {
    config = function()
      local has_tabline = vim.o.showtabline == 2
        or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
      local max_height = vim.o.lines
        - vim.o.cmdheight
        - (has_tabline and 1 or 0)
        - (vim.o.laststatus > 0 and 1 or 0)
      return {
        width = vim.o.columns,
        height = math.max(1, math.floor(0.4 * max_height)),
        border = { "", "─", "", "", "", " ", "", "" },
      }
    end,
  },
})

---@type string?
local fff_current_file = nil

---@param query string?
---@return FileItem[]
local function fff_files(query)
  local res = require("fff").file_search(query or "", {
    mode = "files",
    max_results = 200,
    max_threads = 4,
    current_file = fff_current_file,
    cwd = vim.fn.getcwd(),
  })

  local items = {}
  for _, item in ipairs(res.items or {}) do
    item.path = item.relative_path
    item.text = item.relative_path
    items[#items + 1] = item
  end
  ---@cast items FileItem[]
  return items
end

---@alias GrepMode "regex"|"fuzzy"
---@alias FffGrepItem FileItem & { text: string, lnum: integer, col: integer, line_content: string }

---@type table<GrepMode, GrepMode>
local fff_next_grep_mode = { fuzzy = "regex", regex = "fuzzy" }

---@type GrepMode
local fff_grep_mode = "fuzzy"

---@param query string?
---@return FffGrepItem[]
local function fff_grep(query)
  if not query or query == "" then return {} end

  local res = require("fff").content_search(query, {
    mode = fff_grep_mode,
    smart_case = true,
    page_size = 200,
    cwd = vim.fn.getcwd(),
  })

  if res.regex_fallback_error then
    vim.schedule(
      function() vim.notify("FFF regex error: " .. res.regex_fallback_error, vim.log.levels.WARN) end
    )
  end

  local items = {}
  for _, m in ipairs(res.items or {}) do
    m.path = m.relative_path
    m.lnum = m.line_number
    m.col = (m.col or 0) + 1
    m.text = string.format("%s:%d:%d: %s", m.relative_path, m.lnum, m.col, m.line_content or "")
    items[#items + 1] = m
  end
  return items
end

local fff_ns = vim.api.nvim_create_namespace("MiniPick FFF")

---@param buf_id integer
---@param items FffGrepItem[]
local function show_fff_grep(buf_id, items)
  local lines, prefixes, icon_hls = {}, {}, {}
  for i, item in ipairs(items) do
    local icon, icon_hl = MiniIcons.get("file", item.relative_path)
    prefixes[i] = icon .. " "
    icon_hls[i] = icon_hl
    lines[i] = prefixes[i] .. item.text
  end

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(buf_id, fff_ns, 0, -1)

  for i, item in ipairs(items) do
    local prefix_len = #prefixes[i]
    vim.api.nvim_buf_set_extmark(buf_id, fff_ns, i - 1, 0, {
      end_row = i - 1,
      end_col = prefix_len,
      hl_group = icon_hls[i],
      hl_mode = "combine",
      priority = 200,
    })

    local content_start = prefix_len + #item.text - #(item.line_content or "")
    for _, range in ipairs(item.match_ranges or {}) do
      vim.api.nvim_buf_set_extmark(buf_id, fff_ns, i - 1, content_start + range[1], {
        end_row = i - 1,
        end_col = content_start + range[2],
        hl_group = "MiniPickMatchRanges",
        hl_mode = "combine",
        priority = 200,
      })
    end
  end
end

---@param fetch fun(query: string): FileItem[]
---@return fun(_stritems: string[], _inds: integer[], query: string[])
local function make_fff_match(fetch)
  return function(_, _, query)
    MiniPick.set_picker_items(fetch(table.concat(query)), { do_match = false })
  end
end

local match_fff_files = make_fff_match(fff_files)
local match_fff_grep = make_fff_match(fff_grep)

local function pick_fff_files()
  local name = vim.api.nvim_buf_get_name(0)
  fff_current_file = name ~= "" and vim.fs.relpath(name, vim.fn.getcwd()) or nil

  MiniPick.start({
    source = {
      name = "Files",
      cwd = vim.fn.getcwd(),
      items = fff_files,
      match = match_fff_files,
      show = function(buf_id, items, query)
        MiniPick.default_show(buf_id, items, query, { show_icons = true })
      end,
    },
  })
end

---@param query string?
local function pick_fff_grep(query)
  fff_grep_mode = "fuzzy"

  local function get_name() return string.format("Grep (%s)", fff_grep_mode) end

  if query and #query > 0 then
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniPickStart",
      once = true,
      callback = function() MiniPick.set_picker_query(vim.fn.split(query, "\\zs")) end,
    })
  end

  MiniPick.start({
    source = {
      name = get_name(),
      cwd = vim.fn.getcwd(),
      items = {},
      match = match_fff_grep,
      show = show_fff_grep,
    },
    mappings = {
      switch_grep_mode = {
        char = "<C-e>",
        func = function()
          fff_grep_mode = fff_next_grep_mode[fff_grep_mode]
          MiniPick.set_picker_opts({ source = { name = get_name() } })
          MiniPick.set_picker_query(MiniPick.get_picker_query() or {})
          return false
        end,
      },
    },
  })
end

MiniPick.registry.fffiles = pick_fff_files
MiniPick.registry.ffgrep = pick_fff_grep

local function pick_plugins()
  local opt_dir = vim.fn.stdpath("data") .. "/site/pack/core/opt"

  ---@param dir string?
  ---@param where "tabnew"|"split"|"vsplit"
  local function open(dir, where)
    if dir == nil then return end
    local cd = where == "tabnew" and vim.cmd.tcd or vim.cmd.lcd
    if where == "vsplit" then
      vim.cmd.vsplit()
    elseif where == "split" then
      vim.cmd.split()
    else
      vim.cmd.tabnew()
    end
    cd(dir)
  end

  ---@return string? Absolute path of the current picker item
  local function current_dir()
    local matches = MiniPick.get_picker_matches()
    local item = matches and matches.current
    return type(item) == "table" and item.path or nil
  end

  MiniPick.start({
    source = {
      name = "Plugins",
      items = function()
        local items = {}
        for _, path in ipairs(vim.fn.glob(opt_dir .. "/*", true, true)) do
          if vim.fn.isdirectory(path) == 1 then
            items[#items + 1] = { path = path, text = vim.fn.fnamemodify(path, ":t") }
          end
        end
        table.sort(items, function(a, b) return a.text < b.text end)
        return items
      end,
      choose = function(item)
        if item and item.path then vim.schedule(function() open(item.path, "tabnew") end) end
      end,
      show = function(buf_id, items, query)
        MiniPick.default_show(buf_id, items, query, { show_icons = true })
      end,
    },
    mappings = {
      choose_in_split = "",
      choose_in_vsplit = "",
      choose_in_tabpage = "",
      custom_open_split = {
        char = "<C-s>",
        func = function()
          local dir = current_dir()
          if not dir then return end
          vim.schedule(function() open(dir, "split") end)
          return true
        end,
      },
      custom_open_vsplit = {
        char = "<C-v>",
        func = function()
          local dir = current_dir()
          if not dir then return end
          vim.schedule(function() open(dir, "vsplit") end)
          return true
        end,
      },
    },
  })
end

MiniPick.registry.plugins = pick_plugins

vim.keymap.set("n", "<leader><leader>", MiniPick.builtin.resume, { desc = "Resume last picker" })
vim.keymap.set("n", "<leader>sf", pick_fff_files, { desc = "Files" })
vim.keymap.set("n", "<leader>ss", pick_fff_grep, { desc = "Grep" })
vim.keymap.set("x", "<leader>ss", function()
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
  pick_fff_grep(table.concat(lines, " "))
end, { desc = "Grep selection" })
vim.keymap.set("n", "<leader>sw", function()
  pick_fff_grep(vim.fn.expand("<cword>") --[[@as string?]])
end, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>sb", function()
  MiniPick.builtin.buffers({}, {
    mappings = {
      mark = "",
      wipeout = {
        char = "<C-x>",
        func = function()
          local matches = MiniPick.get_picker_matches()
          if not matches or matches.current == nil then return end
          local bufnr = matches.current.bufnr
          vim.api.nvim_buf_delete(bufnr, {})
          MiniPick.set_picker_items(
            vim.tbl_filter(
              function(item) return item.bufnr ~= bufnr end,
              MiniPick.get_picker_items() or {}
            )
          )
          return false
        end,
      },
    },
  })
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>sh", MiniPick.builtin.help, { desc = "Help tags" })
vim.keymap.set("n", "<leader>sH", MiniExtra.pickers.hl_groups, { desc = "Highlight groups" })
vim.keymap.set("n", "<leader>sc", MiniExtra.pickers.colorschemes, { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>so", MiniExtra.pickers.oldfiles, { desc = "Oldfiles" })
vim.keymap.set("n", "<leader>sm", MiniExtra.pickers.manpages, { desc = "Man pages" })
vim.keymap.set("n", "<leader>sp", pick_plugins, { desc = "Plugins" })
