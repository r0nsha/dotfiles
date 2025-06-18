local M = {
  "folke/snacks.nvim",
  opts = {
    picker = {
      prompt = " ",
      layout = {
        cycle = true,
        preset = function()
          return vim.o.columns >= 120 and "ivy" or "ivy_split"
        end,
      },
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
        Snacks.picker.projects()
      end,
      desc = "Projects",
    },
    {
      "<leader>sP",
      function()
        Snacks.picker.picker_layouts()
      end,
      desc = "Picker Layouts",
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
  },
}

---@type snacks.layout.Box
M.ivy_cursor = {
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
}

return M
