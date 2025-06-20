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
-- local river = hsl(189, 43, 73)
-- local iris = hsl(267, 57, 78)
-- local highlight_low = hsl(244, 18, 15)
-- local highlight_med = hsl(249, 15, 28)
-- local highlight_high = hsl(248, 13, 36)

local base = hsl(198, 32, 18)
local surface = base.li(4).de(4)
local overlay = surface.li(8).de(4)
local highlight_low = overlay.li(8).de(4)
local highlight_med = highlight_low.li(10).de(4)
local highlight_high = highlight_med.li(12).de(4)
local text = hsl(195, 30, 90)
local subtle = text.da(20).de(15).ro(10)
local muted = subtle.da(30).de(30).ro(10)
local cherry = hsl(346, 74, 68)
local blossom = hsl(262, 34, 66)
local petal = hsl(358, 55, 80)
local branch = hsl(35, 74, 73)
local leaf = hsl(165, 30, 42)
local river = hsl(189, 38, 63)

local palette = {
  base = base,
  surface = surface,
  overlay = overlay,
  highlight_low = highlight_low,
  highlight_med = highlight_med,
  highlight_high = highlight_high,
  muted = muted,
  subtle = subtle,
  text = text,
  cherry = cherry,
  blossom = blossom,
  petal = petal,
  branch = branch,
  leaf = leaf,
  river = river,
}

---@class wip.Config
---@field styles wip.Styles
---@field groups wip.Groups
---@field highlights table<string, vim.api.keyset.set_hl_info>

---@class wip.Styles
---@field bold boolean
---@field italic boolean
---@field transparency boolean

---@class wip.Groups
---@field ui {
--- border: table,
--- link: table,
--- panel: table,
--- error: table,
--- hint: table,
--- info: table,
--- ok: table,
--- warn: table,
--- note: table,
--- todo: table,
---}
---@field git {
--- add: table,
--- change: table,
--- delete: table,
--- dirty: table,
--- ignore: table,
--- merge: table,
--- rename: table,
--- stage: table,
--- text: table,
--- untracked: table,
---}
---@field heading {
--- h1: table,
--- h2: table,
--- h3: table,
--- h4: table,
--- h5: table,
--- h6: table,
---}

---@type wip.Config
local defaults = {
  styles = {
    bold = true,
    italic = true,
    transparency = false,
  },
  groups = {
    ui = {
      border = highlight_med,
      link = blossom,
      panel = surface,
      error = cherry,
      hint = blossom,
      info = river,
      ok = leaf,
      warn = branch,
      note = leaf,
      todo = blossom,
    },

    git = {
      add = leaf,
      change = branch,
      delete = cherry,
      dirty = branch,
      ignore = muted,
      merge = branch,
      rename = blossom,
      stage = branch,
      text = branch,
      untracked = subtle,
    },

    heading = {
      h1 = blossom,
      h2 = river,
      h3 = blossom,
      h4 = branch,
      h5 = leaf,
      h6 = leaf,
    },
  },

  highlights = {},
}

-- ---@param opts wip.Config?
-- function M.setup(opts)
-- opts = vim.tbl_deep_extend("force", M.defaults, opts)
---@as(wip.Config)
-- local useropts = {
--   styles = { bold = true, italic = false },
--   highlights = { Cursor = { bg = "none" } },
-- }

---@type wip.Config
local opts = vim.tbl_deep_extend("force", defaults, {
  styles = { italic = false },
  highlights = { Cursor = { bg = "none" } },
})

