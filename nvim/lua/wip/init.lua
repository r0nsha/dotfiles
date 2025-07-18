---@alias wip.Color table

--- @class wip.Palette
--- @field dark0 wip.Color
--- @field dark1 wip.Color
--- @field base wip.Color
--- @field surface0 wip.Color
--- @field surface1 wip.Color
--- @field overlay wip.Color
--- @field subtext0 wip.Color
--- @field subtext1 wip.Color
--- @field text wip.Color
--- @field cherry wip.Color
--- @field petal wip.Color
--- @field stone wip.Color
--- @field branch wip.Color
--- @field leaf wip.Color
--- @field river wip.Color

--- @class wip.Palettes
--- @field low_contrast wip.Palette

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
---   match: wip.Color,
---   success: wip.Color,
---   error: wip.Color,
---   hint: wip.Color,
---   info: wip.Color,
---   ok: wip.Color,
---   warn: wip.Color,
---   note: wip.Color,
---   todo: wip.Color,
---   link: wip.Color,
---   ghost: wip.Color,
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
---@field markup {
---   h1: wip.Color,
---   h2: wip.Color,
---   h3: wip.Color,
---   h4: wip.Color,
---   h5: wip.Color,
---   h6: wip.Color,
---}

local lush = require("lush")
local hsluv = lush.hsluv

local M = {}

-- TODO: fix notify thing
-- TODO: transparency

---@return wip.Palette
local function low_contrast()
  local cherry = hsluv(3, 56, 50)
  local stone = hsluv(100, 14, 80)
  local petal = hsluv(324, 34, 64)
  local branch = hsluv(43, 48, 66)
  local leaf = hsluv(148, 56, 56)
  local river = hsluv(208, 62, 74)
  local base = hsluv(235, 40, 27)
  local dark1 = base.da(24).de(8).ro(4)
  local dark0 = dark1.da(24).de(8).ro(4)
  local surface0 = base.li(6).de(4).mix(cherry, 2)
  local surface1 = surface0.li(4)
  local overlay = surface1.li(16).de(4).mix(cherry, 4)
  local subtext0 = overlay.li(24).de(24).mix(cherry, 8)
  local subtext1 = subtext0.li(24)
  local text = subtext1.li(64)

  return {
    dark0 = dark0,
    dark1 = dark1,
    base = base,
    surface0 = surface0,
    surface1 = surface1,
    overlay = overlay,
    subtext0 = subtext0,
    subtext1 = subtext1,
    text = text,
    cherry = cherry,
    petal = petal,
    stone = stone,
    branch = branch,
    leaf = leaf,
    river = river,
  }
end

---@type wip.Palettes
local palettes = {
  low_contrast = low_contrast(),
}

local palette = palettes.low_contrast

