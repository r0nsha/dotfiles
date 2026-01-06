local pick = require "mini.pick"
local extra = require "mini.extra"

-- taken directly from mini/pick.lua:2282
local has_tabline = vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
local has_statusline = vim.o.laststatus > 0
local max_height = vim.o.lines - vim.o.cmdheight - (has_tabline and 1 or 0) - (has_statusline and 1 or 0)
---@param mul number
---@return number
local function height(mul)
  return math.floor(mul * max_height)
end

local function show_with_icons(buf_id, items, query)
  pick.default_show(buf_id, items, query, { show_icons = true })
end

pick.setup {
  delay = { async = 10, busy = 30 },
  mappings = {
    choose = "<C-y>",
    choose_marked = "<C-S-Y>",
    mark = "<C-x>",
    mark_all = "<C-S-X>",
    scroll_down = "<C-d>",
    scroll_up = "<C-u>",
    toggle_info = "<S-Tab>",
    toggle_preview = "<Tab>",

    send_to_qflist = {
      char = "<C-q>",
      func = function()
        local list = {}
        local matches = pick.get_picker_matches().all

        for _, match in ipairs(matches) do
          if type(match) == "table" then
            table.insert(list, match)
          else
            local path, lnum, col, search = string.match(match, "(.-)%z(%d+)%z(%d+)%z%s*(.+)")
            local text = path and string.format("%s [%s:%s]  %s", path, lnum, col, search)
            local filename = path or vim.trim(match):match "%s+(.+)"

            table.insert(list, {
              filename = filename or match,
              lnum = lnum or 1,
              col = col or 1,
              text = text or match,
            })
          end
        end

        vim.fn.setqflist(list, "r")
        require("quicker").open()
        pick.stop()
      end,
    },
  },
  options = {
    content_from_bottom = true,
  },
  window = {
    config = { width = vim.o.columns, height = height(0.4) },
  },
}

vim.ui.select = function(items, opts, on_choice)
  local start_opts = { window = { config = { width = vim.o.columns, height = height(0.3) } } }
  return MiniPick.ui_select(items, opts, on_choice, start_opts)
end

pick.registry.registry = function()
  local items = vim.tbl_keys(pick.registry)
  table.sort(items)
  local source = { items = items, name = "Registry", choose = function() end }
  local chosen_picker_name = pick.start { source = source }
  if chosen_picker_name == nil then
    return
  end
  return pick.registry[chosen_picker_name]()
end

vim.keymap.set("n", "<leader>s.", pick.registry.registry, { desc = "Pickers" })

vim.keymap.set("n", "<leader><leader>", pick.builtin.resume, { desc = "Resume Last Picker" })

vim.keymap.set("n", "<leader>sf", function()
  pick.builtin.cli(
    { command = { "rg", "--files", "--color=never", "--hidden", "--ignore" } },
    { source = { name = "Files (fd)", show = show_with_icons } }
  )
end, { desc = "Files" })

vim.keymap.set("n", "<leader>sF", function()
  pick.builtin.cli(
    { command = { "rg", "--files", "--color=never", "--hidden", "--no-ignore" } },
    { source = { name = "Files (fd)", show = show_with_icons } }
  )
end, { desc = "All Files" })

vim.keymap.set("n", "<leader>ss", function()
  pick.builtin.grep_live()
end, { desc = "Grep" })

-- vim.keymap.set("n", "<leader>sS", function()
--   Snacks.picker.grep {
--     ignored = true,
--   }
-- end, { desc = "Grep (don't respect .gitignore)" })
--
-- vim.keymap.set("x", "<leader>ss", function()
--   Snacks.picker.grep_word()
-- end, { desc = "Grep Selection" })
--
-- vim.keymap.set({ "n", "x" }, "<leader>sw", function()
--   Snacks.picker.grep_word()
-- end, { desc = "Grep Word" })
--
-- vim.keymap.set("n", "<leader>sc", function()
--   Snacks.picker.colorschemes()
-- end, { desc = "Colorschemes" })
--
-- vim.keymap.set("n", "<leader>sh", function()
--   Snacks.picker.help()
-- end, { desc = "Helptags" })
--
-- vim.keymap.set("n", "<leader>sH", function()
--   Snacks.picker.highlights()
-- end, { desc = "Highlights" })
--
-- vim.keymap.set("n", "<leader>so", function()
--   Snacks.picker.recent()
-- end, { desc = "Recent Files" })
--
-- vim.keymap.set("n", "<leader>sb", function()
--   Snacks.picker.buffers()
-- end, { desc = "Buffers" })
--
-- vim.keymap.set("n", "<leader>sp", function()
--   Snacks.picker.files {
--     title = "Plugins ",
--     dirs = { vim.fn.stdpath "data" .. "/site/pack/core/opt" },
--     cmd = "fd",
--     args = { "-td", "--exact-depth", "1" },
--     confirm = function(picker, item, action)
--       picker:close()
--       if item and item.file then
--         vim.schedule(function()
--           local where = action and action.name or "confirm"
--           if where == "edit_vsplit" then
--             vim.cmd("vsplit | lcd " .. item.file)
--           elseif where == "edit_split" then
--             vim.cmd("split | lcd " .. item.file)
--           else
--             vim.cmd("tabnew | tcd " .. item.file)
--           end
--
--           vim.cmd("ex " .. item.file)
--         end)
--       end
--     end,
--   }
-- end, { desc = "Plugins" })
--
-- vim.keymap.set("n", "<leader>sm", function()
--   Snacks.picker.man()
-- end, { desc = "Man Pages" })
--
-- vim.keymap.set("n", "<leader>sn", function()
--   Snacks.picker.notifications()
-- end, { desc = "Notifications" })
--
-- vim.keymap.set("n", "<leader>si", function()
--   Snacks.picker.icons()
-- end, { desc = "Search Icons" })
