local lush = require "lush"
local hsl = lush.hsl

-- local cherry0 = hsl(346, 67, 62)
-- local cherry1 = cherry0.li(10).de(10)
-- local cherry2 = cherry1.li(20).de(10)
-- local leaf0 = hsl(170, 35, 50)
-- local branch0 = hsl(35, 82, 70)
-- local water0 = hsl(197, 45, 60)
-- local petal0 = hsl(325, 35, 70)
-- local bg0 = hsl(200, 37, 18)
-- local bg1 = bg0.li(5).mix(cherry0, 8).de(5)
-- local bg2 = bg1.li(15)
-- local bg3 = bg2.li(30).de(30)
-- local bg_1 = bg0.da(50).mix(cherry0, 8).de(5)
-- local fg0 = hsl(350, 30, 90)

-- local base = hsl(249, 22, 12)
-- local surface = hsl(247, 23, 15)
-- local overlay = hsl(248, 25, 18)
-- local muted = hsl(249, 12, 47)
-- local subtle = hsl(248, 15, 61)
-- local text = hsl(245, 50, 91)
-- local love = hsl(343, 76, 68)
-- local gold = hsl(35, 88, 72)
-- local rose = hsl(2, 55, 83)
-- local pine = hsl(197, 49, 38)
-- local foam = hsl(189, 43, 73)
-- local iris = hsl(267, 57, 78)
-- local highlight_low = hsl(244, 18, 15)
-- local highlight_med = hsl(249, 15, 28)
-- local highlight_high = hsl(248, 13, 36)

local base = hsl(200, 37, 18)
local surface = base.li(8).ro(0)
local overlay = hsl(248, 25, 18)
local muted = hsl(249, 12, 47)
local subtle = hsl(248, 15, 61)
local text = hsl(350, 30, 90)
local love = hsl(343, 76, 68)
local gold = hsl(35, 88, 72)
local rose = hsl(2, 55, 83)
local pine = hsl(197, 49, 38)
local foam = hsl(189, 43, 73)
local iris = hsl(267, 57, 78)
local highlight_low = hsl(244, 18, 15)
local highlight_med = hsl(249, 15, 28)
local highlight_high = hsl(248, 13, 36)

local palette = {
  base = base,
  surface = surface,
  overlay = overlay,
  muted = muted,
  subtle = subtle,
  text = text,
  love = love,
  gold = gold,
  rose = rose,
  pine = pine,
  foam = foam,
  iris = iris,
  highlight_low = highlight_low,
  highlight_med = highlight_med,
  highlight_high = highlight_high,
}

local defaults = {
  -- diagnostics = { blend = 20 },
  -- diff = { blend = 20 },
  -- gitsigns = { bg = false, blend = 40 },
}

-- ---@param opts wip.Config?
-- function M.setup(opts)
-- opts = vim.tbl_deep_extend("force", M.defaults, opts)
local opts = defaults

