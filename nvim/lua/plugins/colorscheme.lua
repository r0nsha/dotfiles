require("modus-themes").load {
  on_highlights = function(highlight, color)
    highlight.PmenuSel = { link = "FloatShadow" }
    highlight.PmenuThumb = { link = "FloatShadow" }
    highlight.MiniCursorword = { underdotted = true }
    highlight.MiniCursorwordCurrent = highlight.MiniCursorword
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
    highlight.MiniPickPrompt = { link = "NormalFloat" }
    highlight.MiniPickPromptCaret = { link = "NormalFloat" }
    highlight.MiniPickPromptPrefix = { link = "NormalFloat" }
    highlight.MiniPickBorder = { link = "Pmenu" }
    highlight.MiniPickBorderBusy = { link = "Pmenu" }
    highlight.MiniPickBorderText = { link = "Pmenu" }
    highlight.MiniPickIconDirectory = { link = "Pmenu" }
    highlight.MiniPickIconFile = { link = "Pmenu" }
    highlight.MiniPickNormal = { link = "Pmenu" }
    highlight.MiniPickHeader = { link = "Title" }
    highlight.MiniPickMatchCurrent = { link = "PmenuThumb" }
    highlight.MiniPickMatchMarked = { link = "FloatTitle" }
    -- highlight.MiniPickMatchRanges = { link = "FloatTitle" }
    highlight.MiniPickPreviewLine = { link = "CursorLine" }
    highlight.MiniPickPreviewRegion = { link = "PmenuThumb" }
    highlight.MiniPickPrompt = { link = "Pmenu" }
    -- highlight.SnacksPicker = { link = "Pmenu" }
    -- highlight.SnacksPickerBorder = { link = "SnacksPicker" }
  end,
  on_colors = function() end,
}
