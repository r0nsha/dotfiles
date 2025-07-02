return {
  "rgroli/other.nvim",
  config = function()
    require("other-nvim").setup({
      mappings = {
        -- "livewire",
        -- "angular",
        -- "laravel",
        -- "rails",
        "golang",
        "python",
        -- "react",
        "rust",
        -- "elixir",
        -- "clojure",

        -- lwc mappings
        {
          pattern = "(modules/.*)/([a-zA-Z0-9_]+).[tj]s$",
          target = {
            { target = "%1/%2.html", context = "html" },
            { target = "%1/%2.css", context = "css" },
            { target = "%1/__tests__/%2.test.ts", context = "tests" },
          },
        },
        {
          pattern = "(modules/.*)/(.*).html$",
          target = {
            { target = "%1/%2.ts", context = "ts" },
            { target = "%1/%2.css", context = "css" },
            { target = "%1/__tests__/%2.test.ts", context = "tests" },
          },
        },
        {
          pattern = "(modules/.*)/(.*).css$",
          target = {
            { target = "%1/%2.ts", context = "ts" },
            { target = "%1/%2.html", context = "html" },
            { target = "%1/__tests__/%2.test.ts", context = "tests" },
          },
        },
        {
          pattern = "(modules/.*)/(.*)/__tests__/.*.test.ts$",
          target = {
            { target = "%1/%2/%2.ts", context = "ts" },
            { target = "%1/%2/%2.html", context = "html" },
            { target = "%1/%2/%2.css", context = "css" },
          },
        },
      },
      rememberBuffers = false,
    })

    vim.keymap.set("n", "go", "<cmd>Other<cr>", { desc = "Other" })
  end,
}