return lush(function(injected_functions)
  ---@diagnostic disable: undefined-global
  local sym = injected_functions.sym

  return {
    -- ColorColumn = { bg = palette.surface },
    -- Conceal = { bg = "NONE" },
    -- CurSearch = { fg = palette.base, bg = palette.gold },
    -- Cursor = { fg = palette.text, bg = palette.highlight_high },
    -- CursorColumn = { bg = palette.overlay },
    -- -- CursorIM = {},
    -- CursorLine = { bg = palette.overlay },
    -- CursorLineNr = { fg = palette.text, bold = styles.bold },
    -- -- DarkenedPanel = { },
    -- -- DarkenedStatusline = {},
    -- DiffAdd = { bg = groups.git_add, blend = 20 },
    -- DiffChange = { bg = groups.git_change, blend = 20 },
    -- DiffDelete = { bg = groups.git_delete, blend = 20 },
    -- DiffText = { bg = groups.git_text, blend = 40 },
    -- diffAdded = { link = "DiffAdd" },
    -- diffChanged = { link = "DiffChange" },
    -- diffRemoved = { link = "DiffDelete" },
    -- Directory = { fg = palette.foam, bold = styles.bold },
    -- -- EndOfBuffer = {},
    -- ErrorMsg = { fg = groups.error, bold = styles.bold },
    -- FloatBorder = make_border(),
    -- FloatTitle = { fg = palette.foam, bg = groups.panel, bold = styles.bold },
    -- FoldColumn = { fg = palette.muted },
    -- Folded = { fg = palette.text, bg = groups.panel },
    -- IncSearch = { link = "CurSearch" },
    -- LineNr = { fg = palette.muted },
    -- MatchParen = { fg = palette.pine, bg = palette.pine, blend = 25 },
    -- ModeMsg = { fg = palette.subtle },
    -- MoreMsg = { fg = palette.iris },
    -- NonText = { fg = palette.muted },
    -- Normal = { fg = palette.text, bg = palette.base },
    -- NormalFloat = { bg = groups.panel },
    -- NormalNC = { fg = palette.text, bg = config.options.dim_inactive_windows and palette._nc or palette.base },
    -- NvimInternalError = { link = "ErrorMsg" },
    -- Pmenu = { fg = palette.subtle, bg = groups.panel },
    -- PmenuExtra = { fg = palette.muted, bg = groups.panel },
    -- PmenuExtraSel = { fg = palette.subtle, bg = palette.overlay },
    -- PmenuKind = { fg = palette.foam, bg = groups.panel },
    -- PmenuKindSel = { fg = palette.subtle, bg = palette.overlay },
    -- PmenuSbar = { bg = groups.panel },
    -- PmenuSel = { fg = palette.text, bg = palette.overlay },
    -- PmenuThumb = { bg = palette.muted },
    -- Question = { fg = palette.gold },
    -- QuickFixLine = { fg = palette.foam },
    -- -- RedrawDebugNormal = {},
    -- RedrawDebugClear = { fg = palette.base, bg = palette.gold },
    -- RedrawDebugComposed = { fg = palette.base, bg = palette.pine },
    -- RedrawDebugRecompose = { fg = palette.base, bg = palette.love },
    -- Search = { fg = palette.text, bg = palette.gold, blend = 20 },
    -- SignColumn = { fg = palette.text, bg = "NONE" },
    -- SpecialKey = { fg = palette.foam },
    -- SpellBad = { sp = palette.subtle, undercurl = true },
    -- SpellCap = { sp = palette.subtle, undercurl = true },
    -- SpellLocal = { sp = palette.subtle, undercurl = true },
    -- SpellRare = { sp = palette.subtle, undercurl = true },
    -- StatusLine = { fg = palette.subtle, bg = groups.panel },
    -- StatusLineNC = { fg = palette.muted, bg = groups.panel, blend = 60 },
    -- StatusLineTerm = { fg = palette.base, bg = palette.pine },
    -- StatusLineTermNC = { fg = palette.base, bg = palette.pine, blend = 60 },
    -- Substitute = { link = "IncSearch" },
    -- TabLine = { fg = palette.subtle, bg = groups.panel },
    -- TabLineFill = { bg = groups.panel },
    -- TabLineSel = { fg = palette.text, bg = palette.overlay, bold = styles.bold },
    -- Title = { fg = palette.foam, bold = styles.bold },
    -- VertSplit = { fg = groups.border },
    -- Visual = { bg = palette.iris, blend = 15 },
    -- -- VisualNOS = {},
    -- WarningMsg = { fg = groups.warn, bold = styles.bold },
    -- -- Whitespace = {},
    -- WildMenu = { link = "IncSearch" },
    -- WinBar = { fg = palette.subtle, bg = groups.panel },
    -- WinBarNC = { fg = palette.muted, bg = groups.panel, blend = 60 },
    -- WinSeparator = { fg = groups.border },

    -- DiagnosticError = { fg = groups.error },
    -- DiagnosticHint = { fg = groups.hint },
    -- DiagnosticInfo = { fg = groups.info },
    -- DiagnosticOk = { fg = groups.ok },
    -- DiagnosticWarn = { fg = groups.warn },
    -- DiagnosticDefaultError = { link = "DiagnosticError" },
    -- DiagnosticDefaultHint = { link = "DiagnosticHint" },
    -- DiagnosticDefaultInfo = { link = "DiagnosticInfo" },
    -- DiagnosticDefaultOk = { link = "DiagnosticOk" },
    -- DiagnosticDefaultWarn = { link = "DiagnosticWarn" },
    -- DiagnosticFloatingError = { link = "DiagnosticError" },
    -- DiagnosticFloatingHint = { link = "DiagnosticHint" },
    -- DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
    -- DiagnosticFloatingOk = { link = "DiagnosticOk" },
    -- DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
    -- DiagnosticSignError = { link = "DiagnosticError" },
    -- DiagnosticSignHint = { link = "DiagnosticHint" },
    -- DiagnosticSignInfo = { link = "DiagnosticInfo" },
    -- DiagnosticSignOk = { link = "DiagnosticOk" },
    -- DiagnosticSignWarn = { link = "DiagnosticWarn" },
    -- DiagnosticUnderlineError = { sp = groups.error, undercurl = true },
    -- DiagnosticUnderlineHint = { sp = groups.hint, undercurl = true },
    -- DiagnosticUnderlineInfo = { sp = groups.info, undercurl = true },
    -- DiagnosticUnderlineOk = { sp = groups.ok, undercurl = true },
    -- DiagnosticUnderlineWarn = { sp = groups.warn, undercurl = true },
    -- DiagnosticVirtualTextError = { fg = groups.error, bg = groups.error, blend = 10 },
    -- DiagnosticVirtualTextHint = { fg = groups.hint, bg = groups.hint, blend = 10 },
    -- DiagnosticVirtualTextInfo = { fg = groups.info, bg = groups.info, blend = 10 },
    -- DiagnosticVirtualTextOk = { fg = groups.ok, bg = groups.ok, blend = 10 },
    -- DiagnosticVirtualTextWarn = { fg = groups.warn, bg = groups.warn, blend = 10 },

    -- Boolean = { fg = palette.rose },
    -- Character = { fg = palette.gold },
    -- Comment = { fg = palette.subtle, italic = styles.italic },
    -- Conditional = { fg = palette.pine },
    -- Constant = { fg = palette.gold },
    -- Debug = { fg = palette.rose },
    -- Define = { fg = palette.iris },
    -- Delimiter = { fg = palette.subtle },
    -- Error = { fg = palette.love },
    -- Exception = { fg = palette.pine },
    -- Float = { fg = palette.gold },
    -- Function = { fg = palette.rose },
    -- Identifier = { fg = palette.text },
    -- Include = { fg = palette.pine },
    -- Keyword = { fg = palette.pine },
    -- Label = { fg = palette.foam },
    -- LspCodeLens = { fg = palette.subtle },
    -- LspCodeLensSeparator = { fg = palette.muted },
    -- LspInlayHint = { fg = palette.muted, bg = palette.muted, blend = 10 },
    -- LspReferenceRead = { bg = palette.highlight_med },
    -- LspReferenceText = { bg = palette.highlight_med },
    -- LspReferenceWrite = { bg = palette.highlight_med },
    -- Macro = { fg = palette.iris },
    -- Number = { fg = palette.gold },
    -- Operator = { fg = palette.subtle },
    -- PreCondit = { fg = palette.iris },
    -- PreProc = { link = "PreCondit" },
    -- Repeat = { fg = palette.pine },
    -- Special = { fg = palette.foam },
    -- SpecialChar = { link = "Special" },
    -- SpecialComment = { fg = palette.iris },
    -- Statement = { fg = palette.pine, bold = styles.bold },
    -- StorageClass = { fg = palette.foam },
    -- String = { fg = palette.gold },
    -- Structure = { fg = palette.foam },
    -- Tag = { fg = palette.foam },
    -- Todo = { fg = palette.rose, bg = palette.rose, blend = 20 },
    -- Type = { fg = palette.foam },
    -- TypeDef = { link = "Type" },
    -- Underlined = { fg = palette.iris, underline = true },

    -- healthError = { fg = groups.error },
    -- healthSuccess = { fg = groups.info },
    -- healthWarning = { fg = groups.warn },

    -- htmlArg = { fg = palette.iris },
    -- htmlBold = { bold = styles.bold },
    -- htmlEndTag = { fg = palette.subtle },
    -- htmlH1 = { link = "markdownH1" },
    -- htmlH2 = { link = "markdownH2" },
    -- htmlH3 = { link = "markdownH3" },
    -- htmlH4 = { link = "markdownH4" },
    -- htmlH5 = { link = "markdownH5" },
    -- htmlItalic = { italic = styles.italic },
    -- htmlLink = { link = "markdownUrl" },
    -- htmlTag = { fg = palette.subtle },
    -- htmlTagN = { fg = palette.text },
    -- htmlTagName = { fg = palette.foam },

    -- markdownDelimiter = { fg = palette.subtle },
    -- markdownH1 = { fg = groups.h1, bold = styles.bold },
    -- markdownH1Delimiter = { link = "markdownH1" },
    -- markdownH2 = { fg = groups.h2, bold = styles.bold },
    -- markdownH2Delimiter = { link = "markdownH2" },
    -- markdownH3 = { fg = groups.h3, bold = styles.bold },
    -- markdownH3Delimiter = { link = "markdownH3" },
    -- markdownH4 = { fg = groups.h4, bold = styles.bold },
    -- markdownH4Delimiter = { link = "markdownH4" },
    -- markdownH5 = { fg = groups.h5, bold = styles.bold },
    -- markdownH5Delimiter = { link = "markdownH5" },
    -- markdownH6 = { fg = groups.h6, bold = styles.bold },
    -- markdownH6Delimiter = { link = "markdownH6" },
    -- markdownLinkText = { link = "markdownUrl" },
    -- markdownUrl = { fg = groups.link, sp = groups.link, underline = true },

    -- mkdCode = { fg = palette.foam, italic = styles.italic },
    -- mkdCodeDelimiter = { fg = palette.rose },
    -- mkdCodeEnd = { fg = palette.foam },
    -- mkdCodeStart = { fg = palette.foam },
    -- mkdFootnotes = { fg = palette.foam },
    -- mkdID = { fg = palette.foam, underline = true },
    -- mkdInlineURL = { link = "markdownUrl" },
    -- mkdLink = { link = "markdownUrl" },
    -- mkdLinkDef = { link = "markdownUrl" },
    -- mkdListItemLine = { fg = palette.text },
    -- mkdRule = { fg = palette.subtle },
    -- mkdURL = { link = "markdownUrl" },

    -- --- Treesitter
    -- --- |:help treesitter-highlight-groups|
    -- ["@variable"] = { fg = palette.text, italic = styles.italic },
    -- ["@variable.builtin"] = { fg = palette.love, italic = styles.italic, bold = styles.bold },
    -- ["@variable.parameter"] = { fg = palette.iris, italic = styles.italic },
    -- ["@variable.parameter.builtin"] = { fg = palette.iris, italic = styles.italic, bold = styles.bold },
    -- ["@variable.member"] = { fg = palette.foam },

    -- ["@constant"] = { fg = palette.gold },
    -- ["@constant.builtin"] = { fg = palette.gold, bold = styles.bold },
    -- ["@constant.macro"] = { fg = palette.gold },

    -- ["@module"] = { fg = palette.text },
    -- ["@module.builtin"] = { fg = palette.text, bold = styles.bold },
    -- ["@label"] = { link = "Label" },

    -- ["@string"] = { link = "String" },
    -- -- ["@string.documentation"] = {},
    -- ["@string.regexp"] = { fg = palette.iris },
    -- ["@string.escape"] = { fg = palette.pine },
    -- ["@string.special"] = { link = "String" },
    -- ["@string.special.symbol"] = { link = "Identifier" },
    -- ["@string.special.url"] = { fg = groups.link },
    -- -- ["@string.special.path"] = {},

    -- ["@character"] = { link = "Character" },
    -- ["@character.special"] = { link = "Character" },

    -- ["@boolean"] = { link = "Boolean" },
    -- ["@number"] = { link = "Number" },
    -- ["@number.float"] = { link = "Number" },
    -- ["@float"] = { link = "Number" },

    -- ["@type"] = { fg = palette.foam },
    -- ["@type.builtin"] = { fg = palette.foam, bold = styles.bold },
    -- -- ["@type.definition"] = {},

    -- ["@attribute"] = { fg = palette.iris },
    -- ["@attribute.builtin"] = { fg = palette.iris, bold = styles.bold },
    -- ["@property"] = { fg = palette.foam, italic = styles.italic },

    -- ["@function"] = { fg = palette.rose },
    -- ["@function.builtin"] = { fg = palette.rose, bold = styles.bold },
    -- -- ["@function.call"] = {},
    -- ["@function.macro"] = { link = "Function" },

    -- ["@function.method"] = { fg = palette.rose },
    -- ["@function.method.call"] = { fg = palette.iris },

    -- ["@constructor"] = { fg = palette.foam },
    -- ["@operator"] = { link = "Operator" },

    -- ["@keyword"] = { link = "Keyword" },
    -- -- ["@keyword.coroutine"] = {},
    -- -- ["@keyword.function"] = {},
    -- ["@keyword.operator"] = { fg = palette.subtle },
    -- ["@keyword.import"] = { fg = palette.pine },
    -- ["@keyword.storage"] = { fg = palette.foam },
    -- ["@keyword.repeat"] = { fg = palette.pine },
    -- ["@keyword.return"] = { fg = palette.pine },
    -- ["@keyword.debug"] = { fg = palette.rose },
    -- ["@keyword.exception"] = { fg = palette.pine },

    -- ["@keyword.conditional"] = { fg = palette.pine },
    -- ["@keyword.conditional.ternary"] = { fg = palette.pine },

    -- ["@keyword.directive"] = { fg = palette.iris },
    -- ["@keyword.directive.define"] = { fg = palette.iris },

    -- --- Punctuation
    -- ["@punctuation.delimiter"] = { fg = palette.subtle },
    -- ["@punctuation.bracket"] = { fg = palette.subtle },
    -- ["@punctuation.special"] = { fg = palette.subtle },

    -- --- Comments
    -- ["@comment"] = { link = "Comment" },
    -- -- ["@comment.documentation"] = {},

    -- ["@comment.error"] = { fg = groups.error },
    -- ["@comment.warning"] = { fg = groups.warn },
    -- ["@comment.todo"] = { fg = groups.todo, bg = groups.todo, blend = 15 },
    -- ["@comment.hint"] = { fg = groups.hint, bg = groups.hint, blend = 15 },
    -- ["@comment.info"] = { fg = groups.info, bg = groups.info, blend = 15 },
    -- ["@comment.note"] = { fg = groups.note, bg = groups.note, blend = 15 },

    -- --- Markup
    -- ["@markup.strong"] = { bold = styles.bold },
    -- ["@markup.italic"] = { italic = styles.italic },
    -- ["@markup.strikethrough"] = { strikethrough = true },
    -- ["@markup.underline"] = { underline = true },

    -- ["@markup.heading"] = { fg = palette.foam, bold = styles.bold },

    -- ["@markup.quote"] = { fg = palette.text },
    -- ["@markup.math"] = { link = "Special" },
    -- ["@markup.environment"] = { link = "Macro" },
    -- ["@markup.environment.name"] = { link = "@type" },

    -- -- ["@markup.link"] = {},
    -- ["@markup.link.markdown_inline"] = { fg = palette.subtle },
    -- ["@markup.link.label.markdown_inline"] = { fg = palette.foam },
    -- ["@markup.link.url"] = { fg = groups.link },

    -- -- ["@markup.raw"] = { bg = palette.surface },
    -- -- ["@markup.raw.block"] = { bg = palette.surface },
    -- ["@markup.raw.delimiter.markdown"] = { fg = palette.subtle },

    -- ["@markup.list"] = { fg = palette.pine },
    -- ["@markup.list.checked"] = { fg = palette.foam, bg = palette.foam, blend = 10 },
    -- ["@markup.list.unchecked"] = { fg = palette.text },

    -- -- Markdown headings
    -- ["@markup.heading.1.markdown"] = { link = "markdownH1" },
    -- ["@markup.heading.2.markdown"] = { link = "markdownH2" },
    -- ["@markup.heading.3.markdown"] = { link = "markdownH3" },
    -- ["@markup.heading.4.markdown"] = { link = "markdownH4" },
    -- ["@markup.heading.5.markdown"] = { link = "markdownH5" },
    -- ["@markup.heading.6.markdown"] = { link = "markdownH6" },
    -- ["@markup.heading.1.marker.markdown"] = { link = "markdownH1Delimiter" },
    -- ["@markup.heading.2.marker.markdown"] = { link = "markdownH2Delimiter" },
    -- ["@markup.heading.3.marker.markdown"] = { link = "markdownH3Delimiter" },
    -- ["@markup.heading.4.marker.markdown"] = { link = "markdownH4Delimiter" },
    -- ["@markup.heading.5.marker.markdown"] = { link = "markdownH5Delimiter" },
    -- ["@markup.heading.6.marker.markdown"] = { link = "markdownH6Delimiter" },

    -- ["@diff.plus"] = { fg = groups.git_add, bg = groups.git_add, blend = 20 },
    -- ["@diff.minus"] = { fg = groups.git_delete, bg = groups.git_delete, blend = 20 },
    -- ["@diff.delta"] = { bg = groups.git_change, blend = 20 },

    -- ["@tag"] = { link = "Tag" },
    -- ["@tag.attribute"] = { fg = palette.iris },
    -- ["@tag.delimiter"] = { fg = palette.subtle },

    -- --- Non-highlighting captures
    -- -- ["@none"] = {},
    -- ["@conceal"] = { link = "Conceal" },
    -- ["@conceal.markdown"] = { fg = palette.subtle },

    -- --- Semantic highlights
    -- ["@lsp.type.comment"] = {},
    -- ["@lsp.type.comment.c"] = { link = "@comment" },
    -- ["@lsp.type.comment.cpp"] = { link = "@comment" },
    -- ["@lsp.type.enum"] = { link = "@type" },
    -- ["@lsp.type.interface"] = { link = "@interface" },
    -- ["@lsp.type.keyword"] = { link = "@keyword" },
    -- ["@lsp.type.namespace"] = { link = "@namespace" },
    -- ["@lsp.type.namespace.python"] = { link = "@variable" },
    -- ["@lsp.type.parameter"] = { link = "@parameter" },
    -- ["@lsp.type.property"] = { link = "@property" },
    -- ["@lsp.type.variable"] = {}, -- defer to treesitter for regular variables
    -- ["@lsp.type.variable.svelte"] = { link = "@variable" },
    -- ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    -- ["@lsp.typemod.operator.injected"] = { link = "@operator" },
    -- ["@lsp.typemod.string.injected"] = { link = "@string" },
    -- ["@lsp.typemod.variable.constant"] = { link = "@constant" },
    -- ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    -- ["@lsp.typemod.variable.injected"] = { link = "@variable" },

    --- Plugins
    -- -- lewis6991/gitsigns.nvim
    -- GitSignsAdd = { fg = groups.git_add, bg = "NONE" },
    -- GitSignsChange = { fg = groups.git_change, bg = "NONE" },
    -- GitSignsDelete = { fg = groups.git_delete, bg = "NONE" },
    -- SignAdd = { fg = groups.git_add, bg = "NONE" },
    -- SignChange = { fg = groups.git_change, bg = "NONE" },
    -- SignDelete = { fg = groups.git_delete, bg = "NONE" },

    -- -- mvllow/modes.nvim
    -- ModesCopy = { bg = palette.gold },
    -- ModesDelete = { bg = palette.love },
    -- ModesInsert = { bg = palette.foam },
    -- ModesReplace = { bg = palette.pine },
    -- ModesVisual = { bg = palette.iris },

    -- -- nvim-neotest/neotest
    -- NeotestAdapterName = { fg = palette.iris },
    -- NeotestBorder = { fg = palette.highlight_med },
    -- NeotestDir = { fg = palette.foam },
    -- NeotestExpandMarker = { fg = palette.highlight_med },
    -- NeotestFailed = { fg = palette.love },
    -- NeotestFile = { fg = palette.text },
    -- NeotestFocused = { fg = palette.gold, bg = palette.highlight_med },
    -- NeotestIndent = { fg = palette.highlight_med },
    -- NeotestMarked = { fg = palette.rose, bold = styles.bold },
    -- NeotestNamespace = { fg = palette.gold },
    -- NeotestPassed = { fg = palette.pine },
    -- NeotestRunning = { fg = palette.gold },
    -- NeotestWinSelect = { fg = palette.muted },
    -- NeotestSkipped = { fg = palette.subtle },
    -- NeotestTarget = { fg = palette.love },
    -- NeotestTest = { fg = palette.gold },
    -- NeotestUnknown = { fg = palette.subtle },
    -- NeotestWatching = { fg = palette.iris },

    -- -- folke/which-key.nvim
    -- WhichKey = { fg = palette.iris },
    -- WhichKeyBorder = make_border(),
    -- WhichKeyDesc = { fg = palette.gold },
    -- WhichKeyFloat = { bg = groups.panel },
    -- WhichKeyGroup = { fg = palette.foam },
    -- WhichKeyIcon = { fg = palette.pine },
    -- WhichKeyIconAzure = { fg = palette.pine },
    -- WhichKeyIconBlue = { fg = palette.pine },
    -- WhichKeyIconCyan = { fg = palette.foam },
    -- WhichKeyIconGreen = { fg = palette.leaf },
    -- WhichKeyIconGrey = { fg = palette.subtle },
    -- WhichKeyIconOrange = { fg = palette.rose },
    -- WhichKeyIconPurple = { fg = palette.iris },
    -- WhichKeyIconRed = { fg = palette.love },
    -- WhichKeyIconYellow = { fg = palette.gold },
    -- WhichKeyNormal = { link = "NormalFloat" },
    -- WhichKeySeparator = { fg = palette.subtle },
    -- WhichKeyTitle = { link = "FloatTitle" },
    -- WhichKeyValue = { fg = palette.rose },

    -- -- NeogitOrg/neogit
    -- -- https://github.com/NeogitOrg/neogit/blob/master/lua/neogit/lib/hl.lua#L109-L198
    -- NeogitChangeAdded = { fg = groups.git_add, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeBothModified = { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeCopied = { fg = groups.git_untracked, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeDeleted = { fg = groups.git_delete, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeModified = { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeNewFile = { fg = groups.git_stage, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeRenamed = { fg = groups.git_rename, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeUpdated = { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
    -- NeogitDiffAddHighlight = { link = "DiffAdd" },
    -- NeogitDiffContextHighlight = { bg = palette.surface },
    -- NeogitDiffDeleteHighlight = { link = "DiffDelete" },
    -- NeogitFilePath = { fg = palette.foam, italic = styles.italic },
    -- NeogitHunkHeader = { bg = groups.panel },
    -- NeogitHunkHeaderHighlight = { bg = groups.panel },

    -- -- folke/trouble.nvim
    -- TroubleText = { fg = palette.subtle },
    -- TroubleCount = { fg = palette.iris, bg = palette.surface },
    -- TroubleNormal = { fg = palette.text, bg = groups.panel },

    -- -- echasnovski/mini.nvim
    -- MiniCursorword = { underline = true },
    -- MiniCursorwordCurrent = { underline = true },

    -- MiniJump = { sp = palette.gold, undercurl = true },

    -- -- nvim-treesitter/nvim-treesitter-context
    -- TreesitterContext = { bg = palette.overlay },
    -- TreesitterContextLineNumber = { fg = palette.rose, bg = palette.overlay },

    -- -- MeanderingProgrammer/render-markdown.nvim
    -- RenderMarkdownBullet = { fg = palette.rose },
    -- RenderMarkdownChecked = { fg = palette.foam },
    -- RenderMarkdownCode = { bg = palette.overlay },
    -- RenderMarkdownCodeInline = { fg = palette.text, bg = palette.overlay },
    -- RenderMarkdownDash = { fg = palette.muted },
    -- RenderMarkdownH1Bg = { bg = groups.h1, blend = 20 },
    -- RenderMarkdownH2Bg = { bg = groups.h2, blend = 20 },
    -- RenderMarkdownH3Bg = { bg = groups.h3, blend = 20 },
    -- RenderMarkdownH4Bg = { bg = groups.h4, blend = 20 },
    -- RenderMarkdownH5Bg = { bg = groups.h5, blend = 20 },
    -- RenderMarkdownH6Bg = { bg = groups.h6, blend = 20 },
    -- RenderMarkdownQuote = { fg = palette.subtle },
    -- RenderMarkdownTableFill = { link = "Conceal" },
    -- RenderMarkdownTableHead = { fg = palette.subtle },
    -- RenderMarkdownTableRow = { fg = palette.subtle },
    -- RenderMarkdownUnchecked = { fg = palette.subtle },

    -- -- Saghen/blink.cmp
    -- BlinkCmpDoc = { bg = palette.highlight_low },
    -- BlinkCmpDocSeparator = { bg = palette.highlight_low },
    -- BlinkCmpDocBorder = { fg = palette.highlight_high },
    -- BlinkCmpGhostText = { fg = palette.muted },

    -- BlinkCmpLabel = { fg = palette.muted },
    -- BlinkCmpLabelDeprecated = { fg = palette.muted, strikethrough = true },
    -- BlinkCmpLabelMatch = { fg = palette.text, bold = styles.bold },

    -- BlinkCmpDefault = { fg = palette.highlight_med },
    -- BlinkCmpKindText = { fg = palette.pine },
    -- BlinkCmpKindMethod = { fg = palette.foam },
    -- BlinkCmpKindFunction = { fg = palette.foam },
    -- BlinkCmpKindConstructor = { fg = palette.foam },
    -- BlinkCmpKindField = { fg = palette.pine },
    -- BlinkCmpKindVariable = { fg = palette.rose },
    -- BlinkCmpKindClass = { fg = palette.gold },
    -- BlinkCmpKindInterface = { fg = palette.gold },
    -- BlinkCmpKindModule = { fg = palette.foam },
    -- BlinkCmpKindProperty = { fg = palette.foam },
    -- BlinkCmpKindUnit = { fg = palette.pine },
    -- BlinkCmpKindValue = { fg = palette.love },
    -- BlinkCmpKindKeyword = { fg = palette.iris },
    -- BlinkCmpKindSnippet = { fg = palette.rose },
    -- BlinkCmpKindColor = { fg = palette.love },
    -- BlinkCmpKindFile = { fg = palette.foam },
    -- BlinkCmpKindReference = { fg = palette.love },
    -- BlinkCmpKindFolder = { fg = palette.foam },
    -- BlinkCmpKindEnum = { fg = palette.foam },
    -- BlinkCmpKindEnumMember = { fg = palette.foam },
    -- BlinkCmpKindConstant = { fg = palette.gold },
    -- BlinkCmpKindStruct = { fg = palette.foam },
    -- BlinkCmpKindEvent = { fg = palette.foam },
    -- BlinkCmpKindOperator = { fg = palette.foam },
    -- BlinkCmpKindTypeParameter = { fg = palette.iris },
    -- BlinkCmpKindCodeium = { fg = palette.foam },
    -- BlinkCmpKindCopilot = { fg = palette.foam },
    -- BlinkCmpKindSupermaven = { fg = palette.foam },
    -- BlinkCmpKindTabNine = { fg = palette.foam },

    -- -- folke/snacks.nvim
    -- SnacksIndent = { fg = palette.overlay },
    -- SnacksIndentChunk = { fg = palette.overlay },
    -- SnacksIndentBlank = { fg = palette.overlay },
    -- SnacksIndentScope = { fg = palette.foam },
    -- SnacksPickerMatch = { fg = palette.rose, bold = styles.bold },
  }
end)
