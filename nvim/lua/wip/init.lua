local lush = require "lush"
local hsl = lush.hsl

local cherry0 = hsl(346, 67, 62)
local cherry1 = cherry0.li(10).de(10)
local cherry2 = cherry1.li(20).de(10)
local leaf0 = hsl(170, 35, 50)
local branch0 = hsl(35, 82, 70)
local water0 = hsl(197, 45, 60)
local petal0 = hsl(325, 35, 70)
local bg0 = hsl(200, 37, 18)
local bg1 = bg0.li(5).mix(cherry0, 8).de(5)
local bg2 = bg1.li(15)
local bg3 = bg2.li(30).de(30)
local bg_1 = bg0.da(50).mix(cherry0, 8).de(5)
local fg0 = hsl(350, 30, 90)

local colors = {
  bg_1 = bg_1,
  bg0 = bg0,
  bg1 = bg1,
  bg2 = bg2,
  bg3 = bg3,
  fg0 = fg0,
  cherry0 = cherry0,
  cherry1 = cherry1,
  cherry2 = cherry2,
  branch0 = branch0,
  leaf0 = leaf0,
  water0 = water0,
  petal0 = petal0,
  error = cherry0.da(5).ro(15),
  warn = branch0.da(5).ro(-15),
  info = water0.da(5).ro(15),
  hint = petal0.da(5).ro(-15),
}

---@class wip.Config
---@field diagnostics? { blend?: number }
---@field diff? { blend?: number }
---@field gitsigns? { bg?: boolean, blend?: number }
local defaults = {
  diagnostics = { blend = 20 },
  diff = { blend = 20 },
  gitsigns = { bg = false, blend = 40 },
}

-- ---@param opts wip.Config?
-- function M.setup(opts)
-- opts = vim.tbl_deep_extend("force", M.defaults, opts)
local opts = defaults

return lush(function(injected_functions)
  ---@diagnostic disable: undefined-global
  local sym = injected_functions.sym

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
    Comment { fg = colors.bg3 },
    Keyword { fg = colors.cherry0 },
    Function { fg = colors.fg0 },
    Identifier { fg = colors.fg0 },
    Type { fg = colors.leaf0 },
    Constant { fg = colors.branch0 },
    String { fg = colors.branch0 },
    Number { fg = colors.branch0 },
    -- Statement { fg = colors.fg0 },
    Operator { fg = colors.bg3 },
    sym "@punctuation" { NonText },
    sym "@constructor" { fg = colors.petal0 },
    sym "@variable" { fg = colors.fg0 },
    sym "@property" { fg = colors.cherry2 },
    sym "@function.call" { fg = colors.fg0 },
    sym "@function.builtin" { fg = colors.fg0 },

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
    DiagnosticVirtualTextError { bg = colors.bg0.mix(colors.error, 20), fg = colors.error },
    DiagnosticVirtualTextWarn { bg = colors.bg0.mix(colors.warn, opts.diagnostics.blend), fg = colors.warn },
    DiagnosticVirtualTextInfo { bg = colors.bg0.mix(colors.info, opts.diagnostics.blend), fg = colors.info },
    DiagnosticVirtualTextHint { bg = colors.bg0.mix(colors.hint, opts.diagnostics.blend), fg = colors.hint },
    DiagnosticVirtualLineError { bg = colors.bg0.mix(colors.error, opts.diagnostics.blend), fg = colors.error },
    DiagnosticVirtualLineWarn { bg = colors.bg0.mix(colors.warn, opts.diagnostics.blend), fg = colors.warn },
    DiagnosticVirtualLineInfo { bg = colors.bg0.mix(colors.info, opts.diagnostics.blend), fg = colors.info },
    DiagnosticVirtualLineHint { bg = colors.bg0.mix(colors.hint, opts.diagnostics.blend), fg = colors.hint },
    DiagnosticVirtualLinesError { DiagnosticVirtualLineError },
    DiagnosticVirtualLinesWarn { DiagnosticVirtualLineWarn },
    DiagnosticVirtualLinesInfo { DiagnosticVirtualLineInfo },
    DiagnosticVirtualLinesHint { DiagnosticVirtualLineHint },

    -- diff
    DiffAdd { bg = colors.bg0.mix(colors.leaf0, opts.diff.blend) },
    DiffChange { bg = colors.bg0.mix(colors.branch0, opts.diff.blend) },
    DiffDelete { bg = colors.bg0.mix(colors.cherry0, opts.diff.blend), fg = colors.cherry0 },
    DiffText { bg = colors.bg0.mix(colors.petal0, opts.diff.blend) },
    Added { bg = colors.leaf0 },
    Changed { bg = colors.branch0 },
    Removed { bg = colors.cherry0 },

    -- gitsigns
    GitSignsAdd { bg = colors.bg0.mix(colors.leaf0, opts.gitsigns.bg and opts.gitsigns.blend or 0), fg = colors.leaf0 },
    GitSignsChange {
      bg = colors.bg0.mix(colors.branch0, opts.gitsigns.bg and opts.gitsigns.blend or 0),
      fg = colors.branch0,
    },
    GitSignsDelete {
      bg = colors.bg0.mix(colors.cherry0, opts.gitsigns.bg and opts.gitsigns.blend or 0),
      fg = colors.cherry0,
    },

    -- blink.cmp
    BlinkCmpMenu { bg = colors.bg0, fg = colors.fg0 },
    BlinkCmpMenuBorder { fg = colors.bg3 },
    BlinkCmpMenuSelection { bg = colors.cherry0.darken(20), fg = colors.fg0 },

    -- minuet
    MinuetVirtualText { Comment },
  }
end)
