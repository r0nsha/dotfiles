local h = require("harpoon")
h:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
})
h:extend(require("harpoon.extensions").builtins.highlight_current_file())

local keys = { "a", "s", "d", "f" }

local function add()
  if vim.fn.expand("%") == "" then
    vim.notify("Cannot add empty buffer to Harpoon", vim.log.levels.WARN)
    return
  end

  local list = h:list()
  local item = list.config.create_list_item(list.config)

  if list:get_by_value(item.value) then
    vim.notify("Harpoon: Already in list", vim.log.levels.WARN)
    return
  end

  local slot
  for i = 1, #keys do
    if list:get(i) == nil then
      slot = i
      break
    end
  end

  if not slot then
    vim.notify("Harpoon list is full", vim.log.levels.WARN)
    return
  end

  list:add(item)
  vim.notify("Harpoon: Set to `" .. keys[slot] .. "`", vim.log.levels.INFO)
end

vim.keymap.set(
  "n",
  "<C-e>",
  function()
    h.ui:toggle_quick_menu(h:list(), {
      border = "none",
      ui_width_ratio = 0.35,
    })
  end,
  { desc = "Harpoon: Menu" }
)

vim.keymap.set("n", "<leader>a", add, { desc = "Harpoon: Add" })

for i, key in ipairs(keys) do
  vim.keymap.set(
    "n",
    "<A-" .. key .. ">",
    function() h:list():select(i) end,
    { desc = "Harpoon: Select " .. i }
  )
  vim.keymap.set("n", "<A-S-" .. key:upper() .. ">", function()
    h:list():replace_at(i)
    vim.notify("Harpoon: Replaced `" .. key .. "`", vim.log.levels.INFO)
  end, { desc = "Harpoon: Set " .. i })
end
