local utils = require("heirline.utils")

local M = {}

local function setup_colors()
  ---@param name string
  ---@param field? string
  local function hl_color(name, field)
    local hl = vim.api.nvim_get_hl(0, { name = name })
    return field and hl[field] or hl.fg
  end

  return {
    fg_active = hl_color("Normal"),
    fg_inactive = hl_color("NonText"),
    green = hl_color("Keyword"),
    blue = hl_color("Keyword"),
    teal = hl_color("@property"),
    gray = hl_color("NonText"),
    orange = hl_color("String"),
    purple = hl_color("@variable.parameter"),
    red = hl_color("Error"),
    pink = hl_color("Error"),
    diag_hint = hl_color("DiagnosticHint"),
    diag_info = hl_color("DiagnosticInfo"),
    diag_warning = hl_color("DiagnosticWarn"),
    diag_error = hl_color("DiagnosticError"),
    git_del = hl_color("GitSignsDelete"),
    git_add = hl_color("GitSignsAdd"),
    git_change = hl_color("GitSignsChange"),
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
