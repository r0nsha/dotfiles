local gl = require("gitlinker")

local function finish_tangled_url(url, url_data)
  url = url .. url_data.repo .. "/blob/" .. url_data.rev .. "/" .. url_data.file
  if url_data.lstart then
    url = url .. "#L" .. url_data.lstart
    if url_data.lend then url = url .. "-L" .. url_data.lend end
  end
  return url
end

local function get_tangled_type_url(url_data)
  if not url_data.repo or not url_data.file then return end
  return finish_tangled_url("https://tangled.org/", url_data)
end

local function get_tangled_knot_type_url(url_data)
  if not url_data.repo or not url_data.file then return end
  return finish_tangled_url("https://tangled.org/did:plc:", url_data)
end

gl.setup({
  mappings = nil,
  callbacks = {
    ["tangled.org"] = get_tangled_type_url,
    ["knot..*.com"] = get_tangled_knot_type_url,
  },
})

local actions = require("gitlinker.actions")

vim.keymap.set(
  "n",
  "<leader>go",
  function() gl.get_buf_range_url("n", { action_callback = actions.open_in_browser }) end,
  { silent = true, desc = "Open in git forge" }
)
vim.keymap.set(
  "v",
  "<leader>go",
  function() gl.get_buf_range_url("v", { action_callback = actions.open_in_browser }) end,
  { desc = "Open in git forge" }
)

vim.keymap.set(
  "n",
  "<leader>gy",
  function() gl.get_buf_range_url("n", { action_callback = actions.copy_to_clipboard }) end,
  { silent = true, desc = "Yank git forge url" }
)
vim.keymap.set(
  "v",
  "<leader>gy",
  function() gl.get_buf_range_url("v", { action_callback = actions.copy_to_clipboard }) end,
  { desc = "Yank git forge url" }
)
