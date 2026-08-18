" Focus-inspired colorscheme for Neovim
" Save this as: ~/.config/nvim/colors/focus.vim

if exists('g:colors_name')
  hi clear
endif

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'focus'

" Strongly recommended for Neovim.
if has('termguicolors')
  set termguicolors
endif

" Palette (alpha removed because Vim/Neovim highlight colors do not use it).
let s:bg0  = '#15212A'
let s:bg1  = '#10191F'
let s:bg2  = '#18262F'
let s:bg3  = '#1A2831'
let s:bg4  = '#21333F'

let s:fg   = '#aec5cb'
let s:fg2  = '#6ea1be'
let s:dim  = '#87919D'
let s:muted = '#4C4C4C'
let s:teal = '#26B2B2'
let s:teal_dark = '#228787'
let s:cyan_soft = '#99cac1'
let s:green = '#227722'
let s:green_soft = '#0c6545'
let s:teal_darker = '#1a8b91'
let s:purple = '#A391B8'
let s:yellow = '#F8AD34'
let s:yellow_dim = '#986032'
let s:orange = '#E0AD82'
let s:red = '#E67D74'
let s:red_dim = '#772222'
let s:magenta = '#D699B5'
let s:gold = '#D0C5A9'
let s:code_err = '#FF0000'
let s:white = '#FFFFFF'
let s:unknown = "1C4449"
let s:leaf = "#8eceab"
let s:indigo_dark = "#7e9bd6"
let s:indigo = "#90aae0"

function! s:hi(group, fg, bg, attr) abort
  let l:cmd = 'hi ' . a:group
  if a:fg !=# ''
    let l:cmd .= ' guifg=' . a:fg
  endif
  if a:bg !=# ''
    let l:cmd .= ' guibg=' . a:bg
  endif
  if a:attr !=# ''
    let l:cmd .= ' gui=' . a:attr
  endif
  execute l:cmd
endfunction

function! s:link(from, to) abort
  execute 'hi! link ' . a:from . ' ' . a:to
endfunction

" Core UI
call s:hi('Normal',          s:fg,  s:bg1, '')
call s:hi('NormalNC',        s:fg,  s:bg1, '')
call s:hi('EndOfBuffer',     s:bg1, s:bg1, '')
call s:hi('SignColumn',      s:fg,  s:bg1, '')
call s:hi('LineNr',          s:dim, s:bg1, '')
call s:hi('CursorLineNr',    s:teal, s:bg1, 'bold')
call s:hi('CursorLine',      '',    s:bg2, '')
call s:hi('ColorColumn',     '',    s:bg2, '')
call s:hi('CursorColumn',    '',    s:bg2, '')
call s:hi('Visual',      '', s:bg2, '')
call s:hi('VisualNOS',   '', s:bg2, '')

call s:hi('Whitespace',  s:dim, '', '')
call s:hi('IblIndent',   s:dim, '', '')
call s:hi('IblScope',    s:teal, s:bg0, 'bold')

call s:hi('Search',          s:bg0,  s:gold, 'bold')
call s:hi('IncSearch',       s:bg0,  s:yellow, 'bold')
call s:hi('CurSearch',       s:bg0,  s:yellow, 'bold')
call s:hi('MatchParen',      s:white, s:teal_dark, 'bold')
call s:hi('Pmenu',           s:fg,   s:bg2, '')
call s:hi('PmenuSel',        s:bg0,  s:teal, 'bold')
call s:hi('PmenuSbar',       '',     s:bg3, '')
call s:hi('PmenuThumb',      '',     s:teal_dark, '')
call s:hi('WildMenu',        s:bg0,  s:teal, 'bold')
call s:hi('StatusLine',      s:fg,   s:bg3, 'bold')
call s:hi('StatusLineNC',    s:dim,  s:bg1, '')
call s:hi('TabLine',         s:dim,  s:bg2, '')
call s:hi('TabLineSel',      s:fg,   s:bg3, 'bold')
call s:hi('TabLineFill',     s:bg1,  s:bg1, '')
call s:hi('VertSplit',       s:bg1,  s:bg1, '')
call s:hi('WinSeparator',    s:teal_dark, s:bg1, '')
call s:hi('Folded',          s:dim,  s:bg2, 'italic')
call s:hi('FoldColumn',      s:dim,  s:bg1, '')
call s:hi('NonText',         s:dim,  s:bg1, '')
call s:hi('SpecialKey',      s:dim,  s:bg1, '')
call s:hi('Title',           s:teal, '', 'bold')
call s:hi('Directory',       s:cyan_soft, '', 'bold')
call s:hi('ErrorMsg',        s:white, s:red_dim, 'bold')
call s:hi('WarningMsg',      s:yellow, '', 'bold')
call s:hi('ModeMsg',         s:teal, '', 'bold')
call s:hi('MoreMsg',         s:green, '', 'bold')
call s:hi('Question',        s:teal, '', 'bold')
call s:hi('MsgSeparator',    s:bg4, '', '')
call s:hi('QuickFixLine',    '', s:bg3, 'bold')
call s:hi('qfLineNr',        s:dim, '', '')
call s:hi('SpellBad',        s:red, '', 'undercurl')
call s:hi('SpellCap',        s:yellow, '', 'undercurl')
call s:hi('SpellLocal',      s:teal, '', 'undercurl')
call s:hi('SpellRare',       s:magenta, '', 'undercurl')

