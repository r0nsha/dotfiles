---@type snacks.picker.Config
local picker_opts = {
  win = {
    input = {
      keys = {
        ["<C-y>"] = { "confirm", mode = { "n", "i" } },
        ["<C-b>"] = { "list_scroll_up", mode = { "i", "n" } },
        ["<C-f>"] = { "list_scroll_down", mode = { "i", "n" } },
        ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
        ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
        ["<C-g>"] = { "yank", mode = { "n", "i" } },
        -- ["<C-l>"] = { "toggle_live", mode = { "n", "i" } },
      },
    },
  },
}

local github_url_patterns = {
  branch = "/tree/{branch}",
  file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
  permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
  commit = "/commit/{commit}",
}

local M = {
  "folke/snacks.nvim",
  opts = {
    gitbrowse = {
      -- override the default open function to copy the url to the clipboard
      open = function(url)
        vim.fn.setreg("+", url)
        vim.fn.setreg('"', url)

        if vim.fn.has "nvim-0.10" == 0 then
          require("lazy.util").open(url, { system = true })
          return
        end

        vim.ui.open(url)
      end,
      url_patterns = {
        ["git.soma.salesforce.com"] = github_url_patterns,
        ["gitcore.soma.salesforce.com"] = github_url_patterns,
      },
    },
    -- indent = {
    --   animate = {
    --     enabled = false,
    --   },
    -- },
    input = {
      icon = "",
      win = {
        border = "single",
        relative = "cursor",
        row = -3,
        col = -4,
        title_pos = "left",
      },
    },
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
    },
    scratch = {
      win = {
        border = "single",
        relative = "editor",
      },
    },
  },
  keys = {
    -- Gitbrowse
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git: Browse",
      mode = { "n", "v" },
    },

    -- Scratch
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>,",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },

    -- Bufdelete
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Buffer: Delete",
    },
    {
      "<leader>bD",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Buffer: Delete Other",
    },

    -- Picker
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
      "<leader>sm",
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

M.picker_opts = picker_opts

return M
