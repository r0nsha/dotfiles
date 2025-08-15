return {
  "folke/snacks.nvim",
  dependencies = { "stevearc/oil.nvim" },
  opts = {},
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions.type == "move" then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end,
    })

    vim.keymap.set("n", "grN", function() end, { desc = "Rename current file" })
  end,
}