" Floating windows / borders
call s:hi('NormalFloat',     s:fg,  s:bg2, '')
call s:hi('FloatBorder',     s:teal_dark, s:bg2, '')
call s:hi('FloatTitle',      s:teal, s:bg2, 'bold')
call s:hi('WinBar',          s:fg,  s:bg2, 'bold')
call s:hi('WinBarNC',        s:dim, s:bg2, '')

" Diagnostics
call s:hi('DiagnosticError', s:red, '', 'bold')
call s:hi('DiagnosticWarn',  s:yellow, '', 'bold')
call s:hi('DiagnosticInfo',  s:teal, '', 'bold')
call s:hi('DiagnosticHint',  s:cyan_soft, '', 'bold')
call s:hi('DiagnosticOk',    s:green, '', 'bold')
call s:hi('DiagnosticVirtualTextError', s:red, s:bg2, '')
call s:hi('DiagnosticVirtualTextWarn',  s:yellow, s:bg2, '')
call s:hi('DiagnosticVirtualTextInfo',  s:teal, s:bg2, '')
call s:hi('DiagnosticVirtualTextHint',  s:cyan_soft, s:bg2, '')
call s:hi('DiagnosticUnderlineError', '', '', 'undercurl')
call s:hi('DiagnosticUnderlineWarn',  '', '', 'undercurl')
call s:hi('DiagnosticUnderlineInfo',  '', '', 'undercurl')
call s:hi('DiagnosticUnderlineHint',  '', '', 'undercurl')

" Syntax groups
call s:hi('Comment',          s:dim, '', 'italic')
call s:hi('Constant',         s:magenta, '', '')
call s:hi('String',           s:purple, '', '')
call s:hi('Character',        s:gold, '', '')
call s:hi('Number',           s:magenta, '', '')
call s:hi('Boolean',          s:magenta, '', 'bold')
call s:hi('Float',            s:magenta, '', '')
call s:hi('Identifier',       s:fg, '', '')
call s:hi('Parameter',        s:fg2, '', '')
call s:hi('BuiltinVar',       s:red, '', 'italic')
call s:hi('Property',         s:leaf,'', '')
call s:hi('Function',         s:indigo_dark, '', '')
call s:hi('Statement',        s:red, '', '')
call s:hi('Conditional',      s:red, '', 'bold')
call s:hi('Repeat',           s:red, '', 'bold')
call s:hi('Label',            s:red, '', '')
call s:hi('Operator',         s:orange, '', '')
call s:hi('Keyword',          s:red, '', 'bold')
call s:hi('Exception',        s:red, '', 'bold')
call s:hi('PreProc',          s:red, '', '')
call s:hi('Include',          s:red, '', '')
call s:hi('Define',           s:red, '', '')
call s:hi('Macro',            s:orange, '', '')
call s:hi('PreCondit',        s:red, '', '')
call s:hi('Type',             s:cyan_soft, '', '')
call s:hi('StorageClass',     s:red, '', '')
call s:hi('Structure',        s:cyan_soft, '', '')
call s:hi('Typedef',          s:cyan_soft, '', '')
call s:hi('Special',          s:orange, '', '')
call s:hi('SpecialChar',      s:orange, '', '')
call s:hi('Tag',              s:teal, '', '')
call s:hi('Delimiter',        s:indigo, '', '')
call s:hi('SpecialComment',   s:dim, '', 'italic')
call s:hi('Debug',            s:red, '', '')
call s:hi('Underlined',       s:teal, '', 'underline')
call s:hi('Error',            s:white, s:red_dim, 'bold')
call s:hi('Todo',             s:bg0, s:yellow, 'bold')

