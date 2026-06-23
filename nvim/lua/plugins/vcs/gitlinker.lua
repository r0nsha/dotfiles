local gl = require("gitlinker")
gl.setup({
  mappings = nil,
  callbacks = {
    ["knot..*.com"] = function(url_data)
      if not url_data.repo or not url_data.file then return end
      local url = "https://tangled.org/did:plc:"
        .. url_data.repo
        .. "/blob/"
        .. url_data.rev
        .. "/"
        .. url_data.file
      if url_data.lstart then
        url = url .. "#L" .. url_data.lstart
        if url_data.lend then url = url .. "-L" .. url_data.lend end
      end
      return url
    end,
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
