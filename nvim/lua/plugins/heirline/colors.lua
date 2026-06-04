local utils = require("heirline.utils")

local M = {}

local function setup_colors()
  ---@param name string
  local function hl_color(name)
    local hl = vim.api.nvim_get_hl(0, { name = name })
    return hl.fg
  end

  return {
    gray = hl_color("NonText"),
    diag_hint = hl_color("DiagnosticHint"),
    diag_info = hl_color("DiagnosticInfo"),
    diag_warning = hl_color("DiagnosticWarn"),
    diag_error = hl_color("DiagnosticError"),
  }
end

function M.setup()
  vim.api.nvim_create_autocmd({ "ColorScheme", "BufWinEnter" }, {
    group = require("augroup"),
    callback = function() utils.on_colorscheme(setup_colors) end,
  })

  return setup_colors
end

return M
