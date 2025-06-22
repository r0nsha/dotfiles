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

-- TODO: make accent colors pop more like zenburn
local cherry = hsl(350, 64, 62)
local blossom = hsl(318, 38, 70)
local petal = hsl(358, 58, 72)
local branch = hsl(26, 52, 64)
local leaf = hsl(172, 38, 50)
local river = hsl(189, 54, 60)
local base = hsl(198, 30, 26)
local surface = base.li(6).mix(cherry, 4)
local overlay = surface.li(8)
local highlight_low = overlay.li(6).mix(cherry, 3)
local highlight_med = highlight_low.li(8)
local highlight_high = highlight_med.li(12)
local text = hsl(190, 38, 93)
local subtle = text.da(35).mix(cherry, 8)
local muted = subtle.da(25).mix(cherry, 8)

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

---@alias wip.Color table

---@class wip.Config
---@field opts wip.Opts
---@field styles wip.Styles
---@field groups wip.Groups
---@field highlights table<string, vim.api.keyset.set_hl_info>

---@class wip.Opts
---@field signcolumn {
---   bg: boolean,
---}
---@field float {
---   bg: boolean,
---}
---@field lsp {
---   inlay_hint: {
---     bg: boolean,
---   },
---}

---@class wip.Styles
---@field bold boolean
---@field italic boolean
---@field transparency boolean

---@class wip.Groups
---@field ui {
---   border: wip.Color,
---   panel: wip.Color,
---   indent: {
---     dim: wip.Color,
---     scope: wip.Color,
---   },
---   success: wip.Color,
---   error: wip.Color,
---   hint: wip.Color,
---   info: wip.Color,
---   ok: wip.Color,
---   warn: wip.Color,
---   note: wip.Color,
---   todo: wip.Color,
---   link: wip.Color,
---}
---@field git {
---   add: wip.Color,
---   change: wip.Color,
---   delete: wip.Color,
---   dirty: wip.Color,
---   ignore: wip.Color,
---   merge: wip.Color,
---   rename: wip.Color,
---   stage: wip.Color,
---   text: wip.Color,
---   untracked: wip.Color,
---}
---@field heading {
---   h1: wip.Color,
---   h2: wip.Color,
---   h3: wip.Color,
---   h4: wip.Color,
---   h5: wip.Color,
---   h6: wip.Color,
---}

---@type wip.Config
local defaults = {
  opts = {
    signcolumn = {
      bg = true,
    },
    float = {
      bg = false,
    },
    lsp = {
      inlay_hint = {
        bg = true,
      },
    },
  },

  styles = {
    bold = true,
    italic = true,
    -- TODO: transparency
    transparency = false,
  },

  groups = {
    ui = {
      border = palette.highlight_med,
      panel = palette.surface,

      indent = {
        dim = palette.overlay,
        scope = palette.highlight_high,
      },
      success = palette.leaf,
      error = palette.cherry,
      hint = palette.blossom,
      info = palette.river,
      ok = palette.leaf,
      warn = palette.branch,
      note = palette.leaf,
      todo = palette.river,
      link = palette.blossom,
    },

    git = {
      add = palette.leaf,
      change = palette.branch,
      delete = palette.cherry,
      dirty = palette.branch,
      ignore = palette.muted,
      merge = palette.branch,
      rename = palette.blossom,
      stage = palette.branch,
      text = palette.branch,
      untracked = palette.subtle,
    },

    heading = {
      h1 = palette.cherry,
      h2 = palette.petal,
      h3 = palette.blossom,
      h4 = palette.branch,
      h5 = palette.leaf,
      h6 = palette.river,
    },
  },

  highlights = {},
}

-- ---@param config wip.Config?
-- function M.setup(config)
-- config = vim.tbl_deep_extend("force", M.defaults, config)

---@type wip.Config
local config = vim.tbl_deep_extend("force", defaults, {
  styles = { italic = false },
  highlights = { Cursor = { bg = "none" } },
})