" Treesitter / modern highlight captures
call s:link('@comment', 'Comment')
call s:link('@comment.documentation', 'Comment')
call s:link('@string', 'String')
call s:link('@string.regex', 'SpecialChar')
call s:link('@string.escape', 'SpecialChar')
call s:link('@character', 'Character')
call s:link('@number', 'Number')
call s:link('@boolean', 'Boolean')
call s:link('@function', 'Function')
call s:link('@function.builtin', 'Special')
call s:link('@function.method', 'Function')
call s:link('@function.call', 'Function')
call s:link('@variable', 'Identifier')
call s:link('@variable.builtin', 'BuiltinVar')
call s:link('@variable.parameter', 'Parameter')
call s:link('@parameter', 'Parameter')
call s:link('@property', 'Property')
call s:link('@variable.member.python', 'Property')
call s:link('@field', 'Identifier')
call s:link('@type', 'Type')
call s:link('@type.builtin', 'Type')
call s:link('@constructor', 'Special')
call s:link('@constant', 'Constant')
call s:link('@constant.builtin', 'Constant')
call s:link('@keyword', 'Keyword')
call s:link('@keyword.function', 'Keyword')
call s:link('@keyword.operator', 'Operator')
call s:link('@keyword.return', 'Keyword')
call s:link('@operator', 'Operator')
call s:link('@punctuation', 'Delimiter')
call s:link('@punctuation.bracket', 'Delimiter')
call s:link('@punctuation.delimiter', 'Delimiter')
call s:link('@label', 'Label')
call s:link('@attribute', 'Special')
call s:link('@namespace', 'Identifier')
call s:link('@module', 'Identifier')
call s:link('@markup.heading', 'Title')
call s:link('@markup.strong', 'Bold')
call s:link('@markup.italic', 'Italic')
call s:link('@markup.link', 'Underlined')
call s:link('@markup.raw', 'String')
call s:link('@markup.list', 'Special')
call s:link('@text.todo', 'Todo')

" Markdown / prose
call s:hi('markdownH1', s:red, '', 'bold')
call s:hi('markdownH2', s:cyan_soft, '', 'bold')
call s:hi('markdownH3', s:orange, '', 'bold')
call s:hi('markdownH4', s:orange, '', 'bold')
call s:hi('markdownH5', s:orange, '', 'bold')
call s:hi('markdownH6', s:orange, '', 'bold')
call s:hi('markdownLinkText', s:teal, '', 'underline')
call s:hi('markdownUrl', s:cyan_soft, '', 'underline')
call s:hi('markdownCode', s:gold, s:bg2, '')
call s:hi('markdownCodeBlock', s:gold, s:bg2, '')

" LSP / semantic tokens
call s:link('LspReferenceText', 'Visual')
call s:link('LspReferenceRead', 'Visual')
call s:link('LspReferenceWrite', 'Visual')
call s:link('@lsp.type.comment', 'Comment')
call s:link('@lsp.type.string', 'String')
call s:link('@lsp.type.keyword', 'Keyword')
call s:link('@lsp.type.number', 'Number')
call s:link('@lsp.type.boolean', 'Boolean')
call s:link('@lsp.type.function', 'Function')
call s:link('@lsp.type.method', 'Function')
call s:link('@lsp.type.variable', 'Identifier')
call s:link('@lsp.type.parameter', 'Identifier')
call s:link('@lsp.type.class', 'Type')
call s:link('@lsp.type.interface', 'Type')
call s:link('@lsp.type.enum', 'Type')
call s:link('@lsp.type.enumMember', 'Constant')
call s:link('@lsp.type.property', 'Property')
call s:link('@lsp.type.namespace', 'Property')

" Git signs
call s:hi('GitSignsAdd',    s:green, '', '')
call s:hi('GitSignsChange', s:yellow, '', '')
call s:hi('GitSignsDelete', s:red, '', '')
call s:hi('DiffAdd',        s:green, s:bg2, '')
call s:hi('DiffChange',     s:yellow, s:bg2, '')
call s:hi('DiffDelete',     s:red, s:bg2, '')
call s:hi('DiffText',       s:bg0, s:teal, 'bold')

" Telescope
call s:hi('TelescopeNormal',         s:fg, s:bg2, '')
call s:hi('TelescopeBorder',         s:teal_dark, s:bg2, '')
call s:hi('TelescopePromptNormal',   s:fg, s:bg3, '')
call s:hi('TelescopePromptBorder',   s:teal_dark, s:bg3, '')
call s:hi('TelescopePromptPrefix',    s:teal, s:bg3, 'bold')
call s:hi('TelescopeSelection',       s:fg, s:bg3, 'bold')
call s:hi('TelescopeSelectionCaret',  s:teal, s:bg3, 'bold')
call s:hi('TelescopeMatching',        s:yellow, '', 'bold')
call s:hi('TelescopePreviewTitle',    s:green, s:bg2, 'bold')
call s:hi('TelescopePromptTitle',     s:teal, s:bg3, 'bold')
call s:hi('TelescopeResultsTitle',    s:orange, s:bg2, 'bold')

