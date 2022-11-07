set nocompatible
let &rtp = '../..,' . &rtp

function! TestBackend(bibfile, backend) abort
  let g:vimtex_parser_bib_backend = a:backend
  return vimtex#parser#bib(a:bibfile)
endfunction


let s:parsed = TestBackend('test.bib', 'bibtex')
call assert_equal(6, len(s:parsed))

let s:parsed = TestBackend('test.bib', 'vim')
call assert_equal(7, len(s:parsed))

call vimtex#log#set_silent()
let s:parsed = TestBackend('test.bib', 'badparser')
call assert_equal(0, len(s:parsed))

" let s:parsed = TestBackend('test.bib', 'bibparse')
" call assert_equal(7, len(s:parsed))

" let s:parsed = TestBackend('test.bib', 'bibtexparser')
" call assert_equal(5, len(s:parsed))

let s:bib = vimtex#kpsewhich#find('biblatex-examples.bib')
if !empty(s:bib) && filereadable(s:bib)
  let s:parsed = TestBackend(s:bib, 'bibtex')
  call assert_equal(92, len(s:parsed))

  let s:parsed = TestBackend(s:bib, 'vim')
  call assert_equal(92, len(s:parsed))

  " let s:parsed = TestBackend(s:bib, 'bibparse')
  " call assert_equal(92, len(s:parsed))

  " let s:parsed = TestBackend(s:bib, 'bibtexparser')
  " call assert_equal(92, len(s:parsed))
endif

call vimtex#test#finished()
