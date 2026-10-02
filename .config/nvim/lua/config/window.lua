vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>", { desc = "Move cursor left" })
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>", { desc = "Move cursor down" })
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>", { desc = "Move cursor up" })
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>", { desc = "Move cursor right" })

vim.keymap.set(
  { "n", "t" },
  "<C-S-H>",
  function() require("config.resize").resize_left(5) end,
  { desc = "Resize window left" }
)
vim.keymap.set(
  { "n", "t" },
  "<C-S-J>",
  function() require("config.resize").resize_down(1) end,
  { desc = "Resize window down" }
)
vim.keymap.set(
  { "n", "t" },
  "<C-S-K>",
  function() require("config.resize").resize_up(1) end,
  { desc = "Resize window up" }
)
vim.keymap.set(
  { "n", "t" },
  "<C-S-L>",
  function() require("config.resize").resize_right(5) end,
  { desc = "Resize window right" }
)

---@param char string
---@param rhs string
---@param desc string
local function map_ctrl_t(char, rhs, desc)
  vim.keymap.set("n", "<c-t>" .. char, rhs, { desc = desc })
  vim.keymap.set("t", "<c-t>" .. char, [[<c-\><c-n>]] .. rhs, { desc = desc })
  if char ~= char:lower() then return end -- A and <C-a> are conflicting
  vim.keymap.set("n", "<c-t><c-" .. char .. ">", rhs, { desc = desc })
  vim.keymap.set("t", "<c-t><c-" .. char .. ">", [[<c-\><c-n>]] .. rhs, { desc = desc })
end

map_ctrl_t("c", "<cmd>tabnew<cr>", "New tabpage")
map_ctrl_t("x", "<cmd>tabclose<cr>", "Close tabpage")
map_ctrl_t("q", "<cmd>tabclose<cr>", "Close tabpage")
map_ctrl_t("n", "<cmd>tabnext<cr>", "Next tabpage")
map_ctrl_t("p", "<cmd>tabprevious<cr>", "Previous tabpage")
map_ctrl_t("t", "g<Tab>", "Last accessed tabpage")
map_ctrl_t("h", "<cmd>-tabmove<cr>", "Move tabpage to the left")
map_ctrl_t("l", "<cmd>+tabmove<cr>", "Move tabpage to the right")
map_ctrl_t("O", "<cmd>tabonly<cr>", "Close other tabpages")

map_ctrl_t("s", "<cmd>split | term<cr>", "New terminal (horizontal split)")
map_ctrl_t("v", "<cmd>vsplit | term<cr>", "New terminal (vertical split)")
map_ctrl_t("T", "<cmd>tab term<cr>", "New terminal (new tab)")

for i = 1, 9 do
  map_ctrl_t(tostring(i), string.format("%dgt", i), string.format("Go to tabpage %d", i))
end
