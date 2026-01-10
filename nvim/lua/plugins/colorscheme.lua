require("modus-themes").load({
  on_highlights = function(highlight, color)
    highlight.MiniCursorword = { underdotted = true }
    highlight.MiniCursorwordCurrent = { link = "MiniCursorword" }
    highlight.MatchParen = { link = "MiniCursorword" }
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
  end,
  on_colors = function() end,
})
