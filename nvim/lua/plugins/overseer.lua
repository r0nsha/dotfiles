require("overseer").setup()

vim.keymap.set(
  "n",
  "<leader>o",
  function()
    require("overseer").toggle({
      enter = true,
      direction = "right",
    })
  end
)
