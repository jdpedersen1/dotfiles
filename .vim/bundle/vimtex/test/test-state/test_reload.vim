set nocompatible
let &rtp = '../..,' . &rtp
filetype plugin on

set hidden

nnoremap q :qall!<cr>

call vimtex#log#set_silent()

if empty($INMAKE) | finish | endif

silent edit test_reload.cls

call assert_equal(len(vimtex#state#list_all()), 1)
silent VimtexReload
call assert_equal(len(vimtex#state#list_all()), 1)

call vimtex#test#finished()
