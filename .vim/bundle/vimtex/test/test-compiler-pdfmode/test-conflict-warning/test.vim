set nocompatible
let &rtp = '../../..,' . &rtp
filetype plugin on

nnoremap q :qall!<cr>

call vimtex#log#set_silent()

if empty($INMAKE)
  edit main.tex
  finish
else
  silent edit main.tex
endif

" Get engine
let s:engine = b:vimtex.compiler.get_engine()

let s:warnings = vimtex#log#get()
call assert_equal(len(s:warnings), 1)
call assert_match('pdf_mode.*inconsistent', join(s:warnings[0].msg))

call vimtex#test#finished()
