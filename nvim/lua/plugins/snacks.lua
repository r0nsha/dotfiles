return {
  "folke/snacks.nvim",
  config = function()
    local snacks = require "snacks"

    snacks.setup {
      -- indent = {
      --   animate = {
      --     enabled = false,
      --   },
      -- },
      input = {
        icon = ">",
        win = {
          border = "single",
          relative = "cursor",
          row = -3,
          col = -4,
          title_pos = "left",
        },
      },
      gitbrowse = {
        what = "commit",
        -- override the default open function to copy the url to the clipboard
        open = function(url)
          vim.fn.setreg("+", url)

          if vim.fn.has "nvim-0.10" == 0 then
            require("lazy.util").open(url, { system = true })
            return
          end

          vim.ui.open(url)
        end,
      },
    }

    vim.keymap.set("n", "<leader>gu", function()
      snacks.gitbrowse()
    end, { desc = "Git: Browse" })
  end,
}
