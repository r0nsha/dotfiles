require("modus-themes").load({
  transparent = true,
  on_highlights = function(highlight, color)
    highlight.MiniCursorword = { underdotted = true }
    highlight.MiniCursorwordCurrent = { link = "MiniCursorword" }
    highlight.MatchParen = { underdotted = true }
    highlight.MiniJump = { fg = color.fg_main, bg = color.bg_cyan_intense }
    highlight.CursorLineSign = { link = "CursorLineNr" }
    highlight.CursorLineFold = { link = "CursorLineNr" }
    highlight.FoldColumn = { link = "LineNr" }
    highlight.HydraPink = { fg = color.error }
    highlight.StatusLineNC = { bg = color.bg_dim }
    highlight.DiffAdd = { bg = color.bg_added }
    highlight.DiffChange = { bg = color.bg_changed }
    highlight.DiffText = { bg = color.bg_changed_refine }
    highlight.DiffTextAdd = { link = "DiffText" }
    highlight.DiffviewDiffAddAsDelete = { bg = color.bg_removed }
    highlight.FloatTitle = { link = "NormalFloat" }
    highlight.SnacksPicker = { link = "NormalFloat" }
    highlight.SnacksPickerBorder = { link = "NormalFloat" }
    highlight.SnacksPickerPrompt = { fg = color.fg_main, bg = color.bg_active }
    highlight.SnacksPickerCol = { link = "SnacksPickerRow" }
    highlight.SnacksPickerTitle = { link = "NormalFloat" }
    highlight.SnacksPickerToggle = { fg = color.blue, bg = color.bg_active, bold = true }
    highlight.NeotestTest = { fg = color.fg_dim }
  end,
  on_colors = function() end,
})
