---@type snacks.picker.Config
local picker_opts = {
  pattern = "",
  search = "",
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

local M = {
  "folke/snacks.nvim",
  config = function()
    local github_url_patterns = {
      branch = "/tree/{branch}",
      file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
      permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
      commit = "/commit/{commit}",
    }

    require("snacks").setup {
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
      },
      scratch = {
        win = {
          border = "single",
          relative = "editor",
        },
      },
    }

    -- gitbrowse
    vim.keymap.set({ "n", "v" }, "<leader>go", function()
      Snacks.gitbrowse()
    end, { desc = "Git: Browse" })

    -- scratch
    vim.keymap.set("n", "<leader>.", function()
      Snacks.scratch()
    end, { desc = "Toggle Scratch Buffer" })

    vim.keymap.set("n", "<leader>,", function()
      Snacks.scratch.select()
    end, { desc = "Select Scratch Buffer" })

    -- bufdelete
    vim.keymap.set("n", "<leader>bd", function()
      Snacks.bufdelete()
    end, { desc = "Buffer: Delete" })

    vim.keymap.set("n", "<leader>bD", function()
      Snacks.bufdelete.other()
    end, { desc = "Buffer: Delete Other" })

    -- picker

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        silent = false,
        remap = false,
        desc = desc,
      })
    end

    map("n", "<leader><leader>", function()
      Snacks.picker.smart(picker_opts)
    end, "Find Files (Smart)")

    map("n", "<leader>sf", function()
      Snacks.picker.files(picker_opts)
    end, "Find Files")

    map("n", "<leader>sF", function()
      Snacks.picker.git_files(picker_opts)
    end, "Git Files")

    map("n", "<leader>ss", function()
      Snacks.picker.grep(picker_opts)
    end, "Grep")

    map("n", "<leader>sS", function()
      Snacks.picker.git_grep(picker_opts)
    end, "Grep Git")

    map("v", "<leader>ss", function()
      Snacks.picker.grep_word(picker_opts)
    end, "Grep Selection")

    map("n", "<leader>sw", function()
      Snacks.picker.grep_word(picker_opts)
    end, "Grep Word")

    map("n", "<leader>sc", function()
      Snacks.picker.colorschemes(picker_opts)
    end, "Colorschemes")

    map("n", "<leader>sh", function()
      Snacks.picker.help(picker_opts)
    end, "Helptags")

    map("n", "<leader>sH", function()
      Snacks.picker.highlights(picker_opts)
    end, "Highlights")

    map("n", "<leader>sr", function()
      Snacks.picker.resume()
    end, "Resume Last Picker")

    map("n", "<leader>so", function()
      Snacks.picker.recent(picker_opts)
    end, "Recent Files")

    map("n", "<leader>sb", function()
      Snacks.picker.buffers(picker_opts)
    end, "Buffers")

    map("n", "<leader>sp", function()
      Snacks.picker.projects(picker_opts)
    end, "Projects")

    map("n", "<leader>sP", function()
      Snacks.picker.picker_layouts(picker_opts)
    end, "Picker Layouts")

    map("n", "<leader>sm", function()
      Snacks.picker.man(picker_opts)
    end, "Man Pages")

    map("n", "<leader>si", function()
      Snacks.picker.icons(picker_opts)
    end, "Search Icons")
  end,
}

M.picker_opts = picker_opts

return M
