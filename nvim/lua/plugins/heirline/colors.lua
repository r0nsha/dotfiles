local utils = require "heirline.utils"

local M = {}

local function setup_colors()
  ---@param name string
  local function hl_color(name)
    local hl = vim.api.nvim_get_hl(0, { name = name })
    return hl.fg
  end

  dbg(hl_color "DiffAdd")
  return {
    fg_active = hl_color "Normal",
    fg_inactive = hl_color "NonText",
    green = hl_color "Keyword",
    blue = hl_color "Keyword",
    teal = hl_color "@property",
    gray = hl_color "NonText",
    orange = hl_color "String",
    purple = hl_color "@variable.parameter",
    red = hl_color "Error",
    pink = hl_color "HydraPink",
    diag_hint = hl_color "DiagnosticHint",
    diag_info = hl_color "DiagnosticInfo",
    diag_warning = hl_color "DiagnosticWarn",
    diag_error = hl_color "DiagnosticError",
    diff_add = hl_color "MiniDiffSignAdd",
    diff_change = hl_color "MiniDiffSignChange",
    diff_del = hl_color "MiniDiffSignDelete",
  }
end

function M.setup()
  vim.api.nvim_create_autocmd({ "ColorScheme", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("Heirline", { clear = true }),
    callback = function()
      utils.on_colorscheme(setup_colors)
    end,
  })

  return setup_colors
end

return M
