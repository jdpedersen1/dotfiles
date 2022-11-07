function! health#vimtex#check() abort
  call vimtex#options#init()

  call health#report_start('VimTeX')

  call s:check_general()
  call s:check_plugin_clash()
  call s:check_view()
  call s:check_compiler()
endfunction

function! s:check_general() abort " {{{1
  if !has('nvim') || v:version < 800
    call health#report_warn('VimTeX works best with Vim 8 or neovim')
  else
    call health#report_ok('Vim version should have full support!')
  endif

  if !executable('bibtex')
    call health#report_warn('bibtex is not executable, so bibtex completions are disabled.')
  endif
endfunction

" }}}1

function! s:check_compiler() abort " {{{1
  if !g:vimtex_compiler_enabled | return | endif

  if !executable(g:vimtex_compiler_method)
    let l:ind = '        '
    call health#report_error(printf(
          \ '|g:vimtex_compiler_method| (`%s`) is not executable!',
          \ g:vimtex_compiler_method))
    return
  endif

  call health#report_ok('Compiler should work!')
endfunction

" }}}1

function! s:check_plugin_clash() abort " {{{1
  " Note: This duplicates the code in after/ftplugin/tex.vim
  let l:scriptnames = vimtex#util#command('scriptnames')

  let l:latexbox = !empty(filter(copy(l:scriptnames), "v:val =~# 'latex-box'"))
  if l:latexbox
    call health#report_warn('Conflicting plugin detected: LaTeX-Box')
    call health#report_info('VimTeX does not work as expected when LaTeX-Box is installed!')
    call health#report_info('Please disable or remove it to use VimTeX!')
  endif
endfunction

" }}}1

function! s:check_view() abort " {{{1
  call s:check_view_{g:vimtex_view_method}()

  if executable('xdotool') && !executable('pstree')
    call health#report_warn('pstree is not available',
          \ 'vimtex#view#inverse_search is better if pstree is available.')
  endif
endfunction

" }}}1
function! s:check_view_general() abort " {{{1
  if executable(g:vimtex_view_general_viewer)
    call health#report_ok('General viewer should work properly!')
  else
    call health#report_error(
          \ 'Selected viewer is not executable!',
          \ '- Selection: ' . g:vimtex_view_general_viewer,
          \ '- Please see :h g:vimtex_view_general_viewer')
  endif
endfunction

" }}}1
function! s:check_view_zathura() abort " {{{1
  let l:ok = 1

  if !executable('zathura')
    call health#report_error('Zathura is not executable!')
    let l:ok = 0
  endif

  if !executable('xdotool')
    call health#report_warn('Zathura requires xdotool for forward search!')
    let l:ok = 0
  endif

  if l:ok
    call health#report_ok('Zathura should work properly!')
  endif
endfunction

" }}}1
function! s:check_view_mupdf() abort " {{{1
  let l:ok = 1

  if !executable('mupdf')
    call health#report_error('MuPDF is not executable!')
    let l:ok = 0
  endif

  if !executable('xdotool')
    call health#report_warn('MuPDF requires xdotool for forward search!')
    let l:ok = 0
  endif

  if !executable('synctex')
    call health#report_warn('MuPDF requires synctex for forward search!')
    let l:ok = 0
  endif

  if l:ok
    call health#report_ok('MuPDF should work properly!')
  endif
endfunction

" }}}1
function! s:check_view_skim() abort " {{{1
  call vimtex#jobs#run(join([
        \ 'osascript -e ',
        \ '''tell application "Finder" to POSIX path of ',
        \ '(get application file id (id of application "Skim") as alias)''',
        \]))

  if v:shell_error == 0
    call health#report_ok('Skim viewer should work!')
  else
    call health#report_error('Skim is not installed!')
  endif
endfunction

" }}}1
