return {
  "b0o/incline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local devicons = require "nvim-web-devicons"

    require("incline").setup {
      window = {
        padding = 0,
        margin = { horizontal = 0, vertical = 0 },
      },
      hide = {
        cursorline = "focused_win",
        focused_win = false,
        only_win = true,
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end

        local ft_icon, ft_color = devicons.get_icon_color(filename)
        local modified = vim.bo[props.buf].modified

        local res_icon = ft_icon and { ft_icon, guifg = ft_color } or ""
        local res_filename = { filename, gui = modified and "bold" or "regular" }
        local res_modified = modified and { " [+]", gui = "bold" } or ""

        local res = {
          res_icon,
          " ",
          res_filename,
          res_modified,
        }

        table.insert(res, " ")

        return res
      end,
    }
  end,
}
