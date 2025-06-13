return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  config = function()
    local ufo = require "ufo"
    ufo.setup {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    }

    vim.keymap.set("n", "zO", ufo.openAllFolds)
    vim.keymap.set("n", "zC", ufo.closeAllFolds)
  end,
}
