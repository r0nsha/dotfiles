local lush = require "lush"
local hsl = lush.hsl

local bg0 = hsl(200, 30, 5)
local bg1 = bg0.lighten(10).desaturate(25)
local bg2 = bg0.lighten(20).desaturate(25)
local fg0 = hsl(350, 10, 90)
local cherry0 = hsl(345, 60, 60)
local leaf0 = hsl(160, 25, 50)
local branch0 = hsl(16, 45, 50)
local water0 = hsl(185, 30, 50)

local colors = {
  bg0 = bg0,
  bg1 = bg1,
  bg2 = bg2,
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
    LineNr { bg = colors.bg0, fg = colors.bg0.lighten(30) },
    CursorLineNr { LineNr, fg = colors.cherry0 },
    NonText { fg = colors.bg2 },

    -- syntax
    Comment { fg = colors.leaf0 },
    String { fg = colors.cherry0 },
    Number { fg = colors.cherry0 },
    Keyword { fg = colors.cherry0 },
    Function { fg = colors.fg0 },
    Identifier { fg = colors.fg0 },
    Type { fg = colors.water0 },
    Constant { fg = colors.cherry0 },
    Statement { fg = colors.cherry0 },
    Operator { fg = colors.fg0 },

    -- ui
    StatusLine { bg = colors.bg0, fg = colors.fg0 },
    StatusLineNC { bg = colors.bg0, fg = colors.leaf0 },
    VertSplit { fg = colors.bg0.lighten(20) },
    Pmenu { bg = colors.bg0, fg = colors.fg0 },
    PmenuSel { bg = colors.cherry0.darken(20), fg = colors.fg0 },
    TabLine { bg = colors.bg0, fg = colors.leaf0 },
    TabLineSel { fg = colors.cherry0 },
    TabLineFill { bg = colors.bg0 },

    -- diff
    DiffAdd { fg = colors.leaf0, bg = colors.bg0 },
    DiffChange { fg = colors.branch0, bg = colors.bg0 },
    DiffDelete { fg = colors.cherry0, bg = colors.bg0 },
    DiffText { fg = colors.cherry0, bg = colors.bg0 },

    -- search
    Search { bg = colors.cherry0.darken(30), fg = colors.fg0 },
    IncSearch { bg = colors.cherry0, fg = colors.bg0 },
  }
end)

return theme
