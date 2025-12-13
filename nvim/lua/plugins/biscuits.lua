return {
  "code-biscuits/nvim-biscuits",
  config = function()
    require("nvim-biscuits").setup {
      cursor_line_only = true,
      prefix_string = " ",
    }

    vim.api.nvim_set_hl(0, "BiscuitColor", { link = "Comment" })
  end,
}
