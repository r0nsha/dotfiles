local utils = require("utils")

return {
  "echasnovski/mini.diff",
  config = function()
    local diff = require("mini.diff")

    diff.setup({
      source = utils.repo_too_large() and { diff.gen_source.save() }
        or { diff.gen_source.git(), diff.gen_source.save() },
      view = { style = "sign" },
      mappings = {
        apply = "gh",
        reset = "gH",
        textobject = "gh",
        goto_first = "[H",
        goto_prev = "[h",
        goto_next = "]h",
        goto_last = "]H",
      },
    })
  end,
}
