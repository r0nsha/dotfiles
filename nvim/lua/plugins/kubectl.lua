---@module "lazy"
---@type LazySpec
return {
  {
    "ramilito/kubectl.nvim",
    version = "2.*",
    dependencies = "saghen/blink.download",
    keys = {
      {
        "<leader>k",
        function()
          require("kubectl").toggle { tab = true }
        end,
        desc = "Kubectl",
      },
    },
    cmd = { "Kubectl", "Kubectx", "Kubens" },
    config = function()
      require("kubectl").setup {}

      local group = vim.api.nvim_create_augroup("custom_kubectl", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "K8sContextChanged",
        callback = function(ctx)
          local results =
            require("kubectl.actions.commands").shell_command("kubectl", { "config", "use-context", ctx.data.context })
          if not results then
            vim.notify(results, vim.log.levels.INFO)
          end
        end,
      })
    end,
  },
}