" nvim-cmp
call s:hi('CmpItemAbbr',         s:fg, '', '')
call s:hi('CmpItemAbbrDeprecated', s:dim, '', 'strikethrough')
call s:hi('CmpItemAbbrMatch',    s:yellow, '', 'bold')
call s:hi('CmpItemAbbrMatchFuzzy', s:yellow, '', 'bold')
call s:hi('CmpItemKind',         s:cyan_soft, '', '')
call s:hi('CmpItemMenu',         s:dim, '', '')

" WhichKey / Noice / Notify / mini
call s:hi('WhichKey',      s:teal, '', 'bold')
call s:hi('WhichKeyGroup',  s:orange, '', '')
call s:hi('WhichKeyDesc',   s:fg, '', '')
call s:hi('NoiceCmdlinePopup', s:fg, s:bg2, '')
call s:hi('NoiceCmdlinePopupBorder', s:teal_dark, s:bg2, '')
call s:hi('NotifyERRORBorder', s:red, s:bg2, '')
call s:hi('NotifyWARNBorder', s:yellow, s:bg2, '')
call s:hi('NotifyINFOBorder', s:teal, s:bg2, '')
call s:hi('NotifyDEBUGBorder', s:dim, s:bg2, '')
call s:hi('NotifyTRACEBorder', s:cyan_soft, s:bg2, '')

" nvim-tree / neo-tree / file explorer
call s:hi('Directory', s:cyan_soft, '', 'bold')
call s:hi('NeoTreeNormal', s:fg, s:bg1, '')
call s:hi('NeoTreeNormalNC', s:fg, s:bg1, '')
call s:hi('NeoTreeFloatBorder', s:teal_dark, s:bg2, '')
call s:hi('NeoTreeFloatTitle', s:teal, s:bg2, 'bold')
call s:hi('NeoTreeIndentMarker', s:dim, '', '')
call s:hi('NeoTreeExpander', s:teal, '', 'bold')
call s:hi('NeoTreeGitAdded', s:green, '', '')
call s:hi('NeoTreeGitModified', s:yellow, '', '')
call s:hi('NeoTreeGitDeleted', s:red, '', '')
call s:hi('NvimTreeNormal', s:fg, s:bg1, '')
call s:hi('NvimTreeNormalNC', s:fg, s:bg1, '')
call s:hi('NvimTreeWinSeparator', s:teal_dark, s:bg1, '')
call s:hi('NvimTreeGitDirty', s:yellow, '', '')
call s:hi('NvimTreeGitNew', s:green, '', '')
call s:hi('NvimTreeGitDeleted', s:red, '', '')

" Bufferline / tabline / lualine fallback groups
call s:hi('BufferLineFill', s:bg1, s:bg1, '')
call s:hi('BufferLineBackground', s:dim, s:bg2, '')
call s:hi('BufferLineBufferSelected', s:fg, s:bg3, 'bold')
call s:hi('BufferLineBufferVisible', s:fg, s:bg2, '')
call s:hi('BufferLineIndicatorSelected', s:teal, s:bg3, '')
call s:hi('BufferLineSeparator', s:bg1, s:bg1, '')
call s:hi('LualineNormal', s:fg, s:bg3, '')
call s:hi('LualineInsert', s:bg0, s:teal, 'bold')
call s:hi('LualineVisual', s:bg0, s:yellow, 'bold')
call s:hi('LualineReplace', s:bg0, s:red, 'bold')
call s:hi('LualineCommand', s:bg0, s:orange, 'bold')

" Terminal colors (helpful for :terminal and many plugins)
let g:terminal_color_0  = s:bg1
let g:terminal_color_1  = s:red_dim
let g:terminal_color_2  = s:green
let g:terminal_color_3  = s:yellow_dim
let g:terminal_color_4  = s:teal_dark
let g:terminal_color_5  = s:magenta
let g:terminal_color_6  = s:teal
let g:terminal_color_7  = s:fg
let g:terminal_color_8  = s:dim
let g:terminal_color_9  = s:red
let g:terminal_color_10 = s:green_soft
let g:terminal_color_11 = s:yellow
let g:terminal_color_12 = s:cyan_soft
let g:terminal_color_13 = s:magenta
let g:terminal_color_14 = s:teal
let g:terminal_color_15 = s:white

" Generic fallback links for anything not explicitly themed above.
call s:link('Boolean', 'Constant')
call s:link('Character', 'String')
call s:link('Conceal', 'Normal')
call s:link('SpecialKey', 'NonText')

