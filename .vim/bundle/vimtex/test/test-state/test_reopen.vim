set nocompatible
let &rtp = '../..,' . &rtp
filetype plugin on

nnoremap q :qall!<cr>

call vimtex#log#set_silent()

if empty($INMAKE) | finish | endif

silent edit minimal.tex
call assert_equal(len(vimtex#state#list_all()), 1)

bwipeout
call assert_equal(len(vimtex#state#list_all()), 0)

silent edit minimal.tex
call assert_equal(len(vimtex#state#list_all()), 1)

bdelete
call assert_equal(len(vimtex#state#list_all()), 1)

silent edit minimal.tex
call assert_equal(len(vimtex#state#list_all()), 1)

call vimtex#test#finished()
