return {
  "monaqa/dial.nvim",
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%d/%m/%Y"],
      },
      visual = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%d/%m/%Y"],
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
      },
    })

    local map = require("dial.map")
    vim.keymap.set("n", "+", function()
      return map.inc_normal()
    end, { expr = true, desc = "Increment" })
    vim.keymap.set("n", "-", function()
      return map.dec_normal()
    end, { expr = true, desc = "Decrement" })

    vim.keymap.set("n", "g+", function()
      return map.inc_gnormal()
    end, { expr = true, desc = "Increment" })
    vim.keymap.set("n", "g-", function()
      return map.dec_gnormal()
    end, { expr = true, desc = "Decrement" })

    vim.keymap.set("v", "+", function()
      return map.inc_visual()
    end, { expr = true, desc = "Increment" })
    vim.keymap.set("v", "-", function()
      return map.dec_visual()
    end, { expr = true, desc = "Decrement" })

    vim.keymap.set("v", "g+", function()
      return map.inc_gvisual()
    end, { expr = true, desc = "Increment" })
    vim.keymap.set("v", "g-", function()
      return map.dec_gvisual()
    end, { expr = true, desc = "Decrement" })
  end,
}
