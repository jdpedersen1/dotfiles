" VimTeX - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#compiler#latexrun#init(options) abort " {{{1
  return s:compiler.new(a:options)
endfunction

" }}}1

let s:compiler = vimtex#compiler#_template#new({
      \ 'name' : 'latexrun',
      \ 'options' : [
      \   '--verbose-cmds',
      \   '--latex-args="-synctex=1"',
      \ ],
      \})

function! s:compiler.__check_requirements() abort dict " {{{1
  if !executable('latexrun')
    call vimtex#log#warning('latexrun is not executable!')
    throw 'VimTeX: Requirements not met'
  endif
endfunction

" }}}1
function! s:compiler.__build_cmd() abort dict " {{{1
  return 'latexrun ' . join(self.options)
        \ . ' --latex-cmd ' . self.get_engine()
        \ . ' -O '
        \ . (empty(self.build_dir) ? '.' : fnameescape(self.build_dir))
        \ . ' ' . vimtex#util#shellescape(self.state.base)
endfunction

" }}}1

function! s:compiler.clean(...) abort dict " {{{1
  let l:cmd = printf('latexrun --clean-all -O %s',
        \ empty(self.build_dir) ? '.' : fnameescape(self.build_dir))
  call vimtex#jobs#run(l:cmd, {'cwd': self.state.root})
endfunction

" }}}1
function! s:compiler.get_engine() abort dict " {{{1
  return get(g:vimtex_compiler_latexrun_engines,
        \ self.state.get_tex_program(),
        \ g:vimtex_compiler_latexrun_engines._)
endfunction

" }}}1
