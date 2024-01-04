return {
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   config = function()
  --     if colorscheme == "gruvbox" then
  --       require("gruvbox").setup { contrast = "dark", italics = false }
  --       vim.cmd.colorscheme "gruvbox"
  --     end
  --   end,
  -- },
  -- {
  --   "Shatur/neovim-ayu",
  --   priority = 1000,
  --   config = function()
  --     if colorscheme == "ayu" then
  --       local mirage = false
  --       local colors = require "ayu.colors"
  --       colors.generate(mirage)
  --
  --       local ayu = require "ayu"
  --
  --       ayu.setup {
  --         mirage = mirage,
  --         overrides = function()
  --           return { Comment = { fg = colors.comment } }
  --         end,
  --       }
  --
  --       ayu.colorscheme()
  --     end
  --   end,
  -- },
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
        transparent = false,
        dimInactive = false,
        globalStatus = false,
        terminalColors = true,
        colors = {
          theme = {
            all = {
              ui = {
                -- bg_gutter = "none",
                -- float = {
                -- bg = "none",
                -- },
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme

          return {
            -- cmp-nvim
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
            PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            -- transparent floats
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            -- TelescopeBorder = { bg = "none" },
            -- TelescopeTitle = { bg = "none" },
            -- block-like telescope ui
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
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
  -- {
  --   "phha/zenburn.nvim",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "zenburn"
  --   end,
  -- },
}
