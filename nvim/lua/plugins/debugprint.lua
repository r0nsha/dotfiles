return {
  {
    "andrewferrier/debugprint.nvim",
    dependencies = {
      "echasnovski/mini.hipatterns",
      "ibhagwan/fzf-lua",
    },
    lazy = false,
    version = "*",
    config = function()
      -- use console.info instead of console.warn
      local js_like = {
        left = 'console.info("',
        right = '")',
        mid_var = '", ',
        right_var = ")",
      }

      require("debugprint").setup {
        keymaps = {
          normal = {
            toggle_comment_debug_prints = "g?c",
            delete_debug_prints = "g?d",
          },
        },
        filetypes = {
          ["javascript"] = js_like,
          ["javascriptreact"] = js_like,
          ["typescript"] = js_like,
          ["typescriptreact"] = js_like,
        },
      }

      vim.keymap.set("n", "<leader>sd", "<cmd>SearchDebugPrints<cr>", { desc = "Debug Print: Search" })
    end,
  },
}
