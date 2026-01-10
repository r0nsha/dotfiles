function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    dir = vim.fn.fnamemodify(dir, ":~") -- relative to home
    dir = string.gsub(dir, "/$", "") -- remove trailing slash
    return dir
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

local oil = require("oil")

oil.setup({
  default_file_explorer = true,
  watch_for_changes = true,
  view_options = {
    show_hidden = false,
    is_always_hidden = function(name, _) return name == "." or name == ".." end,
  },
  win_options = {
    signcolumn = "yes",
    winbar = "%!v:lua.get_oil_winbar()",
  },
  skip_confirm_for_simple_edits = true,
  lsp_file_methods = {
    autosave_changes = true,
  },
  keymaps = {
    ["g?"] = "actions.show_help",

    ["<CR>"] = "actions.select",
    ["<C-f>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
    ["<C-g>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-r>"] = "actions.refresh",
    ["<C-t>"] = false,
    ["<C-h>"] = false,
    ["<C-j>"] = false,
    ["<C-k>"] = false,
    ["<C-l>"] = false,

    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
    ["~"] = { "actions.cd", opts = { scope = "win" }, desc = ":lcd to the current oil directory" },

    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",

    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
    ["gd"] = {
      desc = "Toggle file detail view",
      callback = function()
        DETAIL = not DETAIL

        if DETAIL then
          require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
        else
          require("oil").set_columns({ "icon" })
        end
      end,
    },

    ["gy"] = { "actions.yank_entry", opts = { modify = ":." } },
    ["gY"] = "actions.yank_entry",
    ["gF"] = { "actions.yank_entry", opts = { modify = ":t" } },
  },
})

vim.keymap.set("n", "<leader>e", function() oil.open() end, { desc = "Oil (Parent)" })

vim.keymap.set("n", "<leader>E", function() oil.open(vim.uv.cwd()) end, { desc = "Oil (CWD)" })

vim.api.nvim_create_autocmd("User", {
  desc = "Close buffers when files are deleted in Oil",
  pattern = "OilActionsPost",
  callback = function(args)
    if args.data.err then return end

    for _, action in ipairs(args.data.actions) do
      if action.type == "delete" then
        local _, path = require("oil.util").parse_url(action.url)
        local bufnr = vim.fn.bufnr(path)
        if bufnr ~= -1 then vim.api.nvim_buf_delete(bufnr, { force = true }) end
      end
    end
  end,
})
