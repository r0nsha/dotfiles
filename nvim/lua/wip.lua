local lush = require "lush"
local hsl = lush.hsl

local cherry0 = hsl(346, 70, 60)
local leaf0 = hsl(160, 40, 50)
local branch0 = hsl(35, 82, 70)
local water0 = hsl(190, 40, 55)
local petal0 = hsl(325, 35, 70)
local bg0 = hsl(200, 37, 18)
local bg1 = bg0.li(5).mix(cherry0, 8).de(5)
local bg2 = bg1.li(15)
local bg3 = bg2.li(30).de(20)
local bg01 = bg0.da(50).mix(cherry0, 8).de(5)
local fg0 = hsl(350, 30, 90)

local colors = {
  bg01 = bg01,
  bg0 = bg0,
  bg1 = bg1,
  bg2 = bg2,
  bg3 = bg3,
  fg0 = fg0,
  cherry0 = cherry0,
  branch0 = branch0,
  leaf0 = leaf0,
  water0 = water0,
  petal0 = petal0,
  error = cherry0.da(5).ro(15),
  warn = branch0.da(5).ro(-15),
  info = water0.da(5).ro(15),
  hint = petal0.da(5).ro(-15),
}

local theme = lush(function(injected_functions)
  local sym = injected_functions.sym
  ---@diagnostic disable: undefined-global
  return {
    -- base
    Normal { bg = colors.bg0, fg = colors.fg0 },
    CursorLine { bg = colors.bg1 },
    Visual { bg = colors.bg1.mix(colors.cherry0, 15) },
    LineNr { bg = colors.bg0, fg = colors.bg3 },
    CursorLineNr { bg = colors.bg1, fg = colors.fg0 },
    NonText { fg = colors.bg3 },
    ColorColumn { bg = colors.bg1 },

    -- syntax
    Comment { fg = colors.leaf0 },
    Keyword { fg = colors.cherry0 },
    Function { fg = colors.fg0 },
    Identifier { fg = colors.fg0 },
    Type { fg = colors.water0 },
    Constant { fg = colors.branch0 },
    String { fg = colors.branch0 },
    Number { fg = colors.branch0 },
    -- Statement { fg = colors.cherry0 },
    Operator { NonText },
    sym "@punctuation" { NonText },
    sym "@constructor" { NonText },
    sym "@variable" { fg = Normal.fg },
    sym "@function.call" { fg = Normal.fg },
    sym "@function.builtin" { fg = Normal.fg },

    -- statusline
    StatusLine { bg = colors.bg1, fg = colors.fg0 },
    StatusLineNC { bg = colors.bg1, fg = colors.fg0 },
    -- TabLine { bg = colors.bg0, fg = colors.leaf0 },
    -- TabLineSel { fg = colors.cherry0 },
    -- TabLineFill { bg = colors.bg0 },

    -- split
    VertSplit { fg = colors.cherry0 },

    -- floats
    FloatBorder { fg = colors.bg3 },
    FloatTitle { fg = colors.fg0 },
    NormalFloat { fg = colors.fg0 },
    -- Pmenu { bg = colors.bg0, fg = colors.fg0 },
    -- PmenuSel { bg = colors.cherry0.darken(20), fg = colors.fg0 },

    -- search
    Search { bg = colors.bg1.mix(colors.cherry0, 20), fg = colors.fg0 },
    IncSearch { bg = colors.bg3.mix(colors.cherry0, 60), fg = colors.bg0 },
    CurSearch { bg = colors.bg3.mix(colors.cherry0, 60), fg = colors.bg0 },

    -- folds
    Folded { bg = colors.bg0.mix(colors.leaf0, 20), fg = colors.fg0.mix(colors.leaf0, 20) },

    -- diagnostics
    DiagnosticError { fg = colors.error },
    DiagnosticWarn { fg = colors.warn },
    DiagnosticInfo { fg = colors.info },
    DiagnosticHint { fg = colors.hint },
    DiagnosticUnderlineError { sp = colors.error, undercurl = true },
    DiagnosticUnderlineWarn { sp = colors.warn, undercurl = true },
    DiagnosticUnderlineInfo { sp = colors.info, undercurl = true },
    DiagnosticUnderlineHint { sp = colors.hint, undercurl = true },

    -- diff
    DiffAdd { bg = colors.bg0.mix(colors.leaf0, 30), fg = colors.leaf0 },
    DiffChange { bg = colors.bg0.mix(colors.branch0, 30), fg = colors.branch0 },
    DiffDelete { bg = colors.bg0.mix(colors.cherry0, 30), fg = colors.cherry0 },
    DiffText { bg = colors.bg0.mix(colors.petal0, 30) },
    Added { bg = colors.leaf0 },
    Changed { bg = colors.branch0 },
    Removed { bg = colors.cherry0 },

    -- gitsigns
    GitSignsAdd { bg = colors.bg0.mix(colors.leaf0, 20), fg = colors.leaf0 },
    GitSignsChange { bg = colors.bg0.mix(colors.branch0, 20), fg = colors.branch0 },
    GitSignsDelete { bg = colors.bg0.mix(colors.cherry0, 20), fg = colors.cherry0 },
  }
end)

return theme
