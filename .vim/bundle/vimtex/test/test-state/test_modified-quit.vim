set nocompatible
let &rtp = '../..,' . &rtp
filetype plugin on

set noswapfile
set nomore

nnoremap q :qall!<cr>

if empty($INMAKE) | finish | endif

let g:test = 0
augroup Testing
  autocmd!
  autocmd User VimtexEventQuit let g:test += 1
augroup END

silent edit included.tex

" 'hidden' is not set, so quitting should not wipe any states
normal! GOtest
try
  silent quit
catch /E37/
endtry
call assert_equal(g:test, 0)

call vimtex#test#finished()
