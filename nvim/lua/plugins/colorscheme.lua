return {
  {
    "rebelot/kanagawa.nvim",
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
        transparent = true,
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

          local make_diagnostic_color = function(color)
            local c = require "kanagawa.lib.color"
            return { fg = color, bg = c(color):blend(theme.ui.bg, 0.975):to_hex() }
          end

          return {
            -- show ~ at end of buffer
            EndOfBuffer = { fg = theme.ui.special },
            NonText = { fg = theme.ui.special },

            -- cmp-nvim
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },

            -- transparent floats
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { bg = theme.ui.bg_m1, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m1, fg = theme.ui.fg_dim },

            -- diagnostic color tints
            DiagnosticVirtualTextHint = make_diagnostic_color(theme.diag.hint),
            DiagnosticVirtualTextInfo = make_diagnostic_color(theme.diag.info),
            DiagnosticVirtualTextWarn = make_diagnostic_color(theme.diag.warning),
            DiagnosticVirtualTextError = make_diagnostic_color(theme.diag.error),
          }
        end,
        theme = "dragon",
        background = {
          dark = "dragon",
          light = "lotus",
        },
      }

      kanagawa.load()
    end,
  },
}
