vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("CustomColorscheme", { clear = true }),
  pattern = "LazyDone",
  callback = function()
    vim.cmd("colorscheme " .. require "config.colorscheme")
  end,
})

---@module "lazy"
---@type LazySpec
return {
  {
    "miikanissi/modus-themes.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("modus-themes").setup {
        on_highlights = function(highlight, color)
          highlight.MiniCursorword = { underdotted = true }
          highlight.MiniCursorwordCurrent = highlight.MiniCursorword
          Cursor = { bg = "none" }
          -- highlight.NormalFloat = { bg = "none" }
          -- highlight.FloatBorder = { bg = "none" }
          -- highlight.FloatTitle = { bg = "none" }
          -- highlight.Pmenu = { bg = "none" }
          -- highlight.DapUIFloatBorder = { bg = "none" }
          -- highlight.BlinkCmpMenu = { link = "NormalFloat" }
          -- highlight.BlinkCmpMenuBorder = { link = "FloatBorder" }
          highlight.TroubleNormal = { link = "Normal" }
          highlight.TroubleNormalNC = { link = "NormalNC" }
          highlight.DapStoppedLine = { link = "DiagnosticVirtualTextError" }
          highlight.HydraPink = { fg = color.error }
          highlight.StatusLineNC = { bg = color.bg_dim }
          highlight.FoldColumn = { link = "LineNr" }
          highlight.CursorLineFold = { link = "CursorLineNr" }
        end,
      }
    end,
  },
}
