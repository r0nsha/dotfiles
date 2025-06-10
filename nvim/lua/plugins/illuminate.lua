return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function(_)
    require("illuminate").configure {
      delay = 100,
    }
  end,
}
