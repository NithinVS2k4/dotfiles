-- =============================================================================
-- Snowfall (Custom) — Neovim colorscheme
-- =============================================================================
-- Revised to reduce blue dominance and increase semantic separation.
-- Design direction:
--   - purple keywords
--   - greener strings
--   - distinct literal / constant colors
--   - restrained teal/cyan for functions and interfaces
--   - keep the cold winter atmosphere without flattening the syntax
-- =============================================================================

vim.o.background = "dark"
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "snowfall"

-- ---------------------------------------------------------------------------
-- Palette
-- ---------------------------------------------------------------------------
local c = {
  bg = "#0a0f18",
  bg_alt = "#0e1521",
  bg_float = "#111a28",
  bg_sel = "#182235",
  bg_line = "#111927",
  bg_diff_add = "#0f1d20",
  bg_diff_change = "#151d2c",
  bg_diff_delete = "#21151b",

  fg = "#d8e4f0",
  fg_dim = "#b7c7d6",
  fg_soft = "#90a2b7",
  gutter = "#506275",
  border = "#263345",
  invisible = "#243042",

  keyword = "#b59adf",
  keyword_dim = "#9f89c8",
  string = "#87c59f",
  string_alt = "#6fbf8a",
  func = "#7fc4cc",
  type = "#d0b48e",
  const = "#cfa8b2",
  number = "#bfa0d8",
  special = "#91a3ba",
  comment = "#6b7e94",
  variable = "#e1ecf4",
  property = "#9fbfd0",
  operator = "#c9d0db",

  error = "#c97a86",
  warn = "#d0b27f",
  info = "#8fb6da",
  hint = "#7f95af",

  git_add = "#7fb79d",
  git_change = "#8b9fca",
  git_delete = "#bc7682",
}

-- ---------------------------------------------------------------------------
-- Helper
-- ---------------------------------------------------------------------------
local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ==========================================================================
-- EDITOR CHROME
-- ==========================================================================
hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalNC", { fg = c.fg, bg = c.bg })
hi("NormalFloat", { fg = c.fg, bg = c.bg_float })
hi("FloatBorder", { fg = c.border, bg = c.bg_float })
hi("FloatTitle", { fg = c.fg, bg = c.bg_float, bold = true })

hi("Visual", { bg = c.bg_sel })
hi("Search", { fg = c.bg, bg = c.fg_dim })
hi("IncSearch", { fg = c.bg, bg = c.fg, bold = true })
hi("CurSearch", { fg = c.bg, bg = c.fg, bold = true })

hi("CursorLine", { bg = c.bg_line })
hi("CursorColumn", { bg = c.bg_line })
hi("ColorColumn", { bg = c.bg_line })

hi("LineNr", { fg = c.gutter, bg = c.bg })
hi("CursorLineNr", { fg = c.fg, bg = c.bg, bold = true })
hi("SignColumn", { fg = c.gutter, bg = c.bg })
hi("FoldColumn", { fg = c.gutter, bg = c.bg })
hi("Folded", { fg = c.fg_soft, bg = c.bg_line, italic = true })

hi("NonText", { fg = c.invisible })
hi("SpecialKey", { fg = c.invisible })
hi("Whitespace", { fg = c.invisible })
hi("EndOfBuffer", { fg = c.bg_line })

hi("StatusLine", { fg = c.fg_dim, bg = c.bg_alt })
hi("StatusLineNC", { fg = c.fg_soft, bg = c.bg })
hi("TabLine", { fg = c.fg_soft, bg = c.bg_alt })
hi("TabLineSel", { fg = c.fg, bg = c.bg_float, bold = true })
hi("TabLineFill", { bg = c.bg })

hi("VertSplit", { fg = c.border, bg = c.bg })
hi("WinSeparator", { fg = c.border, bg = c.bg })
hi("Pmenu", { fg = c.fg, bg = c.bg_float })
hi("PmenuSel", { fg = c.fg, bg = c.bg_sel, bold = true })
hi("PmenuSbar", { bg = c.bg_alt })
hi("PmenuThumb", { bg = c.border })
hi("WildMenu", { fg = c.bg, bg = c.fg, bold = true })

