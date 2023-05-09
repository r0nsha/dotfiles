local colorscheme = "kanagawa"

return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup { contrast = "dark", italics = false }
      if colorscheme == "gruvbox" then
        vim.cmd [[colorscheme gruvbox]]
      end
    end,
  },
  {
    "Shatur/neovim-ayu",
    priority = 1000,
    config = function()
      local mirage = false
      local colors = require "ayu.colors"
      colors.generate(mirage)

      local ayu = require "ayu"

      ayu.setup {
        mirage = mirage,
        overrides = function()
          return { Comment = { fg = colors.comment } }
        end,
      }

      if colorscheme == "ayu" then
        ayu.colorscheme()
      end
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
      require("nightfox").setup()

      if colorscheme == "nightfox" then
        vim.cmd [[colorscheme nordfox]]
      end
    end,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup {
        style = "storm",
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
        },
      }

      if colorscheme == "tokyonight" then
        vim.cmd [[colorscheme tokyonight]]
      end
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup {
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
        globalStatus = false,
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
            -- cmp-nvim
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            -- transparent floats
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          }
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus",
        },
      }

      if colorscheme == "kanagawa" then
        vim.cmd [[colorscheme kanagawa]]
      end
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup {}

      if colorscheme == "catppuccin" then
        vim.cmd [[colorscheme catppuccin]]
      end
    end,
  },
}
