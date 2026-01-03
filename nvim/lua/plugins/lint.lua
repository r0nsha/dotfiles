vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    require("lint").linters_by_ft = {
      fish = { "fish" },
      python = { "ruff" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      group = vim.api.nvim_create_augroup("CustomLint", { clear = true }),
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
})
