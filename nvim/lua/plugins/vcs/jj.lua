vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("custom-jj-diffconflicts", { clear = true }),
  pattern = "JJDiffConflictsReady",
  desc = "Set keymap for jj-diffconflicts",
  callback = function(args)
    vim.notify("Press <c-y> or :wqa to accept conflict resolution")
    vim.keymap.set("n", "<c-y>", function()
      if vim.b.jj_diffconflicts_buftype == "conflicts" then vim.cmd("wqa") end
    end, { buffer = args.buf, desc = "Accept conflict resolution" })
  end,
})
