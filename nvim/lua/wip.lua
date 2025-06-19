local lush = require "lush"
local hsl = lush.hsl

local bg0 = hsl(200, 37, 18)
local bg1 = bg0.lighten(10).desaturate(10)
local bg2 = bg1.lighten(15).desaturate(15)
local bg3 = bg2.lighten(30).desaturate(30)
local fg0 = hsl(350, 30, 90)
local cherry0 = hsl(345, 70, 70)
local leaf0 = hsl(170, 35, 50)
local branch0 = hsl(28, 50, 60)
local water0 = hsl(190, 50, 50)

local colors = {
  bg0 = bg0,
  bg1 = bg1,
  bg2 = bg2,
  bg3 = bg3,
  fg0 = fg0,
  cherry0 = cherry0,
  branch0 = branch0,
  leaf0 = leaf0,
  water0 = water0,
}

local theme = lush(function()
  ---@diagnostic disable: undefined-global
  return {
    -- base
    Normal { bg = colors.bg0, fg = colors.fg0 },
    CursorLine { bg = colors.bg1 },
    Visual { bg = colors.bg2 },
    LineNr { bg = colors.bg1, fg = colors.bg3 },
    CursorLineNr { LineNr, fg = colors.cherry0 },
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
    Operator { fg = colors.water0 },

    -- -- ui
    -- StatusLine { bg = colors.bg0, fg = colors.fg0 },
    -- StatusLineNC { bg = colors.bg0, fg = colors.leaf0 },
    -- VertSplit { fg = colors.bg0.lighten(20) },
    -- Pmenu { bg = colors.bg0, fg = colors.fg0 },
    -- PmenuSel { bg = colors.cherry0.darken(20), fg = colors.fg0 },
    -- TabLine { bg = colors.bg0, fg = colors.leaf0 },
    -- TabLineSel { fg = colors.cherry0 },
    -- TabLineFill { bg = colors.bg0 },

    -- -- diff
    -- DiffAdd { fg = colors.leaf0, bg = colors.bg0 },
    -- DiffChange { fg = colors.branch0, bg = colors.bg0 },
    -- DiffDelete { fg = colors.cherry0, bg = colors.bg0 },
    -- DiffText { fg = colors.cherry0, bg = colors.bg0 },

    -- -- search
    -- Search { bg = colors.cherry0.darken(30), fg = colors.fg0 },
    -- IncSearch { bg = colors.cherry0, fg = colors.bg0 },
  }
end)

return theme
