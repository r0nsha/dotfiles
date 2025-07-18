local icons = require("config.icons")

---@param layout snacks.picker.layout.Config
local function override_layout_wo(layout)
  local input = vim.tbl_filter(
    function(item)
      return type(item) == "table" and item.win == "input"
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    layout.layout
  )[1]

  if input then
    input.wo = {
      winhighlight = "NormalFloat:SnacksPickerInput,FloatBorder:SnacksPickerInputBorder,FloatTitle:SnacksPickerInputTitle,FloatFooter:SnacksPickerInputFooter,CursorLine:SnacksPickerInputCursorLine,LineNr:SnacksPickerInput",
    }
  end
  return layout
end

local M = {
  "folke/snacks.nvim",
  opts = {
    picker = {
      prompt = " ",
      layout = function()
        local layouts = require("snacks.picker.config.layouts")
        local ivy = override_layout_wo(layouts.ivy)
        local ivy_split = override_layout_wo(layouts.ivy_split)

        return vim.o.columns >= 120 and ivy or ivy_split
      end,
      win = {
        input = {
          keys = {
            ["<C-y>"] = { "confirm", mode = { "n", "i" } },
            ["<C-b>"] = { "list_scroll_up", mode = { "i", "n" } },
            ["<C-f>"] = { "list_scroll_down", mode = { "i", "n" } },
            ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<C-g>"] = { "yank", mode = { "n", "i" } },
            ["<C-l>"] = { "toggle_live", mode = { "n", "i" } },
            ["<C-c>"] = { "close", mode = { "i" } },
            ["<Esc>"] = "close",
            ["q"] = "close",
          },
        },
        list = {
          keys = {
            ["<Esc>"] = "close",
            ["q"] = "close",
          },
        },
      },
      layouts = {
        select = {
          preview = false,
          layout = {
            backdrop = false,
            width = 0.5,
            min_width = 80,
            height = 0.4,
            min_height = 3,
            box = "vertical",
            border = "single",
            title = "{title}",
            title_pos = "center",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
            { win = "preview", title = "{preview}", height = 0.4, border = "top" },
          },
        },
      },
      formatters = {
        file = {
          filename_first = true,
        },
      },
      icons = {
        Error = icons.error,
        Warn = icons.warn,
        Info = icons.info,
        Hint = icons.hint,
      },
      jump = {
        reuse_win = true,
      },
      matcher = {
        cwd_bonus = true,
        frecency = true,
        history_bonus = true,
      },
      sources = {
        files = {
          hidden = true,
        },
      },
    },
  },
  keys = {
    {
      "<leader><leader>",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume Last Picker",
    },
    {
      "<leader>sf",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>sr",
      function()
        Snacks.picker.smart()
      end,
      desc = "Find Files (Smart)",
    },
    {
      "<leader>sF",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Git Files",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>sS",
      function()
        Snacks.picker.git_grep()
      end,
      desc = "Grep Git",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Grep Selection",
      mode = "v",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Grep Word",
      mode = { "n", "v" },
    },
    {
      "<leader>sc",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Helptags",
    },
    {
      "<leader>sH",
      function()
        Snacks.picker.highlights()
      end,
      desc = "Highlights",
    },
    {
      "<leader>so",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>sp",
      function()
        Snacks.picker.files({
          dirs = { vim.fn.stdpath("data") .. "/lazy" },
          cmd = "fd",
          args = { "-td", "--exact-depth", "1" },
          confirm = function(picker, item, action)
            picker:close()
            if item and item.file then
              vim.schedule(function()
                local where = action and action.name or "confirm"
                if where == "edit_vsplit" then
                  vim.cmd("vsplit | lcd " .. item.file)
                elseif where == "edit_split" then
                  vim.cmd("split | lcd " .. item.file)
                else
                  vim.cmd("tabnew | tcd " .. item.file)
                end
              end)
            end
          end,
        })
      end,
      desc = "Plugins",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.man()
      end,
      desc = "Man Pages",
    },
    {
      "<leader>si",
      function()
        Snacks.picker.icons()
      end,
      desc = "Search Icons",
    },
    {
      "<leader>s.",
      function()
        Snacks.picker()
      end,
      desc = "Search pickers",
    },
  },
}

---@type snacks.layout.Box
M.ivy_cursor = override_layout_wo({
  layout = {
    box = "vertical",
    backdrop = false,
    row = 1,
    width = 0,
    height = 0.4,
    border = "top",
    title = " {title} {live} {flags}",
    title_pos = "left",
    position = "float",
    relative = "cursor",
    { win = "input", height = 1, border = "bottom" },
    {
      box = "horizontal",
      { win = "list", border = "none" },
      { win = "preview", title = "{preview}", width = 0.6, border = "left" },
      border = "bottom",
    },
  },
})

return M
