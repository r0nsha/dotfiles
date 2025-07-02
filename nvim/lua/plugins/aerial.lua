return {
  "stevearc/aerial.nvim",
  config = function()
    local aerial = require("aerial")
    aerial.setup({
      layout = {
        min_width = 30,
        default_direction = "left",
        -- placement = "edge",
      },
      -- attach_mode = "global",
      disable_max_lines = 30000,
    })

    vim.keymap.set("n", "gA", aerial.toggle, { desc = "Aerial: Toggle" })
    vim.keymap.set("n", "{", function()
      if aerial.is_open() then
        aerial.prev()
      else
        vim.api.nvim_feedkeys("{", "n", true)
      end
    end, { remap = false })

    vim.keymap.set("n", "}", function()
      if aerial.is_open() then
        aerial.next()
      else
        vim.api.nvim_feedkeys("}", "n", true)
      end
    end, { remap = false })
  end,
}
