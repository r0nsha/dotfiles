---@module "lazy"
---@type LazySpec
return {
  "nvim-mini/mini.hipatterns",
  config = function()
    require("mini.hipatterns").setup {
      highlighters = {
        todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
        fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
        hack = { pattern = "HACK", group = "MiniHipatternsHack" },
        note = { pattern = "NOTE", group = "MiniHipatternsNote" },
      },
    }
  end,
}
