" VimTeX - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#compiler#generic#init(options) abort " {{{1
  return s:compiler.new(a:options)
endfunction

" }}}1


let s:compiler = vimtex#compiler#_template#new({
      \ 'name' : 'generic',
      \ 'command' : '',
      \})

function! s:compiler.__check_requirements() abort dict " {{{1
  if empty(self.command)
    call vimtex#log#warning('Please specify the command to run!')
    throw 'VimTeX: Requirements not met'
  endif
endfunction

" }}}1
function! s:compiler.__build_cmd() abort dict " {{{1
  return self.command
endfunction

" }}}1
