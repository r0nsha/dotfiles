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
local surface = base.li(6).ro(2)
local overlay = hsl(248, 25, 18)
local muted = hsl(249, 12, 47)
local subtle = hsl(248, 15, 61)
local text = hsl(350, 30, 90)
local cherry = hsl(343, 76, 68)
local blossom = hsl(267, 57, 78)
local petal = hsl(2, 55, 83)
local branch = hsl(35, 88, 72)
local leaf = hsl(197, 49, 38)
local river = hsl(189, 43, 73)
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
  cherry = cherry,
  blossom = blossom,
  petal = petal,
  branch = branch,
  leaf = leaf,
  river = river,
  highlight_low = highlight_low,
  highlight_med = highlight_med,
  highlight_high = highlight_high,
}

local groups = {
  border = muted,
  link = blossom,
  panel = surface,

  error = cherry,
  hint = blossom,
  info = river,
  ok = leaf,
  warn = branch,
  note = leaf,
  todo = blossom,

  git_add = river,
  git_change = blossom,
  git_delete = cherry,
  git_dirty = blossom,
  git_ignore = muted,
  git_merge = blossom,
  git_rename = leaf,
  git_stage = blossom,
  git_text = blossom,
  git_untracked = subtle,

  h1 = blossom,
  h2 = river,
  h3 = blossom,
  h4 = branch,
  h5 = leaf,
  h6 = leaf,
}