return lush(function(injected_functions)
  ---@diagnostic disable: undefined-global
  local sym = injected_functions.sym

  local p = palette
  local s = config.styles
  local g = config.groups
  local o = config.opts

  if not o.float.bg then
    g.ui.panel = p.base
  end

  local default_highlights = {
    Normal { fg = p.text, bg = p.base },
    NormalNC { fg = p.text, bg = p.base },
    ColorColumn { bg = p.surface },
    LineNr { fg = o.signcolumn.bg and p.subtle or p.muted, bg = o.signcolumn.bg and p.surface },
    SignColumn { fg = p.text, bg = o.signcolumn.bg and p.surface },
    Cursor { fg = p.text, bg = p.highlight_high },
    CursorLine { bg = p.surface },
    CursorLineNr { fg = p.text, bg = o.signcolumn.bg and p.surface, bold = s.bold },
    CursorLineSign { SignColumn },
    CursorColumn { CursorLine },
    Visual { bg = p.overlay },
    NonText { fg = p.subtle },
    Conceal { bg = p.overlay, fg = p.subtle },
    MatchParen { bg = p.highlight_med },

    -- search
    Search { fg = p.base, bg = p.branch },
    CurSearch { Search },
    IncSearch { CurSearch },

    -- diff
    DiffAdd { bg = g.git.add.mix(p.base, 60) },
    DiffChange { bg = g.git.change.mix(p.base, 60) },
    DiffDelete { bg = g.git.delete.mix(p.base, 60) },
    DiffText { bg = g.git.text.mix(p.base, 60) },
    diffAdded { DiffAdd },
    diffChanged { DiffChange },
    diffRemoved { DiffDelete },
    Added { DiffAdd },
    Changed { DiffChange },
    Removed { DiffDelete },
    Directory { fg = p.subtle, bold = s.bold },
    EndOfBuffer { NonText },

    -- folds
    FoldColumn { fg = p.subtle },
    Folded { fg = p.subtle, bg = surface },

    -- msg
    ModeMsg { fg = p.subtle },
    MoreMsg { fg = p.blossom },
    ErrorMsg { bg = g.ui.error, fg = p.base, bold = s.bold },
    WarningMsg { fg = g.ui.warn, bold = s.bold },
    NvimInternalError { ErrorMsg },

    -- floats
    NormalFloat { bg = g.ui.panel },
    Float { fg = p.text, bg = g.ui.panel },
    FloatBorder { fg = g.ui.border, bg = g.ui.panel },
    FloatTitle { fg = p.subtle, bg = g.ui.panel, bold = s.bold },

    -- menu
    Pmenu { Float },
    PmenuMatch { fg = Search.bg, bold = s.bold },
    PmenuExtra { fg = p.muted, bg = Float.bg },
    PmenuExtraSel { fg = p.subtle, bg = p.overlay },
    PmenuKind { fg = p.river, bg = Float.bg },
    PmenuKindSel { fg = p.subtle, bg = p.overlay },
    PmenuSbar { bg = Float.bg },
    PmenuSel { fg = p.text, bg = p.overlay },
    PmenuThumb { bg = p.muted },

    -- statusline
    StatusLine { fg = p.subtle, bg = p.surface },
    StatusLineNC { fg = p.muted, bg = p.surface },
    StatusLineTerm { fg = p.base, bg = p.leaf },
    StatusLineTermNC { fg = p.base, bg = p.leaf },

    Question { fg = p.cherry },
    QuickFixLine { fg = p.petal },
    RedrawDebugClear { fg = p.base, bg = p.leaf },
    RedrawDebugComposed { fg = p.base, bg = p.blossom },
    RedrawDebugRecompose { fg = p.base, bg = p.petal },
    SpecialKey { fg = p.leaf },
    SpellBad { sp = p.subtle, undercurl = true },
    SpellCap { sp = p.subtle, undercurl = true },
    SpellLocal { sp = p.subtle, undercurl = true },
    SpellRare { sp = p.subtle, undercurl = true },
    Substitute { IncSearch },
    TabLine { fg = p.subtle, bg = p.base },
    TabLineFill { bg = p.base },
    TabLineSel { fg = p.text, bg = p.overlay, bold = s.bold },
    Title { fg = p.river, bold = s.bold },
    VertSplit { fg = g.ui.border },
    WildMenu { IncSearch },
    WinBar { fg = p.subtle, bg = g.ui.panel },
    WinBarNC { fg = p.muted, bg = g.ui.panel },
    WinSeparator { fg = g.ui.border },

    -- diagnostics
    DiagnosticError { fg = g.ui.error },
    DiagnosticHint { fg = g.ui.hint },
    DiagnosticInfo { fg = g.ui.info },
    DiagnosticOk { fg = g.ui.ok },
    DiagnosticWarn { fg = g.ui.warn },
    DiagnosticDefaultError { DiagnosticError },
    DiagnosticDefaultHint { DiagnosticHint },
    DiagnosticDefaultInfo { DiagnosticInfo },
    DiagnosticDefaultOk { DiagnosticOk },
    DiagnosticDefaultWarn { DiagnosticWarn },
    DiagnosticFloatingError { DiagnosticError },
    DiagnosticFloatingHint { DiagnosticHint },
    DiagnosticFloatingInfo { DiagnosticInfo },
    DiagnosticFloatingOk { DiagnosticOk },
    DiagnosticFloatingWarn { DiagnosticWarn },
    DiagnosticSignError { DiagnosticError },
    DiagnosticSignHint { DiagnosticHint },
    DiagnosticSignInfo { DiagnosticInfo },
    DiagnosticSignOk { DiagnosticOk },
    DiagnosticSignWarn { DiagnosticWarn },
    DiagnosticUnderlineError { sp = g.ui.error, undercurl = true },
    DiagnosticUnderlineHint { sp = g.ui.hint, undercurl = true },
    DiagnosticUnderlineInfo { sp = g.ui.info, undercurl = true },
    DiagnosticUnderlineOk { sp = g.ui.ok, undercurl = true },
    DiagnosticUnderlineWarn { sp = g.ui.warn, undercurl = true },
    DiagnosticVirtualTextError { fg = g.ui.error, bg = groups.error },
    DiagnosticVirtualTextHint { fg = g.ui.hint, bg = groups.hint },
    DiagnosticVirtualTextInfo { fg = g.ui.info, bg = groups.info },
    DiagnosticVirtualTextOk { fg = g.ui.ok, bg = groups.ok },
    DiagnosticVirtualTextWarn { fg = g.ui.warn, bg = groups.warn },

    -- syntax
    Comment { fg = p.subtle, italic = s.italic },
    Keyword { fg = p.leaf },
    Conditional { fg = p.leaf },
    Include { fg = p.leaf },
    Constant { fg = p.cherry },
    Boolean { fg = p.cherry },
    Character { fg = p.cherry },
    Debug { fg = p.cherry },
    Number { fg = p.cherry },
    String { fg = p.cherry },
    Error { fg = p.cherry },
    Macro { fg = p.blossom },
    Define { Macro },
    PreCondit { Macro },
    PreProc { PreCondit },
    Identifier { fg = p.text },
    Function { fg = p.text },
    Type { fg = p.text },
    TypeDef { Type },
    Delimiter { fg = p.subtle },
    Operator { fg = p.subtle },
    Exception { fg = p.petal },
    Special { fg = p.subtle },
    SpecialChar { Special },
    SpecialComment { fg = p.leaf },
    LspReferenceRead { bg = p.highlight_low },
    LspReferenceText { bg = p.highlight_low },
    LspReferenceWrite { bg = p.highlight_low },
    LspCodeLens { fg = p.subtle },
    LspCodeLensSeparator { fg = p.muted },
    LspInlayHint { fg = o.lsp.inlay_hint.bg and p.subtle or p.muted, bg = o.lsp.inlay_hint.bg and p.surface },
    Tag { fg = p.text },
    Label { fg = p.river },
    Repeat { fg = p.river },
    Statement { fg = p.river },
    StorageClass { fg = p.river },
    Structure { fg = p.river },
    Underlined { underline = true },
    Todo { fg = p.base, bg = g.ui.todo, bold = s.bold },

    -- health
    healthSuccess { fg = g.ui.success },
    healthError { fg = g.ui.error },
    healthWarning { fg = g.ui.warn },

    -- markdown
    markdownDelimiter { fg = p.subtle },
    markdownH1 { fg = g.heading.h1, bg = p.base.mix(g.heading.h1, 25) },
    markdownH1Delimiter { markdownH1 },
    markdownH2 { fg = g.heading.h2, bg = p.base.mix(g.heading.h2, 25) },
    markdownH2Delimiter { markdownH2 },
    markdownH3 { fg = g.heading.h3, bg = p.base.mix(g.heading.h3, 25) },
    markdownH3Delimiter { markdownH3 },
    markdownH4 { fg = g.heading.h4, bg = p.base.mix(g.heading.h4, 25) },
    markdownH4Delimiter { markdownH4 },
    markdownH5 { fg = g.heading.h5, bg = p.base.mix(g.heading.h5, 25) },
    markdownH5Delimiter { markdownH5 },
    markdownH6 { fg = g.heading.h6, bg = p.base.mix(g.heading.h6, 25) },
    markdownH6Delimiter { markdownH6 },
    markdownLinkText { fg = g.ui.link },
    markdownUrl { markdownLinkText },
    mkdLink { markdownUrl },
    mkdLinkDef { markdownUrl },
    mkdListItemLine { fg = p.text },
    mkdRule { fg = p.subtle },
    mkdURL { markdownUrl },

    -- html
    htmlArg { fg = p.blossom },
    htmlBold { bold = s.bold },
    htmlEndTag { fg = p.subtle },
    htmlH1 { markdownH1 },
    htmlH2 { markdownH2 },
    htmlH3 { markdownH3 },
    htmlH4 { markdownH4 },
    htmlH5 { markdownH5 },
    htmlItalic { italic = s.italic },
    htmlLink { markdownUrl },
    htmlTag { fg = p.subtle },
    htmlTagN { fg = p.text },
    htmlTagName { fg = p.river },

    -- Treesitter
    -- |:help treesitter-highlight-g|
    sym "@variable" { Identifier },
    sym "@variable.builtin" { Identifier, bold = s.bold },
    sym "@variable.parameter" { fg = p.text },
    sym "@variable.parameter.builtin" { fg = p.petal, bold = s.bold },
    sym "@variable.member" { fg = p.text },

    sym "@constant" { Constant },
    sym "@constant.builtin" { fg = p.branch, bold = s.bold },
    sym "@constant.macro" { Macro },

    sym "@module" { fg = p.text },
    sym "@module.builtin" { fg = p.text, bold = s.bold },
    sym "@label" { Label },

    sym "@string" { String },
    sym "@string.ui.regexp" { fg = p.petal },
    sym "@string.ui.escape" { fg = p.leaf },
    sym "@string.ui.special" { String },
    sym "@string.ui.special.symbol" { Identifier },
    sym "@string.ui.special.url" { fg = g.ui.link },
    sym "@character.special" { Special },

    sym "@boolean" { Boolean },
    sym "@number" { Number },
    sym "@number.float" { Number },
    sym "@float" { Number },

    sym "@type" { Type },
    sym "@type.builtin" { Type, bold = s.bold },

    sym "@attribute" { fg = p.blossom },
    sym "@attribute.builtin" { fg = p.blossom, bold = s.bold },
    sym "@property" { fg = p.text, italic = s.italic },

    sym "@function" { Function },
    sym "@function.builtin" { Function, bold = s.bold },
    sym "@function.macro" { Macro },

    sym "@function.method" { fg = p.leaf },
    sym "@function.method.call" { fg = p.leaf },

    sym "@constructor" { fg = p.subtle },
    sym "@operator" { Operator },

    sym "@keyword" { Keyword },
    sym "@keyword.operator" { Operator },
    sym "@keyword.import" { Keyword },
    sym "@keyword.storage" { StorageClass },
    sym "@keyword.repeat" { Repeat },
    sym "@keyword.return" { Keyword },
    sym "@keyword.debug" { Debug },
    sym "@keyword.exception" { Exception },

    sym "@keyword.conditional" { Conditional },
    sym "@keyword.conditional.ternary" { Conditional },

    sym "@keyword.directive" { Macro },
    sym "@keyword.directive.define" { Macro },

    -- Punctuation
    sym "@punctuation.delimiter" { Delimiter },
    sym "@punctuation.bracket" { Delimiter },
    sym "@punctuation.special" { Special },

    -- Comments
    sym "@comment" { Comment },

    sym "@comment.error" { fg = g.ui.error },
    sym "@comment.warning" { fg = g.ui.warn },
    sym "@comment.todo" { fg = p.base, bg = g.ui.todo },
    sym "@comment.hint" { fg = p.base, bg = g.ui.hint },
    sym "@comment.info" { fg = p.base, bg = g.ui.info },
    sym "@comment.note" { fg = p.base, bg = g.ui.note },

    -- Markup
    sym "@markup.strong" { bold = s.bold },
    sym "@markup.italic" { italic = s.italic },
    sym "@markup.strikethrough" { strikethrough = true },
    sym "@markup.underline" { underline = true },

    sym "@markup.heading" { fg = p.petal },

    sym "@markup.quote" { fg = p.text },
    sym "@markup.math" { Special },
    sym "@markup.environment" { Macro },
    sym "@markup.environment.name" { Type },

    sym "@markup.link" {},
    sym "@markup.link.markdown_inline" { fg = p.subtle },
    sym "@markup.link.label.markdown_inline" { fg = p.river },
    sym "@markup.link.url" { fg = g.ui.link },

    sym "@markup.raw" {},
    sym "@markup.raw.block" { bg = p.base },
    sym "@markup.raw.delimiter.markdown" { fg = p.subtle },

    sym "@markup.list" { fg = p.leaf },
    sym "@markup.list.checked" { fg = p.river, bg = p.river },
    sym "@markup.list.unchecked" { fg = p.text },

    -- Markdown headings
    sym "@markup.heading.ui.1.markdown" { markdownH1 },
    sym "@markup.heading.ui.2.markdown" { markdownH2 },
    sym "@markup.heading.ui.3.markdown" { markdownH3 },
    sym "@markup.heading.ui.4.markdown" { markdownH4 },
    sym "@markup.heading.ui.5.markdown" { markdownH5 },
    sym "@markup.heading.ui.6.markdown" { markdownH6 },
    sym "@markup.heading.ui.1.marker.markdown" { markdownH1Delimiter },
    sym "@markup.heading.ui.2.marker.markdown" { markdownH2Delimiter },
    sym "@markup.heading.ui.3.marker.markdown" { markdownH3Delimiter },
    sym "@markup.heading.ui.4.marker.markdown" { markdownH4Delimiter },
    sym "@markup.heading.ui.5.marker.markdown" { markdownH5Delimiter },
    sym "@markup.heading.ui.6.marker.markdown" { markdownH6Delimiter },

    sym "@diff.plus" { DiffAdd },
    sym "@diff.minus" { DiffDelete },
    sym "@diff.delta" { DiffChange },

    sym "@tag" { Tag },
    sym "@tag.ui.attribute" { fg = p.blossom },
    sym "@tag.ui.delimiter" { Delimiter },

    -- Non-highlighting captures
    sym "@none" {},
    sym "@conceal" { Conceal },
    sym "@conceal.markdown" { fg = p.subtle },

    -- Semantic highlights
    sym "@lsp.type.comment" {},
    sym "@lsp.type.comment.c" { sym "@comment" },
    sym "@lsp.type.comment.cpp" { sym "@comment" },
    sym "@lsp.type.enum" { sym "@type" },
    sym "@lsp.type.interface" { sym "@type" },
    sym "@lsp.type.keyword" { sym "@keyword" },
    sym "@lsp.type.namespace" { sym "@module" },
    sym "@lsp.type.namespace.python" { sym "@variable" },
    sym "@lsp.type.parameter" { sym "@variable.parameter" },
    sym "@lsp.type.property" { sym "@property" },
    -- sym("@lsp.type.variable") {}, -- defer to treesitter for regular variables
    sym "@lsp.type.variable.svelte" { sym "@variable" },
    sym "@lsp.typemod.function.defaultLibrary" { sym "@function.builtin" },
    sym "@lsp.typemod.operator.injected" { sym "@operator" },
    sym "@lsp.typemod.string.ui.injected" { sym "@string" },
    sym "@lsp.typemod.variable.constant" { sym "@constant" },
    sym "@lsp.typemod.variable.defaultLibrary" { sym "@variable.builtin" },
    sym "@lsp.typemod.variable.injected" { sym "@variable" },

    -- Plugins

    -- jake-stewart/multicursor.nvim
    MultiCursorCursor = { fg = p.base, bg = p.cherry },
    MultiCursorDisabledCursor = { Cursor, bg = p.muted },

    -- milanglacier/minuet-ai.nvim
    MinuetVirtualText = { Comment },

    -- lewis6991/gitsigns.nvim
    GitSignsAdd { fg = g.git.add },
    GitSignsChange { fg = g.git.change },
    GitSignsDelete { fg = g.git.delete },
    SignAdd { fg = g.git.add },
    SignChange { fg = g.git.change },
    SignDelete { fg = g.git.delete },

    -- folke/which-key.nvim
    WhichKey { fg = p.subtle },
    WhichKeyFloat { Float },
    WhichKeyBorder { FloatBorder },
    WhichKeyDesc { fg = p.text },
    WhichKeyGroup { fg = p.river },
    WhichKeyIcon { fg = p.leaf },
    WhichKeyIconAzure { fg = p.leaf },
    WhichKeyIconBlue { fg = p.leaf },
    WhichKeyIconCyan { fg = p.river },
    WhichKeyIconGreen { fg = p.leaf },
    WhichKeyIconGrey { fg = p.subtle },
    WhichKeyIconOrange { fg = p.petal },
    WhichKeyIconPurple { fg = p.blossom },
    WhichKeyIconRed { fg = p.cherry },
    WhichKeyIconYellow { fg = p.branch },
    WhichKeyNormal { NormalFloat },
    WhichKeySeparator { fg = p.subtle },
    WhichKeyTitle { FloatTitle },
    WhichKeyValue { fg = p.cherry },

    -- NeogitOrg/neogit
    -- https://github.com/NeogitOrg/neogit/blob/master/lua/neogit/lib/hl.lua#L109-L198
    NeogitChangeAdded { fg = g.git.add, bold = s.bold, italic = s.italic },
    NeogitChangeBothModified { fg = g.git.change, bold = s.bold, italic = s.italic },
    NeogitChangeCopied { fg = g.git.untracked, bold = s.bold, italic = s.italic },
    NeogitChangeDeleted { fg = g.git.delete, bold = s.bold, italic = s.italic },
    NeogitChangeModified { fg = g.git.change, bold = s.bold, italic = s.italic },
    NeogitChangeNewFile { fg = g.git.stage, bold = s.bold, italic = s.italic },
    NeogitChangeRenamed { fg = g.git.rename, bold = s.bold, italic = s.italic },
    NeogitChangeUpdated { fg = g.git.change, bold = s.bold, italic = s.italic },
    NeogitDiffAddHighlight { DiffAdd },
    NeogitDiffContextHighlight { bg = p.surface },
    NeogitDiffDeleteHighlight { DiffDelete },
    NeogitFilePath { fg = p.river, italic = s.italic },
    NeogitHunkHeader { bg = g.ui.panel },
    NeogitHunkHeaderHighlight { bg = g.ui.panel },

    -- folke/trouble.nvim
    TroubleText { fg = p.subtle },
    TroubleCount { fg = p.subtle, bg = p.surface },
    TroublePos { TroubleCount },
    TroubleNormal { fg = p.text, bg = g.ui.panel },
    TroubleIndent { fg = g.ui.indent.dim },

    -- echasnovski/mini.nvim
    MiniCursorword { underdotted = true },
    MiniCursorwordCurrent { underdotted = true },

    MiniJump { sp = p.branch, underdotted = true },

    -- nvim-treesitter/nvim-treesitter-context
    TreesitterContext { bg = p.overlay },
    TreesitterContextLineNumber { fg = p.river, bg = p.overlay },

    -- MeanderingProgrammer/render-markdown.nvim
    RenderMarkdownBullet { fg = p.blossom },
    RenderMarkdownChecked { fg = p.river },
    RenderMarkdownCode { bg = p.overlay },
    RenderMarkdownCodeInline { fg = p.text, bg = p.overlay },
    RenderMarkdownDash { fg = p.muted },
    RenderMarkdownH1Bg { markdownH1 },
    RenderMarkdownH2Bg { markdownH2 },
    RenderMarkdownH3Bg { markdownH3 },
    RenderMarkdownH4Bg { markdownH4 },
    RenderMarkdownH5Bg { markdownH5 },
    RenderMarkdownH6Bg { markdownH6 },
    RenderMarkdownQuote { fg = p.subtle },
    RenderMarkdownTableFill { Conceal },
    RenderMarkdownTableHead { fg = p.subtle },
    RenderMarkdownTableRow { fg = p.subtle },
    RenderMarkdownUnchecked { fg = p.subtle },

    -- Saghen/blink.cmp
    BlinkCmpMenu { Float },
    BlinkCmpMenuBorder { FloatBorder },
    BlinkCmpMenuSelection { CursorLine },

    BlinkCmpDoc { bg = Float.bg },
    BlinkCmpDocSeparator { bg = Float.bg },
    BlinkCmpDocBorder { fg = g.ui.border, bg = Float.bg },
    BlinkCmpGhostText { fg = p.muted },

    BlinkCmpLabel { fg = p.subtle },
    BlinkCmpLabelDeprecated { fg = p.muted, strikethrough = true },
    BlinkCmpLabelMatch { fg = p.text, bold = s.bold },

    BlinkCmpDefault { fg = p.highlight_high },
    BlinkCmpKindText { fg = p.leaf },
    BlinkCmpKindMethod { fg = p.river },
    BlinkCmpKindFunction { fg = p.river },
    BlinkCmpKindConstructor { fg = p.river },
    BlinkCmpKindField { fg = p.leaf },
    BlinkCmpKindVariable { fg = p.blossom },
    BlinkCmpKindClass { fg = p.branch },
    BlinkCmpKindInterface { fg = p.branch },
    BlinkCmpKindModule { fg = p.river },
    BlinkCmpKindProperty { fg = p.river },
    BlinkCmpKindUnit { fg = p.leaf },
    BlinkCmpKindValue { fg = p.cherry },
    BlinkCmpKindKeyword { fg = p.petal },
    BlinkCmpKindSnippet { fg = p.blossom },
    BlinkCmpKindColor { fg = p.cherry },
    BlinkCmpKindFile { fg = p.river },
    BlinkCmpKindReference { fg = p.cherry },
    BlinkCmpKindFolder { fg = p.river },
    BlinkCmpKindEnum { fg = p.river },
    BlinkCmpKindEnumMember { fg = p.river },
    BlinkCmpKindConstant { fg = p.branch },
    BlinkCmpKindStruct { fg = p.river },
    BlinkCmpKindEvent { fg = p.river },
    BlinkCmpKindOperator { fg = p.river },
    BlinkCmpKindTypeParameter { fg = p.petal },
    BlinkCmpKindCodeium { fg = p.river },
    BlinkCmpKindCopilot { fg = p.river },
    BlinkCmpKindSupermaven { fg = p.river },
    BlinkCmpKindTabNine { fg = p.river },

    -- folke/snacks.nvim
    SnacksPickerMatch { fg = Search.bg, bold = s.bold },
    SnacksIndent { fg = g.ui.indent.dim },
    SnacksIndentScope { fg = g.ui.indent.scope },

    -- nvim-neotest/neotest
    NeotestAdapterName { fg = p.petal },
    NeotestBorder { fg = g.ui.border },
    NeotestDir { Directory },
    NeotestExpandMarker { fg = p.highlight_med },
    NeotestFailed { fg = p.cherry },
    NeotestFile { fg = p.text },
    NeotestFocused { fg = p.text, bg = p.highlight_low },
    NeotestIndent { fg = p.highlight_med },
    NeotestMarked { fg = p.blossom, bold = s.bold },
    NeotestNamespace { fg = p.branch },
    NeotestPassed { fg = p.leaf },
    NeotestRunning { fg = p.branch },
    NeotestWinSelect { fg = p.muted },
    NeotestSkipped { fg = p.subtle },
    NeotestTarget { fg = p.cherry },
    NeotestTest { fg = p.branch },
    NeotestUnknown { fg = p.subtle },
    NeotestWatching { fg = p.river },
  }

  -- return vim.tbl_deep_extend("force", default_highlights, opts.highlights)
  return default_highlights
end)
