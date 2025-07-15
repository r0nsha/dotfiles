return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    })

    ---@param msg string
    local function notify(msg)
      vim.notify(msg, vim.log.levels.INFO, { title = "Harpoon" })
    end

    local letters = { "j", "k", "m", "i" }

    vim.keymap.set("n", "ge", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: Open" })

    vim.keymap.set("n", "ga", function()
      if #harpoon:list().items >= #letters then
        notify("Harpoon is full")
        return
      end

      harpoon:list():add()
      notify(string.format("Harpooned `%s`", vim.fn.expand("%:t")))
    end, { desc = "Harpoon: Add" })

    for index, letter in ipairs(letters) do
      vim.keymap.set("n", "g" .. letter, function()
        harpoon:list():select(index)
      end, { desc = "Harpoon: Select " .. index })

      vim.keymap.set("n", "g" .. letter:upper(), function()
        harpoon:list():replace_at(index)
        notify(string.format("Harpooned `%s` to key `%s`", vim.fn.expand("%:t"), letter))
      end, { desc = "Harpoon: Replace " .. index })
    end
  end,
}
