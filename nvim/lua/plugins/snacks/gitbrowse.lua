return {
  "folke/snacks.nvim",
  opts = {
    gitbrowse = {
      -- override the default open function to copy the url to the clipboard
      open = function(url)
        vim.fn.setreg("+", url)
        vim.fn.setreg('"', url)

        if vim.fn.has("nvim-0.10") == 0 then
          require("lazy.util").open(url, { system = true })
          return
        end

        vim.ui.open(url)
      end,
      url_patterns = {
        ["git%.soma.salesforce.com"] = {
          branch = "/tree/{branch}",
          file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
          permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
          commit = "/commit/{commit}",
        },
      },
    },
  },
  keys = {
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git: Browse",
      mode = { "n", "v" },
    },
  },
}
