" VimTeX - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#syntax#p#mhequ#load(cfg) abort " {{{1
  call vimtex#syntax#core#new_region_math('equ')
  call vimtex#syntax#core#new_region_math('equs')
endfunction

" }}}1