---@param config wip.Config?
function M.setup(config)
  ---@type wip.Config
  local defaults = {
    opts = {
      signcolumn = {
        bg = true,
      },
      float = {
        bg = true,
      },
      lsp = {
        inlay_hint = {
          bg = false,
        },
      },
    },

    styles = {
      bold = true,
      italic = true,
      transparency = false,
    },

    groups = {
      ui = {
        border = palette.overlay,
        panel = palette.dark0,
        indent = {
          dim = palette.overlay,
          scope = palette.subtext1,
        },
        match = palette.branch,
        success = palette.leaf,
        error = palette.cherry,
        hint = palette.petal,
        info = palette.river,
        ok = palette.leaf,
        warn = palette.branch,
        note = palette.leaf,
        todo = palette.river,
        link = palette.river,
        ghost = palette.subtext0,
      },

      git = {
        add = palette.leaf,
        change = palette.branch,
        delete = palette.cherry,
        dirty = palette.branch,
        ignore = palette.subtext0,
        merge = palette.branch,
        rename = palette.petal,
        stage = palette.branch,
        text = palette.branch,
        untracked = palette.subtext1,
      },

      markup = {
        h1 = palette.river,
        h2 = palette.leaf,
        h3 = palette.branch,
        h4 = palette.petal,
        h5 = palette.stone,
        h6 = palette.cherry,
      },
    },

    highlights = {},
  }

  local c = vim.tbl_deep_extend("force", defaults, config)

  return lush(function(injected_functions)
    ---@diagnostic disable: undefined-global
    local sym = injected_functions.sym

    local p = palette
    local s = c.styles
    local g = c.groups
    local o = c.opts

    if not o.float.bg then
      g.ui.panel = p.base
    end

    local signcolumn_bg = o.signcolumn.bg and p.dark1

    local default_highlights = {
      Normal({ fg = p.text, bg = p.base }),
      NormalNC({ fg = p.text, bg = p.base }),
      LineNr({ fg = p.overlay, bg = signcolumn_bg }),
      SignColumn({ LineNr }),
      Cursor({ fg = p.text, bg = p.overlay }),
      CursorLine({ bg = p.surface0 }),
      CursorLineNr({ fg = p.text, bg = o.signcolumn.bg and p.dark0, bold = s.bold }),
      CursorLineSign({ CursorLineNr }),
      CursorColumn({ CursorLine }),
      ColorColumn({ bg = p.dark1 }),
      Visual({ bg = p.surface1 }),
      NonText({ fg = p.overlay }),
      Conceal({ bg = p.surface1, fg = p.subtext1 }),
      MatchParen({ fg = p.text, bg = p.surface1 }),

      -- search
      Search({ fg = p.base, bg = g.ui.match }),
      CurSearch({ Search }),
      IncSearch({ CurSearch }),

      -- diff
      DiffAdd({ bg = g.git.add.mix(p.base, 55) }),
      DiffChange({ bg = g.git.change.mix(p.base, 65) }),
      DiffDelete({ fg = g.git.delete }),
      DiffText({ bg = g.git.text.mix(p.base, 65) }),
      diffAdded({ fg = g.git.add }),
      diffChanged({ fg = g.git.change }),
      diffRemoved({ fg = g.git.delete }),
      Added({ DiffAdd }),
      Changed({ DiffChange }),
      Removed({ DiffDelete }),
      Directory({ fg = p.river, bold = s.bold }),
      EndOfBuffer({ NonText }),

      -- folds
      FoldColumn({ fg = p.subtext1 }),
      Folded({ fg = p.subtext0, bg = p.dark0 }),

      -- msg
      ModeMsg({ fg = p.subtext1 }),
      MoreMsg({ fg = p.petal }),
      ErrorMsg({ bg = g.ui.error, fg = p.base, bold = s.bold }),
      WarningMsg({ fg = g.ui.warn, bold = s.bold }),
      NvimInternalError({ ErrorMsg }),

      -- floats
      NormalFloat({ fg = p.text, bg = g.ui.panel }),
      Float({ fg = p.text, bg = g.ui.panel }),
      FloatBorder({ fg = g.ui.border, bg = g.ui.panel }),
      FloatTitle({ fg = p.subtext0, bg = g.ui.panel, bold = s.bold }),

      -- menu
      Pmenu({ Float }),
      PmenuMatch({ fg = g.ui.match, bold = s.bold }),
      PmenuExtra({ fg = p.subtext0, bg = Float.bg }),
      PmenuExtraSel({ fg = p.subtext1, bg = p.surface1 }),
      PmenuKind({ fg = p.river, bg = Float.bg }),
      PmenuKindSel({ fg = p.subtext1, bg = p.surface1 }),
      PmenuSbar({ bg = Float.bg }),
      PmenuSel({ fg = p.text, bg = p.surface1 }),
      PmenuThumb({ bg = p.subtext0 }),

      -- statusline
      StatusLine({ fg = p.subtext1, bg = p.surface1 }),
      StatusLineNC({ fg = p.subtext0, bg = p.surface0 }),
      StatusLineTerm({ fg = p.base, bg = p.petal }),
      StatusLineTermNC({ fg = p.base, bg = p.petal }),

      Question({ fg = p.cherry }),
      QuickFixLine({ fg = p.stone }),
      RedrawDebugClear({ fg = p.base, bg = p.leaf }),
      RedrawDebugComposed({ fg = p.base, bg = p.petal }),
      RedrawDebugRecompose({ fg = p.base, bg = p.stone }),
      SpecialKey({ fg = p.leaf }),
      SpellBad({ sp = p.subtext1, undercurl = true }),
      SpellCap({ sp = p.subtext1, undercurl = true }),
      SpellLocal({ sp = p.subtext1, undercurl = true }),
      SpellRare({ sp = p.subtext1, undercurl = true }),
      Substitute({ IncSearch }),
      TabLineFill({ bg = p.dark0 }),
      TabLine({ fg = p.subtext0, bg = p.base }),
      TabLineSel({ fg = p.text, bg = p.surface1, bold = s.bold }),
      Title({ fg = p.river, bold = s.bold }),
      VertSplit({ fg = g.ui.border }),
      WildMenu({ IncSearch }),
      WinBar({ fg = p.subtext1, bg = g.ui.panel }),
      WinBarNC({ fg = p.subtext0, bg = g.ui.panel }),
      WinSeparator({ fg = g.ui.border }),

      -- diagnostics
      DiagnosticError({ fg = g.ui.error }),
      DiagnosticHint({ fg = g.ui.hint }),
      DiagnosticInfo({ fg = g.ui.info }),
      DiagnosticOk({ fg = g.ui.ok }),
      DiagnosticWarn({ fg = g.ui.warn }),
      DiagnosticDefaultError({ DiagnosticError }),
      DiagnosticDefaultHint({ DiagnosticHint }),
      DiagnosticDefaultInfo({ DiagnosticInfo }),
      DiagnosticDefaultOk({ DiagnosticOk }),
      DiagnosticDefaultWarn({ DiagnosticWarn }),
      DiagnosticFloatingError({ DiagnosticError }),
      DiagnosticFloatingHint({ DiagnosticHint }),
      DiagnosticFloatingInfo({ DiagnosticInfo }),
      DiagnosticFloatingOk({ DiagnosticOk }),
      DiagnosticFloatingWarn({ DiagnosticWarn }),
      DiagnosticSignError({ DiagnosticError }),
      DiagnosticSignHint({ DiagnosticHint }),
      DiagnosticSignInfo({ DiagnosticInfo }),
      DiagnosticSignOk({ DiagnosticOk }),
      DiagnosticSignWarn({ DiagnosticWarn }),
      DiagnosticUnderlineError({ sp = g.ui.error, undercurl = true }),
      DiagnosticUnderlineHint({ sp = g.ui.hint, undercurl = true }),
      DiagnosticUnderlineInfo({ sp = g.ui.info, undercurl = true }),
      DiagnosticUnderlineOk({ sp = g.ui.ok, undercurl = true }),
      DiagnosticUnderlineWarn({ sp = g.ui.warn, undercurl = true }),
      DiagnosticVirtualTextError({ fg = g.ui.error, bg = groups.error }),
      DiagnosticVirtualTextHint({ fg = g.ui.hint, bg = groups.hint }),
      DiagnosticVirtualTextInfo({ fg = g.ui.info, bg = groups.info }),
      DiagnosticVirtualTextOk({ fg = g.ui.ok, bg = groups.ok }),
      DiagnosticVirtualTextWarn({ fg = g.ui.warn, bg = groups.warn }),
      DiagnosticUnnecessary({ fg = p.subtext1 }),

      -- syntax
      Comment({ fg = p.leaf, italic = s.italic }),
      Keyword({ fg = p.stone }),
      Conditional({ fg = p.stone }),
      Include({ fg = p.stone }),
      Repeat({ fg = p.stone }),
      Exception({ fg = p.stone }),
      Statement({ fg = p.stone }),
      StorageClass({ fg = p.stone }),
      Constant({ fg = p.cherry }),
      Boolean({ fg = p.cherry }),
      Number({ fg = p.cherry }),
      String({ fg = p.leaf }),
      Character({ fg = p.leaf }),
      Macro({ fg = p.petal }),
      Define({ Macro }),
      PreCondit({ Macro }),
      PreProc({ PreCondit }),
      Label({ fg = p.petal }),
      Error({ fg = p.cherry }),
      Debug({ fg = p.cherry }),
      Identifier({ fg = p.text }),
      Function({ fg = p.subtext1 }),
      Type({ fg = p.subtext1 }),
      TypeDef({ Type }),
      Structure({ Type }),
      Delimiter({ fg = p.subtext0 }),
      Operator({ fg = p.subtext0 }),
      Special({ fg = p.subtext1 }),
      SpecialChar({ Special }),
      SpecialComment({ fg = p.leaf }),
      LspReferenceRead({ bg = p.overlay }),
      LspReferenceText({ bg = p.overlay }),
      LspReferenceWrite({ bg = p.overlay }),
      LspCodeLens({ fg = p.subtext1 }),
      LspCodeLensSeparator({ fg = p.subtext0 }),
      LspInlayHint({ fg = o.lsp.inlay_hint.bg and p.subtext0 or p.overlay, bg = o.lsp.inlay_hint.bg and p.surface0 }),
      Tag({ fg = p.text }),
      Underlined({ underline = true }),
      Todo({ fg = p.base, bg = g.ui.todo, bold = s.bold }),

      -- health
      healthSuccess({ fg = g.ui.success }),
      healthError({ fg = g.ui.error }),
      healthWarning({ fg = g.ui.warn }),

      -- markdown
      markdownDelimiter({ fg = p.subtext1 }),
      markdownH1({ fg = g.markup.h1, bg = p.base.mix(g.markup.h1, 25), bold = s.bold }),
      markdownH1Delimiter({ markdownH1 }),
      markdownH2({ fg = g.markup.h2, bg = p.base.mix(g.markup.h2, 25), bold = s.bold }),
      markdownH2Delimiter({ markdownH2 }),
      markdownH3({ fg = g.markup.h3, bg = p.base.mix(g.markup.h3, 25), bold = s.bold }),
      markdownH3Delimiter({ markdownH3 }),
      markdownH4({ fg = g.markup.h4, bg = p.base.mix(g.markup.h4, 25), bold = s.bold }),
      markdownH4Delimiter({ markdownH4 }),
      markdownH5({ fg = g.markup.h5, bg = p.base.mix(g.markup.h5, 25), bold = s.bold }),
      markdownH5Delimiter({ markdownH5 }),
      markdownH6({ fg = g.markup.h6, bg = p.base.mix(g.markup.h6, 25), bold = s.bold }),
      markdownH6Delimiter({ markdownH6 }),
      markdownLinkText({ fg = g.ui.link }),
      markdownUrl({ markdownLinkText }),
      mkdLink({ markdownUrl }),
      mkdLinkDef({ markdownUrl }),
      mkdListItemLine({ fg = p.text }),
      mkdRule({ fg = p.subtext1 }),
      mkdURL({ markdownUrl }),

      -- html
      htmlArg({ fg = p.petal }),
      htmlBold({ bold = s.bold }),
      htmlEndTag({ fg = p.subtext1 }),
      htmlH1({ markdownH1 }),
      htmlH2({ markdownH2 }),
      htmlH3({ markdownH3 }),
      htmlH4({ markdownH4 }),
      htmlH5({ markdownH5 }),
      htmlItalic({ italic = s.italic }),
      htmlLink({ markdownUrl }),
      htmlTag({ fg = p.subtext1 }),
      htmlTagN({ fg = p.text }),
      htmlTagName({ fg = p.river }),

      -- Treesitter
      -- |:help treesitter-highlight-g|
      sym("@variable")({ Identifier }),
      sym("@variable.builtin")({ fg = p.river, bold = s.bold }),
      sym("@variable.parameter")({ fg = p.text }),
      sym("@variable.parameter.builtin")({ fg = p.river, bold = s.bold }),
      sym("@variable.member")({ fg = p.text }),

      sym("@constant")({ Constant }),
      sym("@constant.builtin")({ Constant, bold = s.bold }),
      sym("@constant.macro")({ Macro }),

      sym("@module")({ fg = p.text }),
      sym("@module.builtin")({ fg = p.river, bold = s.bold }),
      sym("@label")({ Label }),

      sym("@string")({ String }),
      sym("@string.ui.regexp")({ fg = p.stone }),
      sym("@string.ui.escape")({ fg = p.leaf }),
      sym("@string.ui.special")({ String }),
      sym("@string.ui.special.symbol")({ Identifier }),
      sym("@string.ui.special.url")({ fg = g.ui.link }),
      sym("@character.special")({ Special }),

      sym("@boolean")({ Boolean }),
      sym("@number")({ Number }),
      sym("@number.float")({ Number }),
      sym("@float")({ Number }),

      sym("@type")({ Type }),
      sym("@type.builtin")({ fg = p.river, bold = s.bold }),

      sym("@attribute")({ fg = p.petal }),
      sym("@attribute.builtin")({ sym("@attribute"), bold = s.bold }),
      sym("@property")({ fg = p.text }),

      sym("@function")({ Function }),
      sym("@function.builtin")({ Function, bold = s.bold }),
      sym("@function.macro")({ Macro }),

      sym("@function.method")({ Function }),
      sym("@function.method.call")({ sym("@function.method") }),

      sym("@constructor")({ fg = p.subtext1 }),
      sym("@operator")({ Operator }),

      sym("@keyword")({ Keyword }),
      sym("@keyword.operator")({ Operator }),
      sym("@keyword.import")({ fg = p.petal }),
      sym("@keyword.storage")({ StorageClass }),
      sym("@keyword.repeat")({ Repeat }),
      sym("@keyword.return")({ Keyword }),
      sym("@keyword.debug")({ Debug }),
      sym("@keyword.exception")({ Exception }),

      sym("@keyword.conditional")({ Conditional }),
      sym("@keyword.conditional.ternary")({ Conditional }),

      sym("@keyword.directive")({ Macro }),
      sym("@keyword.directive.define")({ Macro }),

      -- Punctuation
      sym("@punctuation.delimiter")({ Delimiter }),
      sym("@punctuation.bracket")({ Delimiter }),
      sym("@punctuation.special")({ Special }),

      -- Comments
      sym("@comment")({ Comment }),

      sym("@comment.error")({ fg = g.ui.error }),
      sym("@comment.warning")({ fg = g.ui.warn }),
      sym("@comment.todo")({ fg = p.base, bg = g.ui.todo }),
      sym("@comment.hint")({ fg = p.base, bg = g.ui.hint }),
      sym("@comment.info")({ fg = p.base, bg = g.ui.info }),
      sym("@comment.note")({ fg = p.base, bg = g.ui.note }),

      -- Markup
      sym("@markup.strong")({ bold = s.bold }),
      sym("@markup.italic")({ italic = s.italic }),
      sym("@markup.strikethrough")({ strikethrough = true }),
      sym("@markup.underline")({ underline = true }),

      sym("@markup.quote")({ fg = p.text }),
      sym("@markup.math")({ Special }),
      sym("@markup.environment")({ Macro }),
      sym("@markup.environment.name")({ Type }),

      sym("@markup.link")({ fg = g.ui.link }),
      sym("@markup.link.markdown_inline")({ fg = p.subtext1 }),
      sym("@markup.link.label.markdown_inline")({ fg = p.river }),
      sym("@markup.link.url")({ fg = g.ui.link }),

      sym("@markup.raw")({}),
      sym("@markup.raw.block")({ bg = p.base }),
      sym("@markup.raw.delimiter.markdown")({ fg = p.subtext1 }),

      sym("@markup.list")({ fg = p.subtext0 }),
      sym("@markup.list.unchecked")({ fg = p.subtext1 }),
      sym("@markup.list.checked")({ fg = p.leaf }),

      -- Markdown headings
      sym("@markup.heading")({ fg = p.text }),
      sym("@markup.heading.ui.1.markdown")({ markdownH1 }),
      sym("@markup.heading.ui.2.markdown")({ markdownH2 }),
      sym("@markup.heading.ui.3.markdown")({ markdownH3 }),
      sym("@markup.heading.ui.4.markdown")({ markdownH4 }),
      sym("@markup.heading.ui.5.markdown")({ markdownH5 }),
      sym("@markup.heading.ui.6.markdown")({ markdownH6 }),
      sym("@markup.heading.ui.1.marker.markdown")({ markdownH1Delimiter }),
      sym("@markup.heading.ui.2.marker.markdown")({ markdownH2Delimiter }),
      sym("@markup.heading.ui.3.marker.markdown")({ markdownH3Delimiter }),
      sym("@markup.heading.ui.4.marker.markdown")({ markdownH4Delimiter }),
      sym("@markup.heading.ui.5.marker.markdown")({ markdownH5Delimiter }),
      sym("@markup.heading.ui.6.marker.markdown")({ markdownH6Delimiter }),

      sym("@diff.plus")({ DiffAdd }),
      sym("@diff.minus")({ DiffDelete }),
      sym("@diff.delta")({ DiffChange }),

      sym("@tag")({ Tag }),
      sym("@tag.ui.attribute")({ fg = p.petal }),
      sym("@tag.ui.delimiter")({ Delimiter }),

      -- Non-highlighting captures
      sym("@none")({}),
      sym("@conceal")({ Conceal }),
      sym("@conceal.markdown")({ fg = p.subtext1 }),

      -- Semantic highlights
      sym("@lsp.type.comment")({}),
      sym("@lsp.type.comment.c")({ sym("@comment") }),
      sym("@lsp.type.comment.cpp")({ sym("@comment") }),
      sym("@lsp.type.enum")({ sym("@type") }),
      sym("@lsp.type.interface")({ sym("@type") }),
      sym("@lsp.type.keyword")({ sym("@keyword") }),
      sym("@lsp.type.namespace")({ sym("@module") }),
      sym("@lsp.type.namespace.python")({ sym("@variable") }),
      sym("@lsp.type.parameter")({ sym("@variable.parameter") }),
      sym("@lsp.type.property")({ sym("@property") }),
      -- sym("@lsp.type.variable") {}, -- defer to treesitter for regular variables
      sym("@lsp.type.variable.svelte")({ sym("@variable") }),
      sym("@lsp.typemod.function.defaultLibrary")({ sym("@function.builtin") }),
      sym("@lsp.typemod.operator.injected")({ sym("@operator") }),
      sym("@lsp.typemod.string.ui.injected")({ sym("@string") }),
      sym("@lsp.typemod.variable.constant")({ sym("@constant") }),
      sym("@lsp.typemod.variable.defaultLibrary")({ sym("@variable.builtin") }),
      sym("@lsp.typemod.variable.injected")({ sym("@variable") }),

      -- Plugins

      -- jake-stewart/multicursor.nvim
      MultiCursorCursor({ fg = p.base, bg = g.ui.match }),
      MultiCursorDisabledCursor({ fg = p.base, bg = p.overlay }),

      -- milanglacier/minuet-ai.nvim
      MinuetVirtualText({ fg = g.ui.ghost }),

      -- lewis6991/gitsigns.nvim
      GitSignsAdd({ fg = g.git.add }),
      GitSignsChange({ fg = g.git.change }),
      GitSignsDelete({ fg = g.git.delete }),
      SignAdd({ fg = g.git.add }),
      SignChange({ fg = g.git.change }),
      SignDelete({ fg = g.git.delete }),

      -- folke/which-key.nvim
      WhichKey({ fg = p.subtext1 }),
      WhichKeyFloat({ Float }),
      WhichKeyBorder({ FloatBorder }),
      WhichKeyDesc({ fg = p.text }),
      WhichKeyGroup({ fg = p.river }),
      WhichKeyIcon({ fg = p.leaf }),
      WhichKeyIconAzure({ fg = p.leaf }),
      WhichKeyIconBlue({ fg = p.leaf }),
      WhichKeyIconCyan({ fg = p.river }),
      WhichKeyIconGreen({ fg = p.leaf }),
      WhichKeyIconGrey({ fg = p.subtext1 }),
      WhichKeyIconOrange({ fg = p.stone }),
      WhichKeyIconPurple({ fg = p.petal }),
      WhichKeyIconRed({ fg = p.cherry }),
      WhichKeyIconYellow({ fg = p.branch }),
      WhichKeyNormal({ NormalFloat }),
      WhichKeySeparator({ fg = p.subtext1 }),
      WhichKeyTitle({ FloatTitle }),
      WhichKeyValue({ fg = p.cherry }),

      -- NeogitOrg/neogit
      -- https://github.com/NeogitOrg/neogit/blob/master/lua/neogit/lib/hl.lua#L109-L198
      NeogitChangeAdded({ fg = g.git.add, bold = s.bold, italic = s.italic }),
      NeogitChangeBothModified({ fg = g.git.change, bold = s.bold, italic = s.italic }),
      NeogitChangeCopied({ fg = g.git.untracked, bold = s.bold, italic = s.italic }),
      NeogitChangeDeleted({ fg = g.git.delete, bold = s.bold, italic = s.italic }),
      NeogitChangeModified({ fg = g.git.change, bold = s.bold, italic = s.italic }),
      NeogitChangeNewFile({ fg = g.git.stage, bold = s.bold, italic = s.italic }),
      NeogitChangeRenamed({ fg = g.git.rename, bold = s.bold, italic = s.italic }),
      NeogitChangeUpdated({ fg = g.git.change, bold = s.bold, italic = s.italic }),
      NeogitDiffAdd({ fg = g.git.add }),
      NeogitDiffContext({ bg = p.surface0 }),
      NeogitDiffDelete({ fg = g.git.delete }),
      NeogitDiffAddHighlight({ bg = g.git.add.mix(p.base, 75) }),
      NeogitDiffContextHighlight({ bg = p.surface0 }),
      NeogitDiffDeleteHighlight({ bg = g.git.delete.mix(p.base, 75) }),
      NeogitDiffAddCursor({ DiffAdd }),
      NeogitDiffDeleteCursor({ DiffDelete }),
      NeogitDiffAdditions({ NeogitDiffAdd }),
      NeogitDiffDeletions({ NeogitDiffDelete }),
      NeogitFilePath({ fg = p.river, italic = s.italic }),
      NeogitHunkHeader({ fg = p.subtext1, bg = p.dark1 }),
      NeogitHunkHeaderHighlight({ fg = p.text, bg = p.dark1 }),
      NeogitHunkHeaderCursor({ fg = p.text, bg = p.dark0 }),
      NeogitObjectId({ fg = p.text }),
      NeogitSubtleText({ fg = p.subtext1 }),

      -- folke/trouble.nvim
      TroubleNormal({ NormalFloat }),
      TroubleNormalNC({ NormalFloat }),
      TroubleText({ fg = p.subtext1 }),
      TroubleCount({ fg = p.subtext1, bg = p.base }),
      TroublePos({ TroubleCount }),
      TroubleIndent({ fg = g.ui.indent.dim }),

      -- echasnovski/mini.nvim
      MiniCursorword({ underdotted = true }),
      MiniCursorwordCurrent({ underdotted = true }),

      MiniJump({ sp = p.branch, underdotted = true }),

      -- nvim-treesitter/nvim-treesitter-context
      TreesitterContext({ bg = p.surface0 }),
      TreesitterContextLineNumber({ fg = p.subtext0, bg = o.signcolumn.bg and p.surface1 or p.surface0 }),

      -- MeanderingProgrammer/render-markdown.nvim
      RenderMarkdownBullet({ sym("@markup.list") }),
      RenderMarkdownUnchecked({ sym("@markup.list.unchecked") }),
      RenderMarkdownChecked({ sym("@markup.list.checked") }),
      RenderMarkdownCode({ bg = p.surface1 }),
      RenderMarkdownCodeInline({ fg = p.text, bg = p.dark1 }),
      RenderMarkdownDash({ fg = p.subtext0 }),
      RenderMarkdownH1Bg({ markdownH1 }),
      RenderMarkdownH2Bg({ markdownH2 }),
      RenderMarkdownH3Bg({ markdownH3 }),
      RenderMarkdownH4Bg({ markdownH4 }),
      RenderMarkdownH5Bg({ markdownH5 }),
      RenderMarkdownH6Bg({ markdownH6 }),
      RenderMarkdownQuote({ fg = p.subtext1 }),
      RenderMarkdownTableFill({ Conceal }),
      RenderMarkdownTableHead({ fg = p.subtext1 }),
      RenderMarkdownTableRow({ fg = p.subtext1 }),

      -- Saghen/blink.cmp
      BlinkCmpMenu({ Float }),
      BlinkCmpMenuBorder({ FloatBorder }),
      BlinkCmpMenuSelection({ CursorLine }),

      BlinkCmpDoc({ Float }),
      BlinkCmpDocSeparator({ Float }),
      BlinkCmpDocBorder({ fg = g.ui.border, bg = Float.bg }),
      BlinkCmpGhostText({ fg = g.ui.ghost }),

      BlinkCmpLabel({ fg = p.subtext1 }),
      BlinkCmpLabelDeprecated({ fg = p.subtext0, strikethrough = true }),
      BlinkCmpLabelMatch({ fg = g.ui.match, bold = s.bold }),

      BlinkCmpDefault({ fg = p.overlay }),
      BlinkCmpKindText({ fg = p.leaf }),
      BlinkCmpKindMethod({ fg = p.river }),
      BlinkCmpKindFunction({ fg = p.river }),
      BlinkCmpKindConstructor({ fg = p.river }),
      BlinkCmpKindField({ fg = p.leaf }),
      BlinkCmpKindVariable({ fg = p.petal }),
      BlinkCmpKindClass({ fg = p.branch }),
      BlinkCmpKindInterface({ fg = p.branch }),
      BlinkCmpKindModule({ fg = p.river }),
      BlinkCmpKindProperty({ fg = p.river }),
      BlinkCmpKindUnit({ fg = p.leaf }),
      BlinkCmpKindValue({ fg = p.cherry }),
      BlinkCmpKindKeyword({ fg = p.stone }),
      BlinkCmpKindSnippet({ fg = p.petal }),
      BlinkCmpKindColor({ fg = p.cherry }),
      BlinkCmpKindFile({ fg = p.river }),
      BlinkCmpKindReference({ fg = p.cherry }),
      BlinkCmpKindFolder({ fg = p.river }),
      BlinkCmpKindEnum({ fg = p.river }),
      BlinkCmpKindEnumMember({ fg = p.river }),
      BlinkCmpKindConstant({ fg = p.branch }),
      BlinkCmpKindStruct({ fg = p.river }),
      BlinkCmpKindEvent({ fg = p.river }),
      BlinkCmpKindOperator({ fg = p.river }),
      BlinkCmpKindTypeParameter({ fg = p.stone }),
      BlinkCmpKindCodeium({ fg = p.river }),
      BlinkCmpKindCopilot({ fg = p.river }),
      BlinkCmpKindSupermaven({ fg = p.river }),
      BlinkCmpKindTabNine({ fg = p.river }),

      -- folke/snacks.nvim
      SnacksPickerMatch({ fg = g.ui.match, bold = s.bold }),
      SnacksIndent({ fg = g.ui.indent.dim }),
      SnacksIndentScope({ fg = g.ui.indent.scope }),
      SnacksBackdrop({ fg = p.base }),

      -- nvim-neotest/neotest
      NeotestAdapterName({ fg = p.stone }),
      NeotestBorder({ fg = g.ui.border }),
      NeotestDir({ Directory }),
      NeotestExpandMarker({ fg = p.overlay }),
      NeotestFailed({ fg = p.cherry }),
      NeotestFile({ fg = p.text }),
      NeotestFocused({ fg = p.text, bg = p.overlay }),
      NeotestIndent({ fg = p.overlay }),
      NeotestMarked({ fg = p.petal, bold = s.bold }),
      NeotestNamespace({ fg = p.branch }),
      NeotestPassed({ fg = p.leaf }),
      NeotestRunning({ fg = p.branch }),
      NeotestWinSelect({ fg = p.subtext0 }),
      NeotestSkipped({ fg = p.subtext1 }),
      NeotestTarget({ fg = p.cherry }),
      NeotestTest({ fg = p.branch }),
      NeotestUnknown({ fg = p.subtext1 }),
      NeotestWatching({ fg = p.river }),
    }

    -- return vim.tbl_deep_extend("force", default_highlights, opts.highlights)
    return default_highlights
  end)
end

return M.setup({
  styles = { bold = false, italic = true },
  highlights = { Cursor = { bg = "none" } },
})
