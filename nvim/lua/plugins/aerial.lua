return {
  "stevearc/aerial.nvim",
  config = function()
    local aerial = require "aerial"
    aerial.setup {
      disable_max_lines = 30000,
    }

    vim.keymap.set("n", "gA", aerial.toggle, { desc = "Aerial: Toggle" })
    vim.keymap.set("n", "{", function()
      if aerial.is_open() then
        aerial.prev()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("{", true, true, true), "n", true)
      end
    end, { remap = false })

    vim.keymap.set("n", "}", function()
      if aerial.is_open() then
        aerial.next()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("}", true, true, true), "n", true)
      end
    end, { remap = false })
  end,
}
