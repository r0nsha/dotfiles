require("modus-themes").load {
  on_highlights = function(highlight, color)
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

    -- highlight.NormalFloat = { bg = "none" }
    -- highlight.FloatBorder = { bg = "none" }
    -- highlight.FloatTitle = { bg = "none" }
    -- highlight.Pmenu = { bg = "none" }
    -- highlight.DapUIFloatBorder = { bg = "none" }
    -- highlight.BlinkCmpMenu = { link = "NormalFloat" }
    -- highlight.BlinkCmpMenuBorder = { link = "FloatBorder" }
    -- highlight.BlinkCmpMenuSelection = { link = "CursorLine" }
    -- highlight.TroubleNormal = { link = "Normal" }
    -- highlight.TroubleNormalNC = { link = "NormalNC" }
  end,
  on_colors = function() end,
}
