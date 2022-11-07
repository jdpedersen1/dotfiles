set nocompatible
let &rtp = '../..,' . &rtp
filetype plugin on

set nomore

nnoremap q :qall!<cr>

let g:vimtex_cache_root = '.'
let g:vimtex_cache_persistent = 0

silent edit test-custom-cls.tex

if empty($INMAKE) | finish | endif

" Test commands from custom classes
let s:candidates = vimtex#test#completion('\', 'custom')
call assert_true(len(s:candidates) > 0)
call assert_equal(s:candidates[0].word, 'customtest')

call vimtex#test#finished()
