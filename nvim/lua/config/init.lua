require "config.opts"
require "config.autocmd"
require "config.remap"
require "config.pass"

require("vim._extui").enable {
  enable = true,
  msg = { target = "cmd", timeout = 2000 },
}