return lush(function(injected_functions)
  ---@diagnostic disable: undefined-global
  local sym = injected_functions.sym

  local p = palette
  local s = opts.styles
  local g = opts.groups

  local default_highlights = {
    Normal { fg = p.text, bg = p.base },
    NormalFloat { bg = g.ui.panel },
    NormalNC { fg = p.text, bg = p.base },
    ColorColumn { bg = p.surface },
    LineNr { fg = p.muted, bg = p.surface },
    CursorLineNr { fg = p.text, bg = p.surface, bold = s.bold },
    SignColumn { fg = p.text, bg = p.surface },
    Visual { bg = p.highlight_low },

    -- conceal
    Conceal { bg = p.overlay, fg = p.subtle },

    -- search
    Search { fg = p.base, bg = p.cherry },
    CurSearch { Search },
    IncSearch { CurSearch },

    -- cursor
    Cursor { fg = p.text, bg = p.highlight_high },
    CursorLine { bg = p.overlay },
    CursorColumn { CursorLine },
    NonText { fg = p.subtle },

    -- diff
    DiffAdd { bg = g.git.add.mix(p.base, 70) },
    DiffChange { bg = g.git.change.mix(p.base, 70) },
    DiffDelete { bg = g.git.delete.mix(p.base, 70) },
    DiffText { bg = g.git.text.mix(p.base, 70) },
    diffAdded { DiffAdd },
    diffChanged { DiffChange },
    diffRemoved { DiffDelete },
    Added { DiffAdd },
    Changed { DiffChange },
    Removed { DiffDelete },
    Directory { fg = p.river, bold = s.bold },
    EndOfBuffer { NonText },
    ErrorMsg { fg = g.ui.error, bold = s.bold },

    -- folds
    FoldColumn { fg = p.muted },
    Folded { fg = p.text, bg = g.ui.panel },

    MatchParen { bg = p.highlight_med },
    NvimInternalError { ErrorMsg },
    ModeMsg { fg = p.subtle },
    MoreMsg { fg = p.blossom },

    -- menu
    Pmenu { fg = p.subtle, bg = g.ui.panel },
    PmenuExtra { fg = p.muted, bg = g.ui.panel },
    PmenuExtraSel { fg = p.subtle, bg = p.overlay },
    PmenuKind { fg = p.river, bg = g.ui.panel },
    PmenuKindSel { fg = p.subtle, bg = p.overlay },
    PmenuSbar { bg = g.ui.panel },
    PmenuSel { fg = p.text, bg = p.overlay },
    PmenuThumb { bg = p.muted },

    -- floats
    Float { fg = p.river },
    FloatBorder { fg = g.ui.border, bg = g.ui.panel },
    FloatTitle { fg = p.river, bg = g.ui.panel, bold = s.bold },

    Question { fg = p.branch },
    QuickFixLine { fg = p.river },
    RedrawDebugClear { fg = p.base, bg = p.leaf },
    RedrawDebugComposed { fg = p.base, bg = p.blossom },
    RedrawDebugRecompose { fg = p.base, bg = p.petal },
    SpecialKey { fg = p.river },
    SpellBad { sp = p.subtle, undercurl = true },
    SpellCap { sp = p.subtle, undercurl = true },
    SpellLocal { sp = p.subtle, undercurl = true },
    SpellRare { sp = p.subtle, undercurl = true },
    StatusLine { fg = p.subtle, bg = g.ui.panel },
    StatusLineNC { fg = p.muted, bg = g.ui.panel },
    StatusLineTerm { fg = p.base, bg = p.pine },
    StatusLineTermNC { fg = p.base, bg = p.pine },
    Substitute { IncSearch },
    TabLine { fg = p.subtle, bg = g.ui.panel },
    TabLineFill { bg = g.ui.panel },
    TabLineSel { fg = p.text, bg = p.overlay, bold = s.bold },
    Title { fg = p.river, bold = s.bold },
    VertSplit { fg = g.ui.border },
    WarningMsg { fg = g.ui.warn, bold = s.bold },
    WildMenu { IncSearch },
    WinBar { fg = p.subtle, bg = g.ui.panel },
    WinBarNC { fg = p.muted, bg = g.ui.panel },
    WinSeparator { fg = g.ui.border },

    -- diagnostics
    -- DiagnosticError { fg = g.error },
    -- DiagnosticHint { fg = g.hint },
    -- DiagnosticInfo { fg = g.info },
    -- DiagnosticOk { fg = g.ok },
    -- DiagnosticWarn { fg = g.warn },
    -- DiagnosticDefaultError { DiagnosticError },
    -- DiagnosticDefaultHint { DiagnosticHint },
    -- DiagnosticDefaultInfo { DiagnosticInfo },
    -- DiagnosticDefaultOk { DiagnosticOk },
    -- DiagnosticDefaultWarn { DiagnosticWarn },
    -- DiagnosticFloatingError { DiagnosticError },
    -- DiagnosticFloatingHint { DiagnosticHint },
    -- DiagnosticFloatingInfo { DiagnosticInfo },
    -- DiagnosticFloatingOk { DiagnosticOk },
    -- DiagnosticFloatingWarn { DiagnosticWarn },
    -- DiagnosticSignError { DiagnosticError },
    -- DiagnosticSignHint { DiagnosticHint },
    -- DiagnosticSignInfo { DiagnosticInfo },
    -- DiagnosticSignOk { DiagnosticOk },
    -- DiagnosticSignWarn { DiagnosticWarn },
    -- DiagnosticUnderlineError { sp = g.error, undercurl = true },
    -- DiagnosticUnderlineHint { sp = g.hint, undercurl = true },
    -- DiagnosticUnderlineInfo { sp = g.info, undercurl = true },
    -- DiagnosticUnderlineOk { sp = g.ok, undercurl = true },
    -- DiagnosticUnderlineWarn { sp = g.warn, undercurl = true },
    -- DiagnosticVirtualTextError { fg = g.error, bg = groups.error,  },
    -- DiagnosticVirtualTextHint { fg = g.hint, bg = groups.hint,  },
    -- DiagnosticVirtualTextInfo { fg = g.info, bg = groups.info,  },
    -- DiagnosticVirtualTextOk { fg = g.ok, bg = groups.ok,  },
    -- DiagnosticVirtualTextWarn { fg = g.warn, bg = groups.warn,  },

    -- syntax
    -- Boolean { fg = p.rose },
    -- Character { fg = p.branch },
    Comment { fg = p.subtle, italic = s.italic },
    -- Conditional { fg = p.pine },
    -- Constant { fg = p.branch },
    -- Debug { fg = p.rose },
    -- Define { fg = p.iris },
    -- Delimiter { fg = p.subtle },
    -- Error { fg = p.love },
    -- Exception { fg = p.pine },
    -- Function { fg = p.rose },
    -- Identifier { fg = p.text },
    -- Include { fg = p.pine },
    -- Keyword { fg = p.pine },
    -- Label { fg = p.river },
    -- LspCodeLens { fg = p.subtle },
    -- LspCodeLensSeparator { fg = p.muted },
    -- LspInlayHint { fg = p.muted, bg = p.muted,  },
    -- LspReferenceRead { bg = p.highlight_med },
    -- LspReferenceText { bg = p.highlight_med },
    -- LspReferenceWrite { bg = p.highlight_med },
    -- Macro { fg = p.iris },
    -- Number { fg = p.branch },
    -- Operator { fg = p.subtle },
    -- PreCondit { fg = p.iris },
    -- PreProc { PreCondit },
    -- Repeat { fg = p.pine },
    -- Special { fg = p.river },
    -- SpecialChar { Special },
    -- SpecialComment { fg = p.iris },
    -- Statement { fg = p.pine, bold = s.bold },
    -- StorageClass { fg = p.river },
    -- String { fg = p.branch },
    -- Structure { fg = p.river },
    -- Tag { fg = p.river },
    -- Todo { fg = p.rose, bg = p.rose,  },
    -- Type { fg = p.river },
    -- TypeDef { Type },
    -- Underlined { fg = p.iris, underline = true },

    -- health
    -- healthError { fg = g.error },
    -- healthSuccess { fg = g.info },
    -- healthWarning { fg = g.warn },

    -- html
    -- htmlArg { fg = p.iris },
    -- htmlBold { bold = s.bold },
    -- htmlEndTag { fg = p.subtle },
    -- htmlH1 { markdownH1 },
    -- htmlH2 { markdownH2 },
    -- htmlH3 { markdownH3 },
    -- htmlH4 { markdownH4 },
    -- htmlH5 { markdownH5 },
    -- htmlItalic { italic = s.italic },
    -- htmlLink { link = "markdownUrl" },
    -- htmlTag { fg = p.subtle },
    -- htmlTagN { fg = p.text },
    -- htmlTagName { fg = p.river },

    -- markdownDelimiter { fg = p.subtle },
    -- markdownH1 { fg = g.h1, bold = s.bold },
    -- markdownH1Delimiter { markdownH1 },
    -- markdownH2 { fg = g.h2, bold = s.bold },
    -- markdownH2Delimiter { markdownH2 },
    -- markdownH3 { fg = g.h3, bold = s.bold },
    -- markdownH3Delimiter { markdownH3 },
    -- markdownH4 { fg = g.h4, bold = s.bold },
    -- markdownH4Delimiter { markdownH4 },
    -- markdownH5 { fg = g.h5, bold = s.bold },
    -- markdownH5Delimiter { markdownH5 },
    -- markdownH6 { fg = g.h6, bold = s.bold },
    -- markdownH6Delimiter { markdownH6 },
    -- markdownLinkText { link = "markdownUrl" },
    -- markdownUrl { fg = g.markdownUrl },
    -- mkdLink { link = "markdownUrl" },
    -- mkdLinkDef { link = "markdownUrl" },
    -- mkdListItemLine { fg = p.text },
    -- mkdRule { fg = p.subtle },
    -- mkdURL { markdownUrl },

    -- --- Treesitter
    -- --- |:help treesitter-highlight-g|
    -- ["@variable"] { fg = p.text, italic = s.italic },
    -- ["@variable.builtin"] { fg = p.love, italic = s.italic, bold = s.bold },
    -- ["@variable.parameter"] { fg = p.iris, italic = s.italic },
    -- ["@variable.parameter.builtin"] { fg = p.iris, italic = s.italic, bold = s.bold },
    -- ["@variable.member"] { fg = p.river },

    -- ["@constant"] { fg = p.branch },
    -- ["@constant.builtin"] { fg = p.branch, bold = s.bold },
    -- ["@constant.macro"] { fg = p.branch },

    -- ["@module"] { fg = p.text },
    -- ["@module.builtin"] { fg = p.text, bold = s.bold },
    -- ["@label"] { Label },

    -- ["@string"] { String },
    -- ["@string.regexp"] { fg = p.iris },
    -- ["@string.escape"] { fg = p.pine },
    -- ["@string.special"] { String },
    -- ["@string.special.symbol"] { Identifier },
    -- ["@string.special.url"] { fg = g.@character] { Character },
    -- ["@character.special"] { Character },

    -- ["@boolean"] { Boolean },
    -- ["@number"] { Number },
    -- ["@number.float"] { Number },
    -- ["@float"] { Number },

    -- ["@type"] { fg = p.river },
    -- ["@type.builtin"] { fg = p.river, bold = s.bold },

    -- ["@attribute"] { fg = p.iris },
    -- ["@attribute.builtin"] { fg = p.iris, bold = s.bold },
    -- ["@property"] { fg = p.river, italic = s.italic },

    -- ["@function"] { fg = p.rose },
    -- ["@function.builtin"] { fg = p.rose, bold = s.bold },
    -- -- ["@function.call"] {},
    -- ["@function.macro"] { Function },

    -- ["@function.method"] { fg = p.rose },
    -- ["@function.method.call"] { fg = p.iris },

    -- ["@constructor"] { fg = p.river },
    -- ["@operator"] { Operator },

    -- ["@keyword"] { Keyword },
    -- ["@keyword.operator"] { fg = p.subtle },
    -- ["@keyword.import"] { fg = p.pine },
    -- ["@keyword.storage"] { fg = p.river },
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
    -- sym "@comment" { "Comment" },

    -- ["@comment.error"] { fg = g.error },
    -- ["@comment.warning"] { fg = g.warn },
    -- ["@comment.todo"] { fg = g.todo, bg = groups.todo,  },
    -- ["@comment.hint"] { fg = g.hint, bg = groups.hint,  },
    -- ["@comment.info"] { fg = g.info, bg = groups.info,  },
    -- ["@comment.note"] { fg = g.note, bg = groups.note,  },

    -- --- Markup
    -- ["@markup.strong"] { bold = s.bold },
    -- ["@markup.italic"] { italic = s.italic },
    -- ["@markup.strikethrough"] { strikethrough = true },
    -- ["@markup.underline"] { underline = true },

    -- ["@markup.heading"] { fg = p.river, bold = s.bold },

    -- ["@markup.quote"] { fg = p.text },
    -- ["@markup.math"] { Special },
    -- ["@markup.environment"] { Macro },
    -- ["@markup.environment.name"] { @type },

    -- -- ["@markup.link"] {},
    -- ["@markup.link.markdown_inline"] { fg = p.subtle },
    -- ["@markup.link.label.markdown_inline"] { fg = p.river },
    -- ["@markup.link.url"] { fg = g.link },

    -- -- ["@markup.raw"] { bg = p.surface },
    -- -- ["@markup.raw.block"] { bg = p.surface },
    -- ["@markup.raw.delimiter.markdown"] { fg = p.subtle },

    -- ["@markup.list"] { fg = p.pine },
    -- ["@markup.list.checked"] { fg = p.river, bg = p.river,  },
    -- ["@markup.list.unchecked"] { fg = p.text },

    -- -- Markdown headings
    -- ["@markup.heading.1.markdown"] { markdownH1 },
    -- ["@markup.heading.2.markdown"] { markdownH2 },
    -- ["@markup.heading.3.markdown"] { markdownH3 },
    -- ["@markup.heading.4.markdown"] { markdownH4 },
    -- ["@markup.heading.5.markdown"] { markdownH5 },
    -- ["@markup.heading.6.markdown"] { markdownH6 },
    -- ["@markup.heading.1.marker.markdown"] { markdownH1Delimiter },
    -- ["@markup.heading.2.marker.markdown"] { markdownH2Delimiter },
    -- ["@markup.heading.3.marker.markdown"] { markdownH3Delimiter },
    -- ["@markup.heading.4.marker.markdown"] { markdownH4Delimiter },
    -- ["@markup.heading.5.marker.markdown"] { markdownH5Delimiter },
    -- ["@markup.heading.6.marker.markdown"] { markdownH6Delimiter },

    -- ["@diff.plus"] { fg = g.git.add, bg = groups.git.add,  },
    -- ["@diff.minus"] { fg = g.git.delete, bg = groups.git.delete,  },
    -- ["@diff.delta"] { bg = g.git.change,  },

    -- ["@tag"] { Tag },
    -- ["@tag.attribute"] { fg = p.iris },
    -- ["@tag.delimiter"] { fg = p.subtle },

    -- --- Non-highlighting captures
    -- -- ["@none"] {},
    -- ["@conceal"] { Conceal },
    -- ["@conceal.markdown"] { fg = p.subtle },

    -- --- Semantic highlights
    -- ["@lsp.type.comment"] {},
    -- ["@lsp.type.comment.c"] { @comment },
    -- ["@lsp.type.comment.cpp"] { @comment },
    -- ["@lsp.type.enum"] { @type },
    -- ["@lsp.type.interface"] { @interface },
    -- ["@lsp.type.keyword"] { @keyword },
    -- ["@lsp.type.namespace"] { @namespace },
    -- ["@lsp.type.namespace.python"] { @variable },
    -- ["@lsp.type.parameter"] { @parameter },
    -- ["@lsp.type.property"] { @property },
    -- ["@lsp.type.variable"] {}, -- defer to treesitter for regular variables
    -- ["@lsp.type.variable.svelte"] { @variable },
    -- ["@lsp.typemod.function.defaultLibrary"] { @function.builtin },
    -- ["@lsp.typemod.operator.injected"] { @operator },
    -- ["@lsp.typemod.string.injected"] { @string },
    -- ["@lsp.typemod.variable.constant"] { @constant },
    -- ["@lsp.typemod.variable.defaultLibrary"] { @variable.builtin },
    -- ["@lsp.typemod.variable.injected"] { @variable },

    -- Plugins
    -- lewis6991/gitsigns.nvim
    GitSignsAdd { fg = g.git.add },
    GitSignsChange { fg = g.git.change },
    GitSignsDelete { fg = g.git.delete },
    SignAdd { fg = g.git.add },
    SignChange { fg = g.git.change },
    SignDelete { fg = g.git.delete },

    -- -- folke/which-key.nvim
    -- WhichKey { fg = p.iris },
    -- WhichKeyBorder make_border(),
    -- WhichKeyDesc { fg = p.branch },
    -- WhichKeyFloat { bg = g.ui.panel },
    -- WhichKeyGroup { fg = p.river },
    -- WhichKeyIcon { fg = p.pine },
    -- WhichKeyIconAzure { fg = p.pine },
    -- WhichKeyIconBlue { fg = p.pine },
    -- WhichKeyIconCyan { fg = p.river },
    -- WhichKeyIconGreen { fg = p.leaf },
    -- WhichKeyIconGrey { fg = p.subtle },
    -- WhichKeyIconOrange { fg = p.rose },
    -- WhichKeyIconPurple { fg = p.iris },
    -- WhichKeyIconRed { fg = p.love },
    -- WhichKeyIconYellow { fg = p.branch },
    -- WhichKeyNormal { NormalFloat },
    -- WhichKeySeparator { fg = p.subtle },
    -- WhichKeyTitle { FloatTitle },
    -- WhichKeyValue { fg = p.rose },

    -- -- NeogitOrg/neogit
    -- -- https://github.com/NeogitOrg/neogit/blob/master/lua/neogit/lib/hl.lua#L109-L198
    -- NeogitChangeAdded { fg = g.git.add, bold = s.bold, italic = s.italic },
    -- NeogitChangeBothModified { fg = g.git.change, bold = s.bold, italic = s.italic },
    -- NeogitChangeCopied { fg = g.git.untracked, bold = s.bold, italic = s.italic },
    -- NeogitChangeDeleted { fg = g.git.delete, bold = s.bold, italic = s.italic },
    -- NeogitChangeModified { fg = g.git.change, bold = s.bold, italic = s.italic },
    -- NeogitChangeNewFile { fg = g.git.stage, bold = s.bold, italic = s.italic },
    -- NeogitChangeRenamed { fg = g.git.rename, bold = s.bold, italic = s.italic },
    -- NeogitChangeUpdated { fg = g.git.change, bold = s.bold, italic = s.italic },
    -- NeogitDiffAddHighlight { DiffAdd },
    -- NeogitDiffContextHighlight { bg = p.surface },
    -- NeogitDiffDeleteHighlight { DiffDelete },
    -- NeogitFilePath { fg = p.river, italic = s.italic },
    -- NeogitHunkHeader { bg = g.ui.panel },
    -- NeogitHunkHeaderHighlight { bg = g.ui.panel },

    -- -- folke/trouble.nvim
    -- TroubleText { fg = p.subtle },
    -- TroubleCount { fg = p.iris, bg = p.surface },
    -- TroubleNormal { fg = p.text, bg = g.ui.panel },

    -- -- echasnovski/mini.nvim
    -- MiniCursorword { underline = true },
    -- MiniCursorwordCurrent { underline = true },

    -- MiniJump { sp = p.branch, undercurl = true },

    -- nvim-treesitter/nvim-treesitter-context
    TreesitterContext { bg = p.overlay },
    TreesitterContextLineNumber { fg = p.river, bg = p.overlay },

    -- -- MeanderingProgrammer/render-markdown.nvim
    -- RenderMarkdownBullet { fg = p.rose },
    -- RenderMarkdownChecked { fg = p.river },
    -- RenderMarkdownCode { bg = p.overlay },
    -- RenderMarkdownCodeInline { fg = p.text, bg = p.overlay },
    -- RenderMarkdownDash { fg = p.muted },
    -- RenderMarkdownH1Bg { bg = g.h1,  },
    -- RenderMarkdownH2Bg { bg = g.h2,  },
    -- RenderMarkdownH3Bg { bg = g.h3,  },
    -- RenderMarkdownH4Bg { bg = g.h4,  },
    -- RenderMarkdownH5Bg { bg = g.h5,  },
    -- RenderMarkdownH6Bg { bg = g.h6,  },
    -- RenderMarkdownQuote { fg = p.subtle },
    -- RenderMarkdownTableFill { Conceal },
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
    -- BlinkCmpLabelMatch { fg = p.text, bold = s.bold },

    -- BlinkCmpDefault { fg = p.highlight_med },
    -- BlinkCmpKindText { fg = p.pine },
    -- BlinkCmpKindMethod { fg = p.river },
    -- BlinkCmpKindFunction { fg = p.river },
    -- BlinkCmpKindConstructor { fg = p.river },
    -- BlinkCmpKindField { fg = p.pine },
    -- BlinkCmpKindVariable { fg = p.rose },
    -- BlinkCmpKindClass { fg = p.branch },
    -- BlinkCmpKindInterface { fg = p.branch },
    -- BlinkCmpKindModule { fg = p.river },
    -- BlinkCmpKindProperty { fg = p.river },
    -- BlinkCmpKindUnit { fg = p.pine },
    -- BlinkCmpKindValue { fg = p.love },
    -- BlinkCmpKindKeyword { fg = p.iris },
    -- BlinkCmpKindSnippet { fg = p.rose },
    -- BlinkCmpKindColor { fg = p.love },
    -- BlinkCmpKindFile { fg = p.river },
    -- BlinkCmpKindReference { fg = p.love },
    -- BlinkCmpKindFolder { fg = p.river },
    -- BlinkCmpKindEnum { fg = p.river },
    -- BlinkCmpKindEnumMember { fg = p.river },
    -- BlinkCmpKindConstant { fg = p.branch },
    -- BlinkCmpKindStruct { fg = p.river },
    -- BlinkCmpKindEvent { fg = p.river },
    -- BlinkCmpKindOperator { fg = p.river },
    -- BlinkCmpKindTypeParameter { fg = p.iris },
    -- BlinkCmpKindCodeium { fg = p.river },
    -- BlinkCmpKindCopilot { fg = p.river },
    -- BlinkCmpKindSupermaven { fg = p.river },
    -- BlinkCmpKindTabNine { fg = p.river },

    -- folke/snacks.nvim
    SnacksPickerMatch { fg = p.cherry, bold = s.bold },

    -- -- nvim-neotest/neotest
    -- NeotestAdapterName { fg = p.iris },
    -- NeotestBorder { fg = p.highlight_med },
    -- NeotestDir { fg = p.river },
    -- NeotestExpandMarker { fg = p.highlight_med },
    -- NeotestFailed { fg = p.love },
    -- NeotestFile { fg = p.text },
    -- NeotestFocused { fg = p.branch, bg = p.highlight_med },
    -- NeotestIndent { fg = p.highlight_med },
    -- NeotestMarked { fg = p.rose, bold = s.bold },
    -- NeotestNamespace { fg = p.branch },
    -- NeotestPassed { fg = p.pine },
    -- NeotestRunning { fg = p.branch },
    -- NeotestWinSelect { fg = p.muted },
    -- NeotestSkipped { fg = p.subtle },
    -- NeotestTarget { fg = p.love },
    -- NeotestTest { fg = p.branch },
    -- NeotestUnknown { fg = p.subtle },
    -- NeotestWatching { fg = p.iris },
  }

  -- return vim.tbl_deep_extend("force", default_highlights, opts.highlights)
  return default_highlights
end)
