source common.vim

highlight Conceal ctermfg=4 ctermbg=7 guibg=NONE guifg=blue

let g:vimtex_syntax_custom_cmds = [
      \ {'name': 'footnote', 'argstyle': 'bold'},
      \ {'name': 'cmda', 'conceal': 1, 'optconceal': 0},
      \ {'name': 'cmdb', 'conceal': 1},
      \ {'name': 'mathcmda', 'mathmode': v:true, 'conceal': 1, 'argstyle': 'bold'},
      \ {'name': 'mathcmdb', 'mathmode': v:true, 'conceal': 1},
      \ {'name': 'R', 'mathmode': v:true, 'concealchar': 'ℝ'},
      \ {'name': 'E', 'mathmode': v:true, 'concealchar': '𝔼'},
      \ {'name': 'P', 'mathmode': v:true, 'concealchar': 'ℙ'},
      \ {'name': 'undline', 'argstyle': 'bolditalunder'},
      \ {'name': 'mathnote', 'mathmode': 1,
      \  'nextgroup': 'texMathTextArg', 'hlgroup': 'texMathCmdText'},
      \ {'name': 'mathnoteC', 'mathmode': 1, 'conceal': 1,
      \  'nextgroup': 'texMathTextConcArg', 'hlgroup': 'texMathCmdText'},
      \ {'name': 'mygls', 'argspell': 0},
      \ {'name': 'slurp', 'argspell': 0, 'arggreedy': v:true},
      \ {'name': 'regex', 'cmdre': '[iI]?[aA]c[slaf]?p?\*?', 'conceal': 1},
      \]

silent edit test-custom.tex
set spell

vsplit
silent wincmd w
set conceallevel=2
set spell

if empty($INMAKE) | finish | endif
quitall!