hi("MatchParen", { fg = c.fg, bg = c.bg_sel, bold = true })
hi("Cursor", { fg = c.bg, bg = c.fg })
hi("lCursor", { fg = c.bg, bg = c.fg })

-- ==========================================================================
-- DIAGNOSTICS
-- ==========================================================================
hi("DiagnosticError", { fg = c.error })
hi("DiagnosticWarn", { fg = c.warn })
hi("DiagnosticInfo", { fg = c.info })
hi("DiagnosticHint", { fg = c.hint })

hi("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.warn })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.info })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.hint })

hi("DiagnosticVirtualTextError", { fg = c.error, bg = c.bg_diff_delete })
hi("DiagnosticVirtualTextWarn", { fg = c.warn, bg = c.bg_diff_change })
hi("DiagnosticVirtualTextInfo", { fg = c.info, bg = c.bg_diff_change })
hi("DiagnosticVirtualTextHint", { fg = c.hint, bg = c.bg_line })

-- ==========================================================================
-- GIT / DIFF SIGNS
-- ==========================================================================
hi("DiffAdd", { fg = c.git_add, bg = c.bg_diff_add })
hi("DiffChange", { fg = c.git_change, bg = c.bg_diff_change })
hi("DiffDelete", { fg = c.git_delete, bg = c.bg_diff_delete })
hi("DiffText", { fg = c.fg, bg = c.bg_sel, bold = true })

hi("GitSignsAdd", { fg = c.git_add, bg = c.bg })
hi("GitSignsChange", { fg = c.git_change, bg = c.bg })
hi("GitSignsDelete", { fg = c.git_delete, bg = c.bg })

-- ==========================================================================
-- TRADITIONAL VIM SYNTAX GROUPS
-- ==========================================================================
hi("Comment", { fg = c.comment, italic = true })
hi("SpecialComment", { fg = c.comment, italic = true })

hi("String", { fg = c.string })
hi("Character", { fg = c.string_alt })
hi("Number", { fg = c.number })
hi("Float", { fg = c.number })
hi("Boolean", { fg = c.const })
hi("Constant", { fg = c.const })

hi("Keyword", { fg = c.keyword, bold = true })
hi("Statement", { fg = c.keyword, bold = true })
hi("Conditional", { fg = c.keyword, bold = true })
hi("Repeat", { fg = c.keyword, bold = true })
hi("Label", { fg = c.keyword_dim })
hi("Exception", { fg = c.keyword })
hi("PreProc", { fg = c.keyword })
hi("Include", { fg = c.keyword })
hi("Define", { fg = c.keyword })
hi("PreCondit", { fg = c.keyword })
hi("StorageClass", { fg = c.keyword })
hi("Macro", { fg = c.keyword_dim })

hi("Operator", { fg = c.operator, bold = false })
hi("Type", { fg = c.type })
hi("Structure", { fg = c.type })
hi("Typedef", { fg = c.type })
hi("Function", { fg = c.func })
hi("Identifier", { fg = c.variable })

hi("Special", { fg = c.special })
hi("SpecialChar", { fg = c.special })
hi("Delimiter", { fg = c.special })
hi("Tag", { fg = c.fg_dim })
hi("Underlined", { fg = c.fg, underline = true })

hi("Error", { fg = c.error })
hi("ErrorMsg", { fg = c.error })
hi("WarningMsg", { fg = c.warn })

hi("Title", { fg = c.fg, bold = true })
hi("Bold", { bold = true })
hi("Italic", { italic = true })

-- ==========================================================================
-- TREESITTER HIGHLIGHT GROUPS
-- ==========================================================================

-- Comments
hi("@comment", { fg = c.comment, italic = true })
hi("@comment.documentation", { fg = c.comment, italic = true })

-- Strings
hi("@string", { fg = c.string })
hi("@string.escape", { fg = c.special })
hi("@string.special", { fg = c.special })
hi("@string.regex", { fg = c.special })
hi("@character", { fg = c.string_alt })

-- Numbers / constants
hi("@number", { fg = c.number })
hi("@number.float", { fg = c.number })
hi("@float", { fg = c.number })
hi("@boolean", { fg = c.const, bold = true })
hi("@constant", { fg = c.const })
hi("@constant.builtin", { fg = c.const })
hi("@constant.macro", { fg = c.const })

-- Keywords
hi("@keyword", { fg = c.keyword, bold = true })
hi("@keyword.function", { fg = c.keyword, bold = true })
hi("@keyword.return", { fg = c.keyword, bold = true })
hi("@keyword.import", { fg = c.keyword, bold = true })
hi("@keyword.conditional", { fg = c.keyword, bold = true })
hi("@keyword.repeat", { fg = c.keyword, bold = true })
hi("@keyword.exception", { fg = c.keyword, bold = true })
hi("@keyword.modifier", { fg = c.keyword, bold = true })
hi("@keyword.coroutine", { fg = c.keyword, bold = true })
hi("@keyword.operator", { fg = c.keyword, bold = true })

-- Operators / punctuation
hi("@operator", { fg = c.operator })
hi("@punctuation.delimiter", { fg = c.special })
hi("@punctuation.bracket", { fg = c.special })
hi("@punctuation.special", { fg = c.special })

-- Functions / methods / constructors
hi("@function", { fg = c.func })
hi("@function.builtin", { fg = c.func })
hi("@function.call", { fg = c.func })
hi("@function.method", { fg = c.func })
hi("@function.method.call", { fg = c.func })
hi("@constructor", { fg = c.func })
hi("@method", { fg = c.func })
hi("@method.call", { fg = c.func })

-- Types / classes / modules
hi("@type", { fg = c.type })
hi("@type.builtin", { fg = c.type })
hi("@type.qualifier", { fg = c.keyword })
hi("@type.definition", { fg = c.type })
hi("@class", { fg = c.type })
hi("@namespace", { fg = c.type })
hi("@module", { fg = c.type })

-- Variables / properties
hi("@variable", { fg = c.variable })
hi("@variable.builtin", { fg = c.fg_soft })
hi("@variable.parameter", { fg = c.fg_dim })
hi("@variable.member", { fg = c.property })
hi("@field", { fg = c.property })
hi("@property", { fg = c.property })

-- Tags / markup
hi("@tag", { fg = c.fg_dim })
hi("@tag.builtin", { fg = c.fg_dim })
hi("@tag.attribute", { fg = c.fg_soft })
hi("@tag.delimiter", { fg = c.special })

hi("@markup.heading", { fg = c.fg, bold = true })
hi("@markup.strong", { bold = true })
hi("@markup.italic", { italic = true })
hi("@markup.underline", { fg = c.fg, underline = true })
hi("@markup.strikethrough", { fg = c.comment, strikethrough = true })
hi("@markup.raw", { fg = c.fg_soft })
hi("@markup.link", { fg = c.fg, underline = true })
hi("@markup.link.url", { fg = c.fg_soft, underline = true })
hi("@markup.link.label", { fg = c.fg_soft })
hi("@markup.list", { fg = c.keyword })

hi("@error", { fg = c.error })
hi("@none", {})
hi("@conceal", { fg = c.comment })

-- ==========================================================================
-- LANGUAGE-SPECIFIC OVERRIDES
-- ==========================================================================

-- Python
hi("@variable.builtin.python", { fg = c.fg_soft })
hi("@boolean.python", { fg = c.keyword })
hi("@constant.builtin.python", { fg = c.keyword })
hi("@attribute.python", { fg = c.keyword_dim })

-- JSON
hi("@property.json", { fg = c.fg_dim })

-- CSS
hi("@property.css", { fg = c.property })
hi("@type.css", { fg = c.type })
hi("@string.css", { fg = c.string })
hi("@number.css", { fg = c.number })

-- Diff nodes
hi("@diff.plus", { fg = c.git_add })
hi("@diff.minus", { fg = c.git_delete })
hi("@diff.delta", { fg = c.fg_soft })

-- ==========================================================================
-- LSP SEMANTIC TOKENS
-- ==========================================================================

hi("@lsp.type.class", { fg = c.type })
hi("@lsp.type.enum", { fg = c.type })
hi("@lsp.type.enumMember", { fg = c.type })
hi("@lsp.type.interface", { fg = c.type })
hi("@lsp.type.struct", { fg = c.type })
hi("@lsp.type.type", { fg = c.type })
hi("@lsp.type.typeParameter", { fg = c.type })
hi("@lsp.type.namespace", { fg = c.type })
hi("@lsp.type.module", { fg = c.type })

hi("@lsp.type.function", { fg = c.func })
hi("@lsp.type.method", { fg = c.func })
hi("@lsp.type.decorator", { fg = c.keyword_dim })

hi("@lsp.type.variable", { fg = c.variable })
hi("@lsp.type.parameter", { fg = c.fg_dim })
hi("@lsp.type.property", { fg = c.property })

hi("@lsp.type.keyword", { fg = c.keyword })
hi("@lsp.type.string", { fg = c.string })
hi("@lsp.type.comment", { fg = c.comment, italic = true })
hi("@lsp.type.number", { fg = c.number })
hi("@lsp.type.boolean", { fg = c.keyword, bold = true })
hi("@lsp.type.operator", { fg = c.operator })

hi("@lsp.type.selfParameter", { fg = c.fg_soft })
hi("@lsp.type.clsParameter", { fg = c.fg_soft })

hi("@lsp.mod.defaultLibrary", { fg = c.fg_dim })
hi("@lsp.mod.builtin", { fg = c.fg_dim })

-- ==========================================================================
-- RAINBOW DELIMITERS
-- ==========================================================================

hi("RainbowDelimiterRed", { fg = c.special })
hi("RainbowDelimiterYellow", { fg = c.fg_soft })
hi("RainbowDelimiterBlue", { fg = c.special })
hi("RainbowDelimiterOrange", { fg = c.fg_soft })
hi("RainbowDelimiterGreen", { fg = c.special })
hi("RainbowDelimiterViolet", { fg = c.fg_soft })
hi("RainbowDelimiterCyan", { fg = c.special })

-- ==========================================================================
-- UI / MISC
-- ==========================================================================
hi("Directory", { fg = c.fg })
hi("Question", { fg = c.fg })
hi("MoreMsg", { fg = c.fg_dim })
hi("ModeMsg", { fg = c.fg_dim, bold = true })
hi("Conceal", { fg = c.comment })
hi("CursorIM", { fg = c.bg, bg = c.fg })
hi("VisualNOS", { bg = c.bg_sel })
hi("QuickFixLine", { bg = c.bg_sel })
hi("healthSuccess", { fg = c.git_add })

-- Common plugin compatibility groups
hi("TelescopeBorder", { fg = c.border, bg = c.bg_float })
hi("TelescopeNormal", { fg = c.fg, bg = c.bg_float })
hi("TelescopePromptBorder", { fg = c.border, bg = c.bg_alt })
hi("TelescopePromptNormal", { fg = c.fg, bg = c.bg_alt })
hi("TelescopePromptPrefix", { fg = c.fg, bg = c.bg_alt, bold = true })
hi("TelescopeSelection", { fg = c.fg, bg = c.bg_sel })
hi("TelescopeMatching", { fg = c.fg, bold = true })

hi("LspInfoBorder", { fg = c.border, bg = c.bg_float })
hi("WhichKeyFloat", { bg = c.bg_float })
hi("WhichKeyBorder", { fg = c.border, bg = c.bg_float })
hi("WhichKeyTitle", { fg = c.fg, bold = true })
hi("WhichKeyValue", { fg = c.fg_dim })

hi("TroubleNormal", { fg = c.fg, bg = c.bg_float })
hi("TroubleText", { fg = c.fg })
hi("TroubleCount", { fg = c.fg, bg = c.bg_sel })

hi("NotifyINFOBody", { fg = c.fg, bg = c.bg_float })
hi("NotifyWARNBody", { fg = c.fg, bg = c.bg_float })
hi("NotifyERRORBody", { fg = c.fg, bg = c.bg_float })

-- End of theme
