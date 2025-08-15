return {
  "leath-dub/snipe.nvim",
  config = function()
    local snipe = require("snipe")
    snipe.setup({})

    vim.keymap.set("n", "'", snipe.open_buffer_menu, { desc = "Snipe" })
  end,
}
