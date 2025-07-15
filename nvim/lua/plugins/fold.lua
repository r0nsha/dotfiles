return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  config = function()
    local ufo = require("ufo")
    ufo.setup({
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    })

    vim.keymap.set("n", "zR", ufo.openAllFolds)
    vim.keymap.set("n", "zM", ufo.closeAllFolds)
  end,
  init = function()
    vim.o.foldenable = true
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.opt.foldcolumn = "1"
    vim.opt.fillchars:append({ fold = "󰧟" })
  end,
}
