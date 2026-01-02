---@module "lazy"
---@type LazySpec
return {
  { "avm99963/vim-jjdescription" },
  {
    "rafikdraoui/jj-diffconflicts",
    config = function()
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("custom-jj-diffconflicts", { clear = true }),
        pattern = "JJDiffConflictsReady",
        desc = "Set keymap for jj-diffconflicts",
        callback = function(args)
          vim.notify "Press <c-y> or :wqa to accept conflict resolution"
          vim.keymap.set("n", "<c-y>", function()
            if vim.b.jj_diffconflicts_buftype == "conflicts" then
              vim.cmd "wqa"
            end
          end, { buffer = args.buf, desc = "Accept conflict resolution" })
        end,
      })
    end,
  },
  {
    "nicolasgb/jj.nvim",
    config = function()
      local jj = require "jj"
      jj.setup {}

      local cmd = require "jj.cmd"
      vim.keymap.set("n", "<leader>gg", cmd.log, { desc = "JJ log" })
      vim.keymap.set("n", "<leader>gs", cmd.status, { desc = "JJ status" })
      vim.keymap.set("n", "<leader>gD", cmd.diff, { desc = "JJ diff" })
    end,
  },
}
