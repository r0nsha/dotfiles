vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    vim.cmd("colorscheme " .. require("utils").colorscheme)
  end,
})

return {
  {
    "ficcdaf/ashen.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("ashen").setup {}
    end,
  },
  {
    "aktersnurra/no-clown-fiesta.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("no-clown-fiesta").setup {
        styles = {
          lsp = { undercurl = true },
          match_paren = { bold = true },
        },
      }
    end,
  },
  {
    "rose-pine/neovim",
    lazy = false,
    priority = 1000,
    config = function()
      local bg = "#0a0a0a"

      require("rose-pine").setup {
        transparent = false,
        styles = {
          bold = true,
          italic = false,
          transparency = false,
        },
        highlight_groups = {
          Normal = { bg = bg },
          NormalNC = { bg = bg },
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          Pmenu = { bg = "none" },
          BlinkCmpMenu = { link = "NormalFloat" },
          BlinkCmpMenuBorder = { link = "FloatBorder" },
          BlinkCmpMenuSelection = { link = "CursorLine" },
          TroubleNormal = { link = "Normal" },
          TroubleNormalNC = { link = "NormalNC" },
          FzfLuaBorder = { bg = "none" },
        },
      }
    end,
  },
  {
    "miikanissi/modus-themes.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("modus-themes").setup {
        sign_column_background = false,
        on_highlights = function(highlights, colors)
          highlights.NormalFloat = { bg = "none" }
          highlights.FloatBorder = { bg = "none" }
          highlights.FloatTitle = { bg = "none" }
          highlights.Pmenu = { bg = "none" }
          highlights.BlinkCmpMenu = { link = "NormalFloat" }
          highlights.BlinkCmpMenuBorder = { link = "FloatBorder" }
          highlights.BlinkCmpMenuSelection = { link = "CursorLine" }
          highlights.MiniCursorword = { bg = "none", underline = true }
          highlights.MiniCursorwordCurrent = { bg = "none", underline = true }
        end,
      }
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local kanagawa = require "kanagawa"

      kanagawa.setup {
        compile = false,
        undercurl = true,
        commentStyle = { italic = false },
        functionStyle = { italic = false },
        keywordStyle = { italic = false },
        statementStyle = { italic = false, bold = true },
        typeStyle = { italic = false },
        variablebuiltinStyle = { italic = false },
        specialReturn = true,
        specialException = true,
        transparent = false,
        dimInactive = false,
        globalStatus = true,
        terminalColors = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
                float = {
                  bg = "none",
                },
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme

          return {
            -- show ~ at end of buffer
            EndOfBuffer = { fg = theme.ui.special },
            NonText = { fg = theme.ui.special },

            -- transparent floats
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg },
            PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            BlinkCmpMenuBorder = { link = "FloatBorder" },
          }
        end,
        theme = "dragon",
        background = {
          dark = "dragon",
          light = "lotus",
        },
      }
    end,
  },
}
