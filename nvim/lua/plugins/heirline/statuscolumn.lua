local component = require("heirline-components.all").component

return {
  component.signcolumn(),
  component.foldcolumn(),
  component.numbercolumn({
    numbercolumn = { padding = { left = 1, right = 1 } },
  }),
}
