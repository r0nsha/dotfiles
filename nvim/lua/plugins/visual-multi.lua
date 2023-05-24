return {
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.keymap.set(
        "n",
        "<C-S-Up>",
        "<cmd>call vm#commands#add_cursor_up(0, v:count1)<cr>",
        { remap = false, silent = true }
      )

      vim.keymap.set(
        "n",
        "<C-S-Down>",
        "<cmd>call vm#commands#add_cursor_down(0, v:count1)<cr>",
        { remap = false, silent = true }
      )
    end,
  },
}
