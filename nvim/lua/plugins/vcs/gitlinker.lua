---@module "lazy"
---@type LazySpec
return {
  "ruifm/gitlinker.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local gl = require "gitlinker"
    gl.setup {
      mappings = nil,
    }

    local actions = require "gitlinker.actions"

    vim.keymap.set("n", "<leader>go", function()
      gl.get_buf_range_url("n", { action_callback = actions.open_in_browser })
    end, { silent = true })
    vim.keymap.set("v", "<leader>go", function()
      gl.get_buf_range_url("v", { action_callback = actions.open_in_browser })
    end, {})

    vim.keymap.set("n", "<leader>gy", function()
      gl.get_buf_range_url("n", { action_callback = actions.copy_to_clipboard })
    end, { silent = true })
    vim.keymap.set("v", "<leader>gy", function()
      gl.get_buf_range_url("v", { action_callback = actions.copy_to_clipboard })
    end, {})
  end,
}
