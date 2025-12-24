---@module "lazy"
---@type LazySpec
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

      local prev_len = h:list():length()
      h:list():add()

      if prev_len == h:list():length() then
        -- Already in harpoon
        return
      end

      vim.notify("Harpoon: Set to `" .. keys[h:list():length()] .. "`", vim.log.levels.INFO)
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
        h:list():replace_at(i)
        vim.notify("Harpoon: Replaced `" .. key .. "`", vim.log.levels.INFO)
      end, { desc = "Harpoon: Set " .. i })
    end
  end,
}
