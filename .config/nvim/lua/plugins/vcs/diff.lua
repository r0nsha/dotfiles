local actions = require("diffview.actions")

---@param forward boolean?
local function jump_hunk(forward)
  return function()
    -- non-inline layout
    local keys = vim.v.count1 .. (forward and "]c" or "[c")

    if vim.wo.diff then
      vim.cmd.normal({ keys, bang = true })
      return
    end

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.wo[win].diff then
        vim.api.nvim_win_call(win, function() vim.cmd.normal({ keys, bang = true }) end)
        return
      end
    end

    -- inline layout
    if forward then
      actions.next_inline_hunk()
    else
      actions.prev_inline_hunk()
    end
  end
end

local global_keymaps = {
  { "n", "t", actions.cycle_layout, { desc = "Cycle through available layouts" } },
  { "n", "<C-n>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
  { "n", "<C-p>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
  { "n", "<C-S-N>", jump_hunk(true), { desc = "Jump to the next hunk" } },
  { "n", "<C-S-P>", jump_hunk(), { desc = "Jump to the previous hunk" } },
  ["q"] = "<Cmd>DiffviewClose<CR>",
}

require("diffview").setup({
  preferred_adapter = "jj",
  enhanced_diff_hl = true,
  persist_selections = { enabled = true },
  file_panel = {
    show_branch_name = true,
    always_show_sections = false,
    listing_style = "tree",
    tree_options = { flatten_dirs = true, folder_count_style = "grouped" },
  },
  file_history_panel = {
    stat_style = "both",
    date_format = "relative",
  },
  view = {
    default = { layout = "diff2_horizontal" },
    inline = { style = "overleaf" },
    file_history = { layout = "diff2_vertical" },
    cycle_layouts = {
      default = { "diff2_horizontal", "diff1_inline" },
    },
  },
  keymaps = {
    view = global_keymaps,
    file_panel = vim.tbl_deep_extend(
      "force",
      global_keymaps,
      { ["-"] = false, ["s"] = false, ["S"] = false, ["U"] = false }
    ),
    file_history_panel = global_keymaps,
  },
})

vim.keymap.set("n", "<leader>gdd", "<cmd>DiffviewOpen<cr>", { desc = "Diff" })
vim.keymap.set("n", "<leader>gdD", "<cmd>DiffviewOpen -- %<cr>", { desc = "Diff (current file)" })
vim.keymap.set("n", "<leader>gdf", "<cmd>DiffviewFileHistory<cr>", { desc = "File history" })
vim.keymap.set("x", "<leader>gdf", function() vim.cmd("'<,'>DiffviewFileHistory") end, {
  desc = "File history (visual)",
})
vim.keymap.set(
  "n",
  "<leader>gdF",
  "<cmd>DiffviewFileHistory %<cr>",
  { desc = "File history (current file)" }
)
