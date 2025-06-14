local icons = require("utils").icons

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
    notifier = {
      margin = { top = 0, right = 0, bottom = 1 },
      padding = false,
      icons = {
        error = icons.error,
        warn = icons.warning,
        info = icons.info,
        debug = icons.bug,
        trace = icons.trace,
      },
      style = function(buf, notif, ctx)
        ctx.opts.border = "none"
        local whl = ctx.opts.wo.winhighlight
        ctx.opts.wo.winhighlight = whl:gsub(ctx.hl.msg, "SnacksNotifierMinimal")
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg, "\n"))
        vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
          virt_text = { { " " .. notif.icon .. " ", ctx.hl.icon } },
          virt_text_pos = "right_align",
        })
      end,
      top_down = false,
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

-- Setup LSP progress notifications with Snacks.notifier
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "", "", "", "", "", "" }

    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and ""
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

return M
