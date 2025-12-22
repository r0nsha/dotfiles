vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions.type == "move" then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})

---@module "lazy"
---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = {},
  keys = {
    {
      "grN",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename current file",
    },
  },
}
