-- Chalkboard-inspired Neovim colorscheme
-- Save as: ~/.config/nvim/colors/chalkboard.lua
-- Activate with: :colorscheme chalkboard

vim.o.termguicolors = true
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "chalkboard"

local set = vim.api.nvim_set_hl

local c = {
  bg = "#29262f",
  fg = "#d9e6f2",
  cursor = "#d9e6f2",
  cursor_text = "#29262f",
  selection_bg = "#073642",
  selection_fg = "#ffffff",

  black = "#000000",
  red = "#c37372",
  green = "#72c373",
  yellow = "#c2c372",
  blue = "#7372c3",
  magenta = "#c372c2",
  cyan = "#72c2c3",
  white = "#d9d9d9",

  bright_black = "#585858",
  bright_red = "#dbaaaa",
  bright_green = "#aadbaa",
  bright_yellow = "#dadbaa",
  bright_blue = "#aaaadb",
  bright_magenta = "#dbaada",
  bright_cyan = "#aadadb",
  bright_white = "#ffffff",
}

-- Core UI
set(0, "Normal", { fg = c.fg, bg = c.bg })
set(0, "NormalNC", { fg = c.fg, bg = c.bg })
set(0, "EndOfBuffer", { fg = c.bg, bg = c.bg })
set(0, "SignColumn", { fg = c.fg, bg = c.bg })
set(0, "FoldColumn", { fg = c.bright_black, bg = c.bg })
set(0, "LineNr", { fg = c.bright_black, bg = c.bg })
set(0, "CursorLineNr", { fg = c.yellow, bg = c.bg, bold = true })
set(0, "CursorLine", { bg = "#2f2b38" })
set(0, "ColorColumn", { bg = "#332f3d" })
set(0, "Visual", { fg = c.selection_fg, bg = c.selection_bg })
set(0, "Search", { fg = c.bg, bg = c.yellow, bold = true })
set(0, "IncSearch", { fg = c.bg, bg = c.bright_yellow, bold = true })
set(0, "MatchParen", { fg = c.cyan, bold = true })
set(0, "Pmenu", { fg = c.fg, bg = "#342f3f" })
set(0, "PmenuSel", { fg = c.bg, bg = c.bright_blue, bold = true })
set(0, "PmenuSbar", { bg = "#342f3f" })
set(0, "PmenuThumb", { bg = c.bright_black })
set(0, "StatusLine", { fg = c.fg, bg = "#342f3f" })
set(0, "StatusLineNC", { fg = c.bright_black, bg = "#2a2731" })
set(0, "VertSplit", { fg = "#3a3544", bg = c.bg })
set(0, "WinSeparator", { fg = "#3a3544", bg = c.bg })
set(0, "TabLine", { fg = c.bright_black, bg = "#2a2731" })
set(0, "TabLineSel", { fg = c.fg, bg = "#342f3f", bold = true })
set(0, "TabLineFill", { fg = c.bright_black, bg = "#2a2731" })
set(0, "Title", { fg = c.cyan, bold = true })
set(0, "Directory", { fg = c.blue, bold = true })
set(0, "Cursor", { fg = c.cursor_text, bg = c.cursor })
set(0, "lCursor", { fg = c.cursor_text, bg = c.cursor })
set(0, "TermCursor", { fg = c.cursor_text, bg = c.cursor })
set(0, "TermCursorNC", { fg = c.cursor_text, bg = c.cursor })

-- Messages
set(0, "ErrorMsg", { fg = c.red, bold = true })
set(0, "WarningMsg", { fg = c.yellow, bold = true })
set(0, "MoreMsg", { fg = c.green, bold = true })
set(0, "Question", { fg = c.cyan, bold = true })

-- Syntax
set(0, "Comment", { fg = c.bright_black, italic = true })
set(0, "Constant", { fg = c.yellow })
set(0, "String", { fg = c.green })
set(0, "Character", { fg = c.green })
set(0, "Number", { fg = c.bright_yellow })
set(0, "Boolean", { fg = c.bright_yellow, bold = true })
set(0, "Float", { fg = c.bright_yellow })
set(0, "Identifier", { fg = c.fg })
set(0, "Function", { fg = c.blue })
set(0, "Statement", { fg = c.magenta })
set(0, "Conditional", { fg = c.magenta, bold = true })
set(0, "Repeat", { fg = c.magenta, bold = true })
set(0, "Label", { fg = c.magenta })
set(0, "Operator", { fg = c.cyan })
set(0, "Keyword", { fg = c.magenta, bold = true })
set(0, "Exception", { fg = c.red, bold = true })
set(0, "PreProc", { fg = c.cyan })
set(0, "Include", { fg = c.cyan })
set(0, "Define", { fg = c.cyan })
set(0, "Macro", { fg = c.cyan })
set(0, "PreCondit", { fg = c.cyan })
set(0, "Type", { fg = c.blue, bold = true })
set(0, "StorageClass", { fg = c.blue })
set(0, "Structure", { fg = c.blue })
set(0, "Typedef", { fg = c.blue })
set(0, "Special", { fg = c.red })
set(0, "SpecialChar", { fg = c.red })
set(0, "Tag", { fg = c.cyan })
set(0, "Delimiter", { fg = c.fg })
set(0, "SpecialComment", { fg = c.bright_black, italic = true })
set(0, "Debug", { fg = c.red })

-- Diagnostics / LSP
set(0, "DiagnosticError", { fg = c.red })
set(0, "DiagnosticWarn", { fg = c.yellow })
set(0, "DiagnosticInfo", { fg = c.cyan })
set(0, "DiagnosticHint", { fg = c.blue })
set(0, "DiagnosticOk", { fg = c.green })
set(0, "DiagnosticUnderlineError", { undercurl = true, sp = c.red })
set(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
set(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = c.cyan })
set(0, "DiagnosticUnderlineHint", { undercurl = true, sp = c.blue })

set(0, "Error", { fg = c.red, bold = true })
set(0, "Todo", { fg = c.bg, bg = c.yellow, bold = true })

-- Diff
set(0, "DiffAdd", { fg = c.green, bg = "#233128" })
set(0, "DiffChange", { fg = c.yellow, bg = "#322f23" })
set(0, "DiffDelete", { fg = c.red, bg = "#352628" })
set(0, "DiffText", { fg = c.blue, bg = "#2d2d43", bold = true })

-- Folds and misc
set(0, "Folded", { fg = c.bright_black, bg = "#322d3a" })
set(0, "Whitespace", { fg = "#403a4b" })
set(0, "NonText", { fg = "#403a4b" })
set(0, "Conceal", { fg = c.bright_black })
set(0, "SpecialKey", { fg = "#403a4b" })
set(0, "QuickFixLine", { bg = "#342f3f", bold = true })

-- Treesitter fallback links
local links = {
  ["@comment"] = "Comment",
  ["@string"] = "String",
  ["@character"] = "Character",
  ["@number"] = "Number",
  ["@boolean"] = "Boolean",
  ["@function"] = "Function",
  ["@function.call"] = "Function",
  ["@keyword"] = "Keyword",
  ["@conditional"] = "Conditional",
  ["@repeat"] = "Repeat",
  ["@operator"] = "Operator",
  ["@type"] = "Type",
  ["@variable"] = "Identifier",
  ["@constant"] = "Constant",
  ["@property"] = "Identifier",
  ["@punctuation"] = "Delimiter",
  ["@tag"] = "Tag",
  ["@attribute"] = "PreProc",
  ["@field"] = "Identifier",
  ["@constructor"] = "Function",
}

for group, target in pairs(links) do
  set(0, group, { link = target })
end
