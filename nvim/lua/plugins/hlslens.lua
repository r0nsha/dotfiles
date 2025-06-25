return {
  "kevinhwang91/nvim-hlslens",
  event = { "BufRead", "BufNewFile" },
  config = function()
    require("hlslens").setup()

    local function map(lhs, rhs)
      vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true })
    end

    map("n", [[<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>zzzv]])
    map("N", [[<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>zzzv]])
    map("*", [[*<cmd>lua require('hlslens').start()<cr>]])
    map("#", [[#<cmd>lua require('hlslens').start()<cr>]])
    map("g*", [[g*<cmd>lua require('hlslens').start()<cr>]])
    map("g#", [[g#<cmd>lua require('hlslens').start()<cr>]])
  end,
}
