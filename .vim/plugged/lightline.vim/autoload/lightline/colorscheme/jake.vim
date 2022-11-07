set background=dark
highlight clear
syntax reset

let g:colors_name="jake"

hi Boolean            ctermbg=NONE         ctermfg=1
hi Character          ctermbg=NONE         ctermfg=214
hi ColorColumn        ctermbg=235          ctermfg=250
hi Comment            ctermbg=NONE         ctermfg=241
hi Condtional         ctermbg=NONE         ctermfg=214
hi Constant           ctermbg=NONE         ctermfg=252
hi CursorColumn       ctermbg=236          ctermfg=NONE
hi Cursor             ctermbg=NONE         ctermfg=NONE
hi CursorLine         ctermbg=237          cterm=bold
hi Debug              ctermbg=255          ctermfg=NONE
hi Define             ctermbg=NONE         ctermfg=255
hi Delimiter          ctermbg=NONE         ctermfg=250
hi DiffAdd            ctermbg=NONE         ctermfg=255
hi DiffChange         ctermbg=NONE         ctermfg=700
hi DiffDelete         ctermbg=NONE         ctermfg=240
hi DiffText           ctermbg=NONE         ctermfg=250
hi Directory          ctermbg=NONE         ctermfg=255
hi Error              ctermbg=1            ctermfg=0
hi ErrorMsg           ctermbg=NONE         ctermfg=255
hi Exception          ctermbg=NONE         ctermfg=250
hi Float              ctermbg=NONE         ctermfg=214
hi FoldColumn         ctermbg=NONE         ctermfg=214
hi Folded             ctermbg=NONE         ctermfg=214
hi Function           ctermbg=NONE         ctermfg=214
hi Identifier         ctermbg=NONE         ctermfg=158
hi Include            ctermbg=NONE         ctermfg=255
hi IncSearch          ctermbg=255          ctermfg=0
hi Keyword            ctermbg=NONE         ctermfg=255
hi Label              ctermbg=NONE         ctermfg=255
hi LineNr             ctermbg=232          ctermfg=240
hi Macro              ctermbg=NONE         ctermfg=yellow
hi MatchParen         ctermbg=NONE         ctermfg=70
hi ModeMsg            ctermbg=NONE         ctermfg=250
hi MoreMsg            ctermbg=NONE         ctermfg=250
hi NonText            ctermbg=NONE         ctermfg=240
hi Normal             ctermbg=NONE         ctermfg=255
hi Number             ctermbg=NONE         ctermfg=255
hi Operator           ctermbg=NONE         ctermfg=214
hi Pmenu              ctermbg=NONE         ctermfg=255
hi PmenuSbar          ctermbg=NONE         ctermfg=70
hi PmenuSel           ctermbg=NONE         ctermfg=70
hi PmenuThumb         ctermbg=NONE         ctermfg=232
hi PreCondit          ctermbg=NONE         ctermfg=255
hi PreProc            ctermbg=NONE         ctermfg=214
hi Question           ctermbg=NONE         ctermfg=250
hi Repeat             ctermbg=NONE         ctermfg=255
hi Search             ctermbg=255          ctermfg=0
hi SpecialChar        ctermbg=NONE         ctermfg=255
hi SpecialComment     ctermbg=NONE         ctermfg=250
hi Special            ctermbg=NONE         ctermfg=255
hi SpecialKey         ctermfg=darkgreen   ctermbg=NONE
hi SpellBad           ctermbg=0            ctermfg=67
hi SpellCap           ctermbg=NONE         ctermfg=255
hi SpellLocal         ctermbg=NONE         ctermfg=255
hi SpellRare          ctermbg=NONE         ctermfg=124
hi Statement          ctermbg=NONE         ctermfg=230
hi StatusLine         ctermbg=white        ctermfg=black
hi StatusLineNC       ctermbg=238          ctermfg=black
hi StorageClass       ctermbg=NONE         ctermfg=255
hi String             ctermbg=NONE         ctermfg=96
hi Structure          ctermbg=NONE         ctermfg=255
hi TabLineFill        ctermbg=0            ctermfg=0
hi Tag                ctermbg=NONE         ctermfg=214
hi Title              ctermbg=NONE         ctermfg=250
hi Todo               ctermbg=NONE         ctermfg=255
hi Type               ctermbg=NONE         ctermfg=255
hi Typedef            ctermbg=NONE         ctermfg=255
hi VertSplit          ctermbg=black        ctermfg=black
hi Visual             ctermbg=NONE         ctermfg=2
hi VisualNOS          ctermbg=NONE         ctermfg=70
hi WarningMsg         ctermbg=NONE         ctermfg=214
hi WildMenu           ctermbg=NONE         ctermfg=240
hi def link diffCommon Statement
hi def link diffRemoved DifDelet
hi def link diffChanged DiffChang
hi def link diffAdded DiffAddf