local p = palette
local g = groups

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
    Normal { fg = p.text, bg = p.base },
    NormalFloat { bg = g.panel },
    NormalNC { fg = p.text, bg = p.base },
    ColorColumn { bg = p.surface },

    -- conceal
    Conceal { bg = p.overlay, fg = p.subtle },

    -- search
    -- Search { fg = p.text, bg = p.gold, blend = 20 },
    -- IncSearch { link = "CurSearch" },
    -- CurSearch { fg = p.base, bg = p.gold },

    -- cursor
    -- Cursor { fg = p.text, bg = p.highlight_high },
    -- CursorLine { bg = p.overlay },
    -- CursorColumn { bg = p.overlay },
    -- NonText { fg = p.muted },

    -- statuscolumn
    -- LineNr { fg = p.muted },
    -- CursorLineNr { fg = p.text, bold = styles.bold },

    -- diff
    -- DiffAdd { bg = groups.git_add, blend = 20 },
    -- DiffChange { bg = groups.git_change, blend = 20 },
    -- DiffDelete { bg = groups.git_delete, blend = 20 },
    -- DiffText { bg = groups.git_text, blend = 40 },
    -- diffAdded { link = "DiffAdd" },
    -- diffChanged { link = "DiffChange" },
    -- diffRemoved { link = "DiffDelete" },
    -- Directory { fg = p.foam, bold = styles.bold },
    -- EndOfBuffer { fg = p.highlight_low },
    -- ErrorMsg { fg = groups.error, bold = styles.bold },

    -- folds
    -- FoldColumn { fg = p.muted },
    -- Folded { fg = p.text, bg = groups.panel },

    -- MatchParen { fg = p.pine, bg = p.pine, blend = 25 },
    -- NvimInternalError { link = "ErrorMsg" },
    -- ModeMsg { fg = p.subtle },
    -- MoreMsg { fg = p.iris },

    -- menu
    -- Pmenu { fg = p.subtle, bg = groups.panel },
    -- PmenuExtra { fg = p.muted, bg = groups.panel },
    -- PmenuExtraSel { fg = p.subtle, bg = p.overlay },
    -- PmenuKind { fg = p.foam, bg = groups.panel },
    -- PmenuKindSel { fg = p.subtle, bg = p.overlay },
    -- PmenuSbar { bg = groups.panel },
    -- PmenuSel { fg = p.text, bg = p.overlay },
    -- PmenuThumb { bg = p.muted },

    -- floats
    -- Float { fg = p.gold },
    -- FloatBorder make_border(),
    -- FloatTitle { fg = p.foam, bg = groups.panel, bold = styles.bold },

    -- Question { fg = p.gold },
    -- QuickFixLine { fg = p.foam },
    -- -- RedrawDebugNormal {},
    -- RedrawDebugClear { fg = p.base, bg = p.gold },
    -- RedrawDebugComposed { fg = p.base, bg = p.pine },
    -- RedrawDebugRecompose { fg = p.base, bg = p.love },
    -- SignColumn { fg = p.text, bg = "NONE" },
    -- SpecialKey { fg = p.foam },
    -- SpellBad { sp = p.subtle, undercurl = true },
    -- SpellCap { sp = p.subtle, undercurl = true },
    -- SpellLocal { sp = p.subtle, undercurl = true },
    -- SpellRare { sp = p.subtle, undercurl = true },
    -- StatusLine { fg = p.subtle, bg = groups.panel },
    -- StatusLineNC { fg = p.muted, bg = groups.panel, blend = 60 },
    -- StatusLineTerm { fg = p.base, bg = p.pine },
    -- StatusLineTermNC { fg = p.base, bg = p.pine, blend = 60 },
    -- Substitute { link = "IncSearch" },
    -- TabLine { fg = p.subtle, bg = groups.panel },
    -- TabLineFill { bg = groups.panel },
    -- TabLineSel { fg = p.text, bg = p.overlay, bold = styles.bold },
    -- Title { fg = p.foam, bold = styles.bold },
    -- VertSplit { fg = groups.border },
    -- Visual { bg = p.iris, blend = 15 },
    -- -- VisualNOS {},
    -- WarningMsg { fg = groups.warn, bold = styles.bold },
    -- -- Whitespace {},
    -- WildMenu { link = "IncSearch" },
    -- WinBar { fg = p.subtle, bg = groups.panel },
    -- WinBarNC { fg = p.muted, bg = groups.panel, blend = 60 },
    -- WinSeparator { fg = groups.border },

    -- diagnostics
    -- DiagnosticError { fg = groups.error },
    -- DiagnosticHint { fg = groups.hint },
    -- DiagnosticInfo { fg = groups.info },
    -- DiagnosticOk { fg = groups.ok },
    -- DiagnosticWarn { fg = groups.warn },
    -- DiagnosticDefaultError { link = "DiagnosticError" },
    -- DiagnosticDefaultHint { link = "DiagnosticHint" },
    -- DiagnosticDefaultInfo { link = "DiagnosticInfo" },
    -- DiagnosticDefaultOk { link = "DiagnosticOk" },
    -- DiagnosticDefaultWarn { link = "DiagnosticWarn" },
    -- DiagnosticFloatingError { link = "DiagnosticError" },
    -- DiagnosticFloatingHint { link = "DiagnosticHint" },
    -- DiagnosticFloatingInfo { link = "DiagnosticInfo" },
    -- DiagnosticFloatingOk { link = "DiagnosticOk" },
    -- DiagnosticFloatingWarn { link = "DiagnosticWarn" },
    -- DiagnosticSignError { link = "DiagnosticError" },
    -- DiagnosticSignHint { link = "DiagnosticHint" },
    -- DiagnosticSignInfo { link = "DiagnosticInfo" },
    -- DiagnosticSignOk { link = "DiagnosticOk" },
    -- DiagnosticSignWarn { link = "DiagnosticWarn" },
    -- DiagnosticUnderlineError { sp = groups.error, undercurl = true },
    -- DiagnosticUnderlineHint { sp = groups.hint, undercurl = true },
    -- DiagnosticUnderlineInfo { sp = groups.info, undercurl = true },
    -- DiagnosticUnderlineOk { sp = groups.ok, undercurl = true },
    -- DiagnosticUnderlineWarn { sp = groups.warn, undercurl = true },
    -- DiagnosticVirtualTextError { fg = groups.error, bg = groups.error, blend = 10 },
    -- DiagnosticVirtualTextHint { fg = groups.hint, bg = groups.hint, blend = 10 },
    -- DiagnosticVirtualTextInfo { fg = groups.info, bg = groups.info, blend = 10 },
    -- DiagnosticVirtualTextOk { fg = groups.ok, bg = groups.ok, blend = 10 },
    -- DiagnosticVirtualTextWarn { fg = groups.warn, bg = groups.warn, blend = 10 },

    -- syntax
    -- Boolean { fg = p.rose },
    -- Character { fg = p.gold },
    -- Comment { fg = p.subtle, italic = styles.italic },
    -- Conditional { fg = p.pine },
    -- Constant { fg = p.gold },
    -- Debug { fg = p.rose },
    -- Define { fg = p.iris },
    -- Delimiter { fg = p.subtle },
    -- Error { fg = p.love },
    -- Exception { fg = p.pine },
    -- Function { fg = p.rose },
    -- Identifier { fg = p.text },
    -- Include { fg = p.pine },
    -- Keyword { fg = p.pine },
    -- Label { fg = p.foam },
    -- LspCodeLens { fg = p.subtle },
    -- LspCodeLensSeparator { fg = p.muted },
    -- LspInlayHint { fg = p.muted, bg = p.muted, blend = 10 },
    -- LspReferenceRead { bg = p.highlight_med },
    -- LspReferenceText { bg = p.highlight_med },
    -- LspReferenceWrite { bg = p.highlight_med },
    -- Macro { fg = p.iris },
    -- Number { fg = p.gold },
    -- Operator { fg = p.subtle },
    -- PreCondit { fg = p.iris },
    -- PreProc { link = "PreCondit" },
    -- Repeat { fg = p.pine },
    -- Special { fg = p.foam },
    -- SpecialChar { link = "Special" },
    -- SpecialComment { fg = p.iris },
    -- Statement { fg = p.pine, bold = styles.bold },
    -- StorageClass { fg = p.foam },
    -- String { fg = p.gold },
    -- Structure { fg = p.foam },
    -- Tag { fg = p.foam },
    -- Todo { fg = p.rose, bg = p.rose, blend = 20 },
    -- Type { fg = p.foam },
    -- TypeDef { link = "Type" },
    -- Underlined { fg = p.iris, underline = true },

    -- health
    -- healthError { fg = groups.error },
    -- healthSuccess { fg = groups.info },
    -- healthWarning { fg = groups.warn },

    -- html
    -- htmlArg { fg = p.iris },
    -- htmlBold { bold = styles.bold },
    -- htmlEndTag { fg = p.subtle },
    -- htmlH1 { link = "markdownH1" },
    -- htmlH2 { link = "markdownH2" },
    -- htmlH3 { link = "markdownH3" },
    -- htmlH4 { link = "markdownH4" },
    -- htmlH5 { link = "markdownH5" },
    -- htmlItalic { italic = styles.italic },
    -- htmlLink { link = "markdownUrl" },
    -- htmlTag { fg = p.subtle },
    -- htmlTagN { fg = p.text },
    -- htmlTagName { fg = p.foam },

    -- markdownDelimiter { fg = p.subtle },
    -- markdownH1 { fg = groups.h1, bold = styles.bold },
    -- markdownH1Delimiter { link = "markdownH1" },
    -- markdownH2 { fg = groups.h2, bold = styles.bold },
    -- markdownH2Delimiter { link = "markdownH2" },
    -- markdownH3 { fg = groups.h3, bold = styles.bold },
    -- markdownH3Delimiter { link = "markdownH3" },
    -- markdownH4 { fg = groups.h4, bold = styles.bold },
    -- markdownH4Delimiter { link = "markdownH4" },
    -- markdownH5 { fg = groups.h5, bold = styles.bold },
    -- markdownH5Delimiter { link = "markdownH5" },
    -- markdownH6 { fg = groups.h6, bold = styles.bold },
    -- markdownH6Delimiter { link = "markdownH6" },
    -- markdownLinkText { link = "markdownUrl" },
    -- markdownUrl { fg = groups.link, sp = groups.link, underline = true },

    -- mkdCode { fg = p.foam, italic = styles.italic },
    -- mkdCodeDelimiter { fg = p.rose },
    -- mkdCodeEnd { fg = p.foam },
    -- mkdCodeStart { fg = p.foam },
    -- mkdFootnotes { fg = p.foam },
    -- mkdID { fg = p.foam, underline = true },
    -- mkdInlineURL { link = "markdownUrl" },
    -- mkdLink { link = "markdownUrl" },
    -- mkdLinkDef { link = "markdownUrl" },
    -- mkdListItemLine { fg = p.text },
    -- mkdRule { fg = p.subtle },
    -- mkdURL { link = "markdownUrl" },

    -- --- Treesitter
    -- --- |:help treesitter-highlight-groups|
    -- ["@variable"] { fg = p.text, italic = styles.italic },
    -- ["@variable.builtin"] { fg = p.love, italic = styles.italic, bold = styles.bold },
    -- ["@variable.parameter"] { fg = p.iris, italic = styles.italic },
    -- ["@variable.parameter.builtin"] { fg = p.iris, italic = styles.italic, bold = styles.bold },
    -- ["@variable.member"] { fg = p.foam },

    -- ["@constant"] { fg = p.gold },
    -- ["@constant.builtin"] { fg = p.gold, bold = styles.bold },
    -- ["@constant.macro"] { fg = p.gold },

    -- ["@module"] { fg = p.text },
    -- ["@module.builtin"] { fg = p.text, bold = styles.bold },
    -- ["@label"] { link = "Label" },

    -- ["@string"] { link = "String" },
    -- -- ["@string.documentation"] {},
    -- ["@string.regexp"] { fg = p.iris },
    -- ["@string.escape"] { fg = p.pine },
    -- ["@string.special"] { link = "String" },
    -- ["@string.special.symbol"] { link = "Identifier" },
    -- ["@string.special.url"] { fg = groups.link },
    -- -- ["@string.special.path"] {},

    -- ["@character"] { link = "Character" },
    -- ["@character.special"] { link = "Character" },

    -- ["@boolean"] { link = "Boolean" },
    -- ["@number"] { link = "Number" },
    -- ["@number.float"] { link = "Number" },
    -- ["@float"] { link = "Number" },

    -- ["@type"] { fg = p.foam },
    -- ["@type.builtin"] { fg = p.foam, bold = styles.bold },
    -- -- ["@type.definition"] {},

    -- ["@attribute"] { fg = p.iris },
    -- ["@attribute.builtin"] { fg = p.iris, bold = styles.bold },
    -- ["@property"] { fg = p.foam, italic = styles.italic },

    -- ["@function"] { fg = p.rose },
    -- ["@function.builtin"] { fg = p.rose, bold = styles.bold },
    -- -- ["@function.call"] {},
    -- ["@function.macro"] { link = "Function" },

    -- ["@function.method"] { fg = p.rose },
    -- ["@function.method.call"] { fg = p.iris },

    -- ["@constructor"] { fg = p.foam },
    -- ["@operator"] { link = "Operator" },

    -- ["@keyword"] { link = "Keyword" },
    -- -- ["@keyword.coroutine"] {},
    -- -- ["@keyword.function"] {},
    -- ["@keyword.operator"] { fg = p.subtle },
    -- ["@keyword.import"] { fg = p.pine },
    -- ["@keyword.storage"] { fg = p.foam },
    -- ["@keyword.repeat"] { fg = p.pine },
    -- ["@keyword.return"] { fg = p.pine },
    -- ["@keyword.debug"] { fg = p.rose },
    -- ["@keyword.exception"] { fg = p.pine },

    -- ["@keyword.conditional"] { fg = p.pine },
    -- ["@keyword.conditional.ternary"] { fg = p.pine },

    -- ["@keyword.directive"] { fg = p.iris },
    -- ["@keyword.directive.define"] { fg = p.iris },

    -- --- Punctuation
    -- ["@punctuation.delimiter"] { fg = p.subtle },
    -- ["@punctuation.bracket"] { fg = p.subtle },
    -- ["@punctuation.special"] { fg = p.subtle },

    -- --- Comments
    -- ["@comment"] { link = "Comment" },
    -- -- ["@comment.documentation"] {},

    -- ["@comment.error"] { fg = groups.error },
    -- ["@comment.warning"] { fg = groups.warn },
    -- ["@comment.todo"] { fg = groups.todo, bg = groups.todo, blend = 15 },
    -- ["@comment.hint"] { fg = groups.hint, bg = groups.hint, blend = 15 },
    -- ["@comment.info"] { fg = groups.info, bg = groups.info, blend = 15 },
    -- ["@comment.note"] { fg = groups.note, bg = groups.note, blend = 15 },

    -- --- Markup
    -- ["@markup.strong"] { bold = styles.bold },
    -- ["@markup.italic"] { italic = styles.italic },
    -- ["@markup.strikethrough"] { strikethrough = true },
    -- ["@markup.underline"] { underline = true },

    -- ["@markup.heading"] { fg = p.foam, bold = styles.bold },

    -- ["@markup.quote"] { fg = p.text },
    -- ["@markup.math"] { link = "Special" },
    -- ["@markup.environment"] { link = "Macro" },
    -- ["@markup.environment.name"] { link = "@type" },

    -- -- ["@markup.link"] {},
    -- ["@markup.link.markdown_inline"] { fg = p.subtle },
    -- ["@markup.link.label.markdown_inline"] { fg = p.foam },
    -- ["@markup.link.url"] { fg = groups.link },

    -- -- ["@markup.raw"] { bg = p.surface },
    -- -- ["@markup.raw.block"] { bg = p.surface },
    -- ["@markup.raw.delimiter.markdown"] { fg = p.subtle },

    -- ["@markup.list"] { fg = p.pine },
    -- ["@markup.list.checked"] { fg = p.foam, bg = p.foam, blend = 10 },
    -- ["@markup.list.unchecked"] { fg = p.text },

    -- -- Markdown headings
    -- ["@markup.heading.1.markdown"] { link = "markdownH1" },
    -- ["@markup.heading.2.markdown"] { link = "markdownH2" },
    -- ["@markup.heading.3.markdown"] { link = "markdownH3" },
    -- ["@markup.heading.4.markdown"] { link = "markdownH4" },
    -- ["@markup.heading.5.markdown"] { link = "markdownH5" },
    -- ["@markup.heading.6.markdown"] { link = "markdownH6" },
    -- ["@markup.heading.1.marker.markdown"] { link = "markdownH1Delimiter" },
    -- ["@markup.heading.2.marker.markdown"] { link = "markdownH2Delimiter" },
    -- ["@markup.heading.3.marker.markdown"] { link = "markdownH3Delimiter" },
    -- ["@markup.heading.4.marker.markdown"] { link = "markdownH4Delimiter" },
    -- ["@markup.heading.5.marker.markdown"] { link = "markdownH5Delimiter" },
    -- ["@markup.heading.6.marker.markdown"] { link = "markdownH6Delimiter" },

    -- ["@diff.plus"] { fg = groups.git_add, bg = groups.git_add, blend = 20 },
    -- ["@diff.minus"] { fg = groups.git_delete, bg = groups.git_delete, blend = 20 },
    -- ["@diff.delta"] { bg = groups.git_change, blend = 20 },

    -- ["@tag"] { link = "Tag" },
    -- ["@tag.attribute"] { fg = p.iris },
    -- ["@tag.delimiter"] { fg = p.subtle },

    -- --- Non-highlighting captures
    -- -- ["@none"] {},
    -- ["@conceal"] { link = "Conceal" },
    -- ["@conceal.markdown"] { fg = p.subtle },

    -- --- Semantic highlights
    -- ["@lsp.type.comment"] {},
    -- ["@lsp.type.comment.c"] { link = "@comment" },
    -- ["@lsp.type.comment.cpp"] { link = "@comment" },
    -- ["@lsp.type.enum"] { link = "@type" },
    -- ["@lsp.type.interface"] { link = "@interface" },
    -- ["@lsp.type.keyword"] { link = "@keyword" },
    -- ["@lsp.type.namespace"] { link = "@namespace" },
    -- ["@lsp.type.namespace.python"] { link = "@variable" },
    -- ["@lsp.type.parameter"] { link = "@parameter" },
    -- ["@lsp.type.property"] { link = "@property" },
    -- ["@lsp.type.variable"] {}, -- defer to treesitter for regular variables
    -- ["@lsp.type.variable.svelte"] { link = "@variable" },
    -- ["@lsp.typemod.function.defaultLibrary"] { link = "@function.builtin" },
    -- ["@lsp.typemod.operator.injected"] { link = "@operator" },
    -- ["@lsp.typemod.string.injected"] { link = "@string" },
    -- ["@lsp.typemod.variable.constant"] { link = "@constant" },
    -- ["@lsp.typemod.variable.defaultLibrary"] { link = "@variable.builtin" },
    -- ["@lsp.typemod.variable.injected"] { link = "@variable" },

    --- Plugins
    -- -- lewis6991/gitsigns.nvim
    -- GitSignsAdd { fg = groups.git_add, bg = "NONE" },
    -- GitSignsChange { fg = groups.git_change, bg = "NONE" },
    -- GitSignsDelete { fg = groups.git_delete, bg = "NONE" },
    -- SignAdd { fg = groups.git_add, bg = "NONE" },
    -- SignChange { fg = groups.git_change, bg = "NONE" },
    -- SignDelete { fg = groups.git_delete, bg = "NONE" },

    -- -- mvllow/modes.nvim
    -- ModesCopy { bg = p.gold },
    -- ModesDelete { bg = p.love },
    -- ModesInsert { bg = p.foam },
    -- ModesReplace { bg = p.pine },
    -- ModesVisual { bg = p.iris },

    -- -- nvim-neotest/neotest
    -- NeotestAdapterName { fg = p.iris },
    -- NeotestBorder { fg = p.highlight_med },
    -- NeotestDir { fg = p.foam },
    -- NeotestExpandMarker { fg = p.highlight_med },
    -- NeotestFailed { fg = p.love },
    -- NeotestFile { fg = p.text },
    -- NeotestFocused { fg = p.gold, bg = p.highlight_med },
    -- NeotestIndent { fg = p.highlight_med },
    -- NeotestMarked { fg = p.rose, bold = styles.bold },
    -- NeotestNamespace { fg = p.gold },
    -- NeotestPassed { fg = p.pine },
    -- NeotestRunning { fg = p.gold },
    -- NeotestWinSelect { fg = p.muted },
    -- NeotestSkipped { fg = p.subtle },
    -- NeotestTarget { fg = p.love },
    -- NeotestTest { fg = p.gold },
    -- NeotestUnknown { fg = p.subtle },
    -- NeotestWatching { fg = p.iris },

    -- -- folke/which-key.nvim
    -- WhichKey { fg = p.iris },
    -- WhichKeyBorder make_border(),
    -- WhichKeyDesc { fg = p.gold },
    -- WhichKeyFloat { bg = groups.panel },
    -- WhichKeyGroup { fg = p.foam },
    -- WhichKeyIcon { fg = p.pine },
    -- WhichKeyIconAzure { fg = p.pine },
    -- WhichKeyIconBlue { fg = p.pine },
    -- WhichKeyIconCyan { fg = p.foam },
    -- WhichKeyIconGreen { fg = p.leaf },
    -- WhichKeyIconGrey { fg = p.subtle },
    -- WhichKeyIconOrange { fg = p.rose },
    -- WhichKeyIconPurple { fg = p.iris },
    -- WhichKeyIconRed { fg = p.love },
    -- WhichKeyIconYellow { fg = p.gold },
    -- WhichKeyNormal { link = "NormalFloat" },
    -- WhichKeySeparator { fg = p.subtle },
    -- WhichKeyTitle { link = "FloatTitle" },
    -- WhichKeyValue { fg = p.rose },

    -- -- NeogitOrg/neogit
    -- -- https://github.com/NeogitOrg/neogit/blob/master/lua/neogit/lib/hl.lua#L109-L198
    -- NeogitChangeAdded { fg = groups.git_add, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeBothModified { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeCopied { fg = groups.git_untracked, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeDeleted { fg = groups.git_delete, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeModified { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeNewFile { fg = groups.git_stage, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeRenamed { fg = groups.git_rename, bold = styles.bold, italic = styles.italic },
    -- NeogitChangeUpdated { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
    -- NeogitDiffAddHighlight { link = "DiffAdd" },
    -- NeogitDiffContextHighlight { bg = p.surface },
    -- NeogitDiffDeleteHighlight { link = "DiffDelete" },
    -- NeogitFilePath { fg = p.foam, italic = styles.italic },
    -- NeogitHunkHeader { bg = groups.panel },
    -- NeogitHunkHeaderHighlight { bg = groups.panel },

    -- -- folke/trouble.nvim
    -- TroubleText { fg = p.subtle },
    -- TroubleCount { fg = p.iris, bg = p.surface },
    -- TroubleNormal { fg = p.text, bg = groups.panel },

    -- -- echasnovski/mini.nvim
    -- MiniCursorword { underline = true },
    -- MiniCursorwordCurrent { underline = true },

    -- MiniJump { sp = p.gold, undercurl = true },

    -- -- nvim-treesitter/nvim-treesitter-context
    -- TreesitterContext { bg = p.overlay },
    -- TreesitterContextLineNumber { fg = p.rose, bg = p.overlay },

    -- -- MeanderingProgrammer/render-markdown.nvim
    -- RenderMarkdownBullet { fg = p.rose },
    -- RenderMarkdownChecked { fg = p.foam },
    -- RenderMarkdownCode { bg = p.overlay },
    -- RenderMarkdownCodeInline { fg = p.text, bg = p.overlay },
    -- RenderMarkdownDash { fg = p.muted },
    -- RenderMarkdownH1Bg { bg = groups.h1, blend = 20 },
    -- RenderMarkdownH2Bg { bg = groups.h2, blend = 20 },
    -- RenderMarkdownH3Bg { bg = groups.h3, blend = 20 },
    -- RenderMarkdownH4Bg { bg = groups.h4, blend = 20 },
    -- RenderMarkdownH5Bg { bg = groups.h5, blend = 20 },
    -- RenderMarkdownH6Bg { bg = groups.h6, blend = 20 },
    -- RenderMarkdownQuote { fg = p.subtle },
    -- RenderMarkdownTableFill { link = "Conceal" },
    -- RenderMarkdownTableHead { fg = p.subtle },
    -- RenderMarkdownTableRow { fg = p.subtle },
    -- RenderMarkdownUnchecked { fg = p.subtle },

    -- -- Saghen/blink.cmp
    -- BlinkCmpDoc { bg = p.highlight_low },
    -- BlinkCmpDocSeparator { bg = p.highlight_low },
    -- BlinkCmpDocBorder { fg = p.highlight_high },
    -- BlinkCmpGhostText { fg = p.muted },

    -- BlinkCmpLabel { fg = p.muted },
    -- BlinkCmpLabelDeprecated { fg = p.muted, strikethrough = true },
    -- BlinkCmpLabelMatch { fg = p.text, bold = styles.bold },

    -- BlinkCmpDefault { fg = p.highlight_med },
    -- BlinkCmpKindText { fg = p.pine },
    -- BlinkCmpKindMethod { fg = p.foam },
    -- BlinkCmpKindFunction { fg = p.foam },
    -- BlinkCmpKindConstructor { fg = p.foam },
    -- BlinkCmpKindField { fg = p.pine },
    -- BlinkCmpKindVariable { fg = p.rose },
    -- BlinkCmpKindClass { fg = p.gold },
    -- BlinkCmpKindInterface { fg = p.gold },
    -- BlinkCmpKindModule { fg = p.foam },
    -- BlinkCmpKindProperty { fg = p.foam },
    -- BlinkCmpKindUnit { fg = p.pine },
    -- BlinkCmpKindValue { fg = p.love },
    -- BlinkCmpKindKeyword { fg = p.iris },
    -- BlinkCmpKindSnippet { fg = p.rose },
    -- BlinkCmpKindColor { fg = p.love },
    -- BlinkCmpKindFile { fg = p.foam },
    -- BlinkCmpKindReference { fg = p.love },
    -- BlinkCmpKindFolder { fg = p.foam },
    -- BlinkCmpKindEnum { fg = p.foam },
    -- BlinkCmpKindEnumMember { fg = p.foam },
    -- BlinkCmpKindConstant { fg = p.gold },
    -- BlinkCmpKindStruct { fg = p.foam },
    -- BlinkCmpKindEvent { fg = p.foam },
    -- BlinkCmpKindOperator { fg = p.foam },
    -- BlinkCmpKindTypeParameter { fg = p.iris },
    -- BlinkCmpKindCodeium { fg = p.foam },
    -- BlinkCmpKindCopilot { fg = p.foam },
    -- BlinkCmpKindSupermaven { fg = p.foam },
    -- BlinkCmpKindTabNine { fg = p.foam },

    -- -- folke/snacks.nvim
    -- SnacksIndent { fg = p.overlay },
    -- SnacksIndentChunk { fg = p.overlay },
    -- SnacksIndentBlank { fg = p.overlay },
    -- SnacksIndentScope { fg = p.foam },
    -- SnacksPickerMatch { fg = p.rose, bold = styles.bold },
  }
end)
