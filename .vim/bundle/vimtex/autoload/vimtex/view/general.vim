" VimTeX - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#view#general#new() abort " {{{1
  return s:viewer.init()
endfunction

" }}}1


let s:viewer = vimtex#view#_template#new({
      \ 'name' : 'General'
      \})

function! s:viewer._check() abort " {{{1
  " Check if the viewer is executable
  " * split to ensure that we handle stuff like "gio open"
  let l:exe = get(split(g:vimtex_view_general_viewer), 0, '')
  if empty(l:exe)
        \ || (!executable(l:exe)
        \     && !(vimtex#util#get_os() ==# 'win'
        \          && g:vimtex_view_general_viewer ==# 'start ""'))
    call vimtex#log#warning(
          \ 'Generic viewer is not executable!',
          \ '- Viewer: ' . g:vimtex_view_general_viewer,
          \ '- Executable: ' . l:exe,
          \ '- Please see :h g:vimtex_view_general_viewer')
    return v:false
  endif

  return v:true
endfunction

" }}}1
function! s:viewer._start(file) dict abort " {{{1
  " Update file path for Windows+cygwin
  let l:file = executable('cygpath')
        \ ? join(vimtex#jobs#capture('cygpath -aw "' . a:file . '"'), '')
        \ : a:file

  " Parse options
  let l:cmd = g:vimtex_view_general_viewer
  let l:cmd .= ' ' . g:vimtex_view_general_options

  " Substitute magic patterns
  let l:cmd = substitute(l:cmd, '@line', line('.'), 'g')
  let l:cmd = substitute(l:cmd, '@col', col('.'), 'g')
  let l:cmd = substitute(l:cmd, '@tex',
        \ vimtex#util#shellescape(expand('%:p')), 'g')
  let l:cmd = substitute(l:cmd, '@pdf', vimtex#util#shellescape(l:file), 'g')

  " Start the view process
  " NB: Use vimtex#jobs#start to ensure it runs in the background
  let self.job = vimtex#jobs#start(l:cmd)
endfunction

" }}}1
