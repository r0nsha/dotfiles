return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local h = require "harpoon"
    h:setup {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    }

    local keys = { "u", "i", "o", "m" }

    local function add()
      if vim.fn.expand "%" == "" then
        vim.notify("Cannot add empty buffer to Harpoon", vim.log.levels.WARN)
        return
      end

      if h:list():length() >= #keys then
        vim.notify("Harpoon list is full", vim.log.levels.WARN)
        return
      end

      h:list():add()
    end

    local function set(index)
      local path = vim.fn.expand "%"
      local list = h:list()
      local len = list:length()
      local items = list.items

      if index <= len then
        local replaced = items[index].value

        for i, val in ipairs(items) do
          if val.value == path then
            items[i].value = replaced
            break
          end
        end

        items[index].value = path
      else
        list:add()
      end
    end

    vim.keymap.set("n", "<leader>hh", function()
      h.ui:toggle_quick_menu(h:list())
    end, { desc = "Harpoon: Menu" })

    vim.keymap.set("n", "<leader>ha", add, { desc = "Harpoon: Add" })

    for i, key in ipairs(keys) do
      vim.keymap.set("n", "<A-" .. key .. ">", function()
        h:list():select(i)
      end, { desc = "Harpoon: Select " .. i })
      vim.keymap.set("n", "<A-S-" .. key .. ">", function()
        set(i)
        vim.notify("Harpoon: Replaced '" .. key .. "'", vim.log.levels.INFO)
      end, { desc = "Harpoon: Set " .. i })
    end
  end,
}
