-- =============================================================================
-- Vesper (Custom) — Neovim colorscheme
-- =============================================================================
-- Based on the Vesper VSCode theme by Rauno Freiberg
-- https://github.com/raunofreiberg/vesper
--
-- User modifications applied on top of the base theme:
--   strings:                       #6dd9ba  (original: #99FFE4)
--   keywords (keyword.* scope):    #7cabde  (original: #A0A0A0)
--   keyword.operator.logical.*:    #7cabde  (Python: and / or / not)
--   constant.language.python:      #7cabde  (Python: True / False / None)
--   variable.language.special.self.python: #bfbfbf  (self / cls)
--
-- IMPORTANT: constant.language.python → #7cabde is PYTHON-SPECIFIC.
-- Constants and booleans in other languages remain orange (#FFC799) per the
-- original theme. The file handles this with language-specific overrides.
--
-- =============================================================================
-- INSTALLATION
-- =============================================================================
--
-- 1. Create the colors folder if it doesn't exist:
--      mkdir -p ~/.config/nvim/colors
--
-- 2. Copy this file there:
--      cp vesper-custom.lua ~/.config/nvim/colors/vesper-custom.lua
--
-- 3. In your colorscheme.lua (lazy.nvim), replace the contents with:
--
--      return {
--        {
--          name = "vesper-custom",
--          dir = vim.fn.stdpath("config"),
--          priority = 1000,
--          lazy = false,
--          config = function()
--            vim.cmd("colorscheme vesper-custom")
--          end,
--        },
--      }
--
-- 4. Restart Neovim.
--
-- NOTE ON BRACKET COLORS: The alternating bracket colors (#A0A0A0 / #7a7a7a)
-- require the rainbow-delimiters.nvim plugin. If you don't have it, brackets
-- will be flat #A0A0A0 via @punctuation.bracket. The RainbowDelimiter* groups
-- at the bottom of this file are only active when the plugin is present.
-- =============================================================================

vim.o.background = "dark"
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "vesper"

-- ---------------------------------------------------------------------------
-- Palette
-- ---------------------------------------------------------------------------
local c = {
  bg = "#101010", -- editor.background
  fg = "#ffffff", -- editor.foreground
  orange = "#FFC799", -- functions, classes, numbers, tags, JSON keys
  string = "#6dd9ba", -- strings  (user override; original: #99FFE4)
  keyword = "#7cabde", -- keyword.* scopes  (user override; original: #A0A0A0)
  self_var = "#bfbfbf", -- self / cls  (user override; original: #A0A0A0)
  gray = "#A0A0A0", -- attributes, punctuation, language vars (this/super)
  gray_dim = "#7a7a7a", -- dimmer gray for alternating brackets
  comment = "#8b8b8b", -- comments  (original #8b8b8b94 — semi-transparent; opaque approx)
  red = "#FF8080", -- errors, invalid, deleted
  sel_solid = "#2a2a2a", -- solid approximation of selection (#ffffff25 on #101010)
  line_hl = "#181818", -- current line highlight
  gutter_fg = "#505050", -- line number foreground
  bracket = "#2a2a2a", -- bracket match background
  invisible = "#2e2e2e", -- whitespace markers / right margin
}

-- ---------------------------------------------------------------------------
-- Helper
-- ---------------------------------------------------------------------------
local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ===========================================================================
-- EDITOR CHROME
-- ===========================================================================

hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalFloat", { fg = c.fg, bg = "#161616" })
hi("FloatBorder", { fg = "#282828", bg = "#161616" })
hi("Visual", { bg = c.sel_solid })
hi("Search", { fg = c.bg, bg = c.orange })
hi("IncSearch", { fg = c.bg, bg = c.orange })
hi("CurSearch", { fg = c.bg, bg = c.orange })
hi("CursorLine", { bg = c.line_hl })
hi("CursorColumn", { bg = c.line_hl })
hi("ColorColumn", { bg = c.line_hl })
hi("LineNr", { fg = c.gutter_fg, bg = c.bg })
hi("CursorLineNr", { fg = c.fg, bg = c.bg, bold = true })
hi("SignColumn", { fg = c.gutter_fg, bg = c.bg })
hi("MatchParen", { bg = c.bracket, bold = true })
hi("NonText", { fg = c.invisible })
hi("SpecialKey", { fg = c.invisible })
hi("Whitespace", { fg = c.invisible })
hi("EndOfBuffer", { fg = c.gutter_fg })
hi("Folded", { fg = c.comment, bg = c.line_hl })
hi("FoldColumn", { fg = c.gutter_fg, bg = c.bg })
hi("StatusLine", { fg = c.gray, bg = c.bg })
hi("StatusLineNC", { fg = "#707070", bg = c.bg })
hi("TabLine", { fg = c.gray, bg = c.bg })
hi("TabLineSel", { fg = c.fg, bg = "#161616" })
hi("TabLineFill", { bg = c.bg })
hi("VertSplit", { fg = "#282828", bg = c.bg })
hi("WinSeparator", { fg = "#282828", bg = c.bg })
hi("Pmenu", { fg = c.fg, bg = "#1c1c1c" })
hi("PmenuSel", { fg = c.fg, bg = "#2a2a2a" })
hi("PmenuSbar", { bg = "#1c1c1c" })
hi("PmenuThumb", { bg = "#343434" })
hi("WildMenu", { fg = c.bg, bg = c.orange })

-- ===========================================================================
-- DIAGNOSTICS
-- ===========================================================================

hi("DiagnosticError", { fg = c.red })
hi("DiagnosticWarn", { fg = c.orange })
hi("DiagnosticInfo", { fg = c.keyword })
hi("DiagnosticHint", { fg = c.gray })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.orange })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.keyword })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.gray })

-- ===========================================================================
-- GIT / DIFF SIGNS  (editorGutter.* colors from source JSON)
-- ===========================================================================

hi("DiffAdd", { fg = "#99FFE4", bg = "#141f1c" })
hi("DiffDelete", { fg = c.red, bg = "#1f1414" })
hi("DiffChange", { fg = c.orange, bg = "#1f1a14" })
hi("DiffText", { fg = c.orange, bold = true })

hi("GitSignsAdd", { fg = "#99FFE4", bg = c.bg })
hi("GitSignsChange", { fg = c.orange, bg = c.bg })
hi("GitSignsDelete", { fg = c.red, bg = c.bg })

-- ===========================================================================
-- TRADITIONAL VIM SYNTAX GROUPS
-- ===========================================================================

-- Comments — #8b8b8b94 in original (semi-transparent); rendered opaque here
hi("Comment", { fg = c.comment, italic = true })
hi("SpecialComment", { fg = c.comment, italic = true })

-- Strings — user override: #6dd9ba
hi("String", { fg = c.string })
hi("Character", { fg = c.string })

-- Constants:
--   constant.numeric / constant.character / constant.escape
--   / keyword.other.unit / constant.language.boolean → #FFC799 (orange)
--   constant.language.python is ONLY overridden in the Python-specific section.
hi("Number", { fg = c.orange })
hi("Float", { fg = c.orange })
hi("Boolean", { fg = c.orange }) -- globally orange; Python overrides below
hi("Constant", { fg = c.orange }) -- globally orange; Python overrides below

-- Keywords — user override: #7cabde covers all keyword.* scopes
hi("Keyword", { fg = c.keyword })
hi("Statement", { fg = c.keyword })
hi("Conditional", { fg = c.keyword }) -- if / else / elif
hi("Repeat", { fg = c.keyword }) -- for / while
hi("Label", { fg = c.keyword }) -- case / default
hi("Exception", { fg = c.keyword }) -- try / except / raise
hi("PreProc", { fg = c.keyword }) -- #include / import
hi("Include", { fg = c.keyword })
hi("Define", { fg = c.keyword })
hi("PreCondit", { fg = c.keyword })
hi("StorageClass", { fg = c.keyword }) -- storage.modifier (async, static, etc.)
hi("Macro", { fg = c.orange }) -- macros are function-like → orange

-- Operators:
--   Symbolic operators (+, -, =, ==) have no explicit color in Vesper → fg (white).
--   Keyword operators (and, or, not, in, instanceof) are keyword.* → #7cabde.
--   The vim "Operator" group covers symbolic operators, so fg is correct here.
hi("Operator", { fg = c.fg })

-- Types / Classes — entity.name, support.type, support.class → #FFC799
hi("Type", { fg = c.orange })
hi("Structure", { fg = c.orange })
hi("Typedef", { fg = c.orange })

-- Functions — entity.name.function, support.function → #FFC799
hi("Function", { fg = c.orange })

-- Variables — "variable", "meta.block variable.other" → #FFF
hi("Identifier", { fg = c.fg })

-- Special — constant.character.escape → #A0A0A0
hi("Special", { fg = c.gray })
hi("SpecialChar", { fg = c.gray })
hi("Delimiter", { fg = c.gray })
hi("Tag", { fg = c.orange })

-- Errors
hi("Error", { fg = c.red })
hi("ErrorMsg", { fg = c.red })
hi("WarningMsg", { fg = c.orange })

-- URLs
hi("Underlined", { fg = c.string, underline = true })

-- Markup
hi("Title", { fg = c.orange, bold = true })
hi("Bold", { bold = true })
hi("Italic", { italic = true })

-- ===========================================================================
-- TREESITTER HIGHLIGHT GROUPS  (@xxx)
-- ===========================================================================

-- ── Strings ────────────────────────────────────────────────────────────────

hi("@string", { fg = c.string })
hi("@string.escape", { fg = c.gray }) -- constant.character.escape → #A0A0A0
hi("@string.special", { fg = c.gray })
hi("@string.regex", { fg = c.gray }) -- string.regexp → #A0A0A0
hi("@character", { fg = c.string })

-- ── Numbers ────────────────────────────────────────────────────────────────

hi("@number", { fg = c.orange }) -- constant.numeric → #FFC799
hi("@number.float", { fg = c.orange })
hi("@float", { fg = c.orange }) -- older treesitter alias

-- ── Booleans and Constants ─────────────────────────────────────────────────
-- Globally orange per original theme.
-- Python-specific overrides to #7cabde are in the language section below.

hi("@boolean", { fg = c.orange }) -- constant.language.boolean → #FFC799 in original
hi("@constant", { fg = c.orange }) -- constant.numeric / support.constant → #FFC799
hi("@constant.builtin", { fg = c.orange }) -- null/nil/undefined → orange globally
hi("@constant.macro", { fg = c.orange })

-- ── Comments ───────────────────────────────────────────────────────────────

hi("@comment", { fg = c.comment, italic = true })
hi("@comment.documentation", { fg = c.comment, italic = true })

-- ── Keywords ───────────────────────────────────────────────────────────────
-- All keyword.* scopes → user: #7cabde

hi("@keyword", { fg = c.keyword })
hi("@keyword.function", { fg = c.keyword }) -- def / fn / function
hi("@keyword.return", { fg = c.keyword })
hi("@keyword.import", { fg = c.keyword }) -- import / from
hi("@keyword.conditional", { fg = c.keyword }) -- if / else / elif
hi("@keyword.repeat", { fg = c.keyword }) -- for / while
hi("@keyword.exception", { fg = c.keyword }) -- try / except / raise
hi("@keyword.modifier", { fg = c.keyword }) -- async / static / const
hi("@keyword.coroutine", { fg = c.keyword })
-- keyword.operator.* (and / or / not / in / is / instanceof / typeof)
-- These ARE under the keyword.* TextMate scope → user: #7cabde
hi("@keyword.operator", { fg = c.keyword })

-- ── Operators (symbolic: +, -, =, ==, etc.) ───────────────────────────────
-- Vesper has no explicit color for symbolic operators → they are default white.
-- (Distinct from @keyword.operator which covers word-based operators.)

hi("@operator", { fg = c.fg })

-- ── Punctuation ────────────────────────────────────────────────────────────
-- Brackets use flat #A0A0A0 here; see RainbowDelimiter* below for alternating.

hi("@punctuation.delimiter", { fg = c.gray })
hi("@punctuation.bracket", { fg = c.gray })
hi("@punctuation.special", { fg = c.gray })

-- ── Functions ──────────────────────────────────────────────────────────────
-- entity.name.function, variable.function, support.function → #FFC799

hi("@function", { fg = c.orange })
hi("@function.builtin", { fg = c.orange })
hi("@function.call", { fg = c.orange })
hi("@function.method", { fg = c.orange })
hi("@function.method.call", { fg = c.orange })
hi("@constructor", { fg = c.orange })
hi("@method", { fg = c.orange }) -- older treesitter alias
hi("@method.call", { fg = c.orange })

-- ── Types / Classes ────────────────────────────────────────────────────────
-- entity.name, support.type, support.class → #FFC799

hi("@type", { fg = c.orange })
hi("@type.builtin", { fg = c.orange })
hi("@type.qualifier", { fg = c.keyword }) -- const/let/var qualifiers → keyword.*
hi("@type.definition", { fg = c.orange })
hi("@class", { fg = c.orange })
hi("@namespace", { fg = c.orange })
hi("@module", { fg = c.orange })

-- ── Variables ──────────────────────────────────────────────────────────────
-- "variable", "meta.block variable.other" → #FFF

hi("@variable", { fg = c.fg })
hi("@variable.builtin", { fg = c.gray }) -- this/super → variable.language → #A0A0A0
hi("@variable.parameter", { fg = c.fg })
hi("@variable.member", { fg = c.fg })
hi("@field", { fg = c.fg }) -- older treesitter alias
hi("@property", { fg = c.fg })

-- ── Tags (HTML/JSX/XML) ────────────────────────────────────────────────────
-- entity.name.tag → #FFC799
-- entity.other.attribute-name (generic) → #A0A0A0
-- text.html.basic entity.other.attribute-name → #FFC799

hi("@tag", { fg = c.orange })
hi("@tag.builtin", { fg = c.orange })
hi("@tag.attribute", { fg = c.gray }) -- generic HTML attribute → #A0A0A0
hi("@tag.delimiter", { fg = c.gray })

-- ── Markup / Markdown ──────────────────────────────────────────────────────

hi("@markup.heading", { fg = c.orange, bold = true })
hi("@markup.strong", { bold = true })
hi("@markup.italic", { italic = true })
hi("@markup.underline", { fg = c.orange, underline = true })
hi("@markup.strikethrough", { fg = c.red, strikethrough = true })
hi("@markup.raw", { fg = c.gray })
hi("@markup.link", { fg = c.string, underline = true })
hi("@markup.link.url", { fg = c.gray, underline = true })
hi("@markup.link.label", { fg = c.gray })
hi("@markup.list", { fg = c.keyword })

-- ── Misc ───────────────────────────────────────────────────────────────────

hi("@error", { fg = c.red })
hi("@none", {})
hi("@conceal", { fg = c.comment })

-- ===========================================================================
-- LANGUAGE-SPECIFIC TREESITTER OVERRIDES
-- ===========================================================================

-- ── Python ─────────────────────────────────────────────────────────────────
-- variable.language.special.self.python → user: #bfbfbf
hi("@variable.builtin.python", { fg = c.self_var })

-- constant.language.python (True, False, None) → user: #7cabde
-- This is the Python-specific override; all other languages stay orange.
hi("@boolean.python", { fg = c.keyword })
hi("@constant.builtin.python", { fg = c.keyword }) -- None → #7cabde

-- Decorators → entity.name.function family → #FFC799
hi("@attribute.python", { fg = c.orange })

-- ── JSON ───────────────────────────────────────────────────────────────────
-- All JSON key levels → #FFC799

hi("@property.json", { fg = c.orange })

-- ── CSS ────────────────────────────────────────────────────────────────────
-- source.css support.type.property-name → #FFF

hi("@property.css", { fg = c.fg })
hi("@type.css", { fg = c.orange })
hi("@string.css", { fg = c.string })
hi("@number.css", { fg = c.orange })

-- ── Diff ───────────────────────────────────────────────────────────────────

hi("@diff.plus", { fg = "#99FFE4" })
hi("@diff.minus", { fg = c.red })
hi("@diff.delta", { fg = c.gray })

-- ===========================================================================
-- LSP SEMANTIC TOKEN HIGHLIGHTS
-- ===========================================================================

-- Types and classes → #FFC799
hi("@lsp.type.class", { fg = c.orange })
hi("@lsp.type.enum", { fg = c.orange })
hi("@lsp.type.enumMember", { fg = c.orange })
hi("@lsp.type.interface", { fg = c.orange })
hi("@lsp.type.struct", { fg = c.orange })
hi("@lsp.type.type", { fg = c.orange })
hi("@lsp.type.typeParameter", { fg = c.orange })
hi("@lsp.type.namespace", { fg = c.orange })
hi("@lsp.type.module", { fg = c.orange })

-- Functions → #FFC799
hi("@lsp.type.function", { fg = c.orange })
hi("@lsp.type.method", { fg = c.orange })
hi("@lsp.type.decorator", { fg = c.orange })

-- Variables → white
hi("@lsp.type.variable", { fg = c.fg })
hi("@lsp.type.parameter", { fg = c.fg })
hi("@lsp.type.property", { fg = c.fg })

-- Keywords → #7cabde
hi("@lsp.type.keyword", { fg = c.keyword })

-- Strings → #6dd9ba
hi("@lsp.type.string", { fg = c.string })
hi("@lsp.type.comment", { fg = c.comment, italic = true })

-- Numbers → orange
hi("@lsp.type.number", { fg = c.orange })

-- Booleans → orange globally; Python language server overrides below
hi("@lsp.type.boolean", { fg = c.orange })

-- Operators: symbolic → white, keyword operators are covered by @lsp.type.keyword
hi("@lsp.type.operator", { fg = c.fg })

-- Python self / cls from LSP (pyright / pylsp)
hi("@lsp.type.selfParameter", { fg = c.self_var })
hi("@lsp.type.clsParameter", { fg = c.self_var })

-- Modifiers
hi("@lsp.mod.defaultLibrary", { fg = c.orange })
hi("@lsp.mod.builtin", { fg = c.orange })
-- Note: @lsp.mod.readonly is intentionally not set — readonly variables
-- are still regular variables and should inherit @lsp.type.variable (white).

-- ===========================================================================
-- BRACKET ALTERNATING COLORS (rainbow-delimiters.nvim)
-- Matches your VSCode settings:
--   foreground1, 3, 5 → #A0A0A0
--   foreground2, 4, 6 → #7a7a7a
-- These groups are only active if you have rainbow-delimiters.nvim installed.
-- Without it, brackets fall back to @punctuation.bracket (#A0A0A0) above.
-- ===========================================================================

hi("RainbowDelimiterRed", { fg = c.gray }) -- level 1 → #A0A0A0
hi("RainbowDelimiterYellow", { fg = c.gray_dim }) -- level 2 → #7a7a7a
hi("RainbowDelimiterBlue", { fg = c.gray }) -- level 3 → #A0A0A0
hi("RainbowDelimiterOrange", { fg = c.gray_dim }) -- level 4 → #7a7a7a
hi("RainbowDelimiterGreen", { fg = c.gray }) -- level 5 → #A0A0A0
hi("RainbowDelimiterViolet", { fg = c.gray_dim }) -- level 6 → #7a7a7a
hi("RainbowDelimiterCyan", { fg = c.gray }) -- level 7 fallback
