" VimTeX - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#compiler#latexmk#init(options) abort " {{{1
  return s:compiler.new(a:options)
endfunction

" }}}1

function! vimtex#compiler#latexmk#get_rc_opt(root, opt, type, default) abort " {{{1
  "
  " Parse option from .latexmkrc.
  "
  " Arguments:
  "   root         Root of LaTeX project
  "   opt          Name of options
  "   type         0 if string, 1 if integer, 2 if list
  "   default      Value to return if option not found in latexmkrc file
  "
  " Output:
  "   [value, location]
  "
  "   value        Option value (integer or string)
  "   location     An integer that indicates where option was found
  "                 -1: not found (default value returned)
  "                  0: global latexmkrc file
  "                  1: local latexmkrc file
  "

  if a:type == 0
    let l:pattern = '^\s*\$' . a:opt . '\s*=\s*[''"]\(.\+\)[''"]'
  elseif a:type == 1
    let l:pattern = '^\s*\$' . a:opt . '\s*=\s*\(\d\+\)'
  elseif a:type == 2
    let l:pattern = '^\s*@' . a:opt . '\s*=\s*(\(.*\))'
  else
    throw 'VimTeX: Argument error'
  endif

  " Candidate files
  " - each element is a pair [path_to_file, is_local_rc_file].
  let l:files = [
        \ [a:root . '/latexmkrc', 1],
        \ [a:root . '/.latexmkrc', 1],
        \ [fnamemodify('~/.latexmkrc', ':p'), 0],
        \ [fnamemodify(
        \    !empty($XDG_CONFIG_HOME) ? $XDG_CONFIG_HOME : '~/.config', ':p')
        \    . '/latexmk/latexmkrc', 0]
        \]

  let l:result = [a:default, -1]

  for [l:file, l:is_local] in l:files
    if filereadable(l:file)
      let l:match = matchlist(readfile(l:file), l:pattern)
      if len(l:match) > 1
        let l:result = [l:match[1], l:is_local]
        break
      end
    endif
  endfor

  " Parse the list
  if a:type == 2 && l:result[1] > -1
    let l:array = split(l:result[0], ',')
    let l:result[0] = []
    for l:x in l:array
      let l:x = substitute(l:x, "^'", '', '')
      let l:x = substitute(l:x, "'$", '', '')
      let l:result[0] += [l:x]
    endfor
  endif

  return l:result
endfunction

" }}}1


let s:compiler = vimtex#compiler#_template#new({
      \ 'name' : 'latexmk',
      \ 'callback' : 1,
      \ 'continuous': 1,
      \ 'executable' : 'latexmk',
      \ 'options' : [
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \})

function! s:compiler.__check_requirements() abort dict " {{{1
  if !executable(self.executable)
    call vimtex#log#warning(self.executable . ' is not executable')
    throw 'VimTeX: Requirements not met'
  endif
endfunction

" }}}1
function! s:compiler.__init() abort dict " {{{1
  " Check if .latexmkrc sets the build_dir - if so this should be respected
  let l:out_dir =
        \ vimtex#compiler#latexmk#get_rc_opt(self.state.root, 'out_dir', 0, '')[0]
  if !empty(l:out_dir)
    if !empty(self.build_dir) && (self.build_dir !=# l:out_dir)
      call vimtex#log#warning(
            \ 'Setting out_dir from latexmkrc overrides build_dir!',
            \ 'Changed build_dir from: ' . self.build_dir,
            \ 'Changed build_dir to: ' . l:out_dir)
    endif
    let self.build_dir = l:out_dir
  endif
endfunction

" }}}1
function! s:compiler.__build_cmd() abort dict " {{{1
  let l:cmd = (has('win32')
        \ ? 'set max_print_line=2000 & '
        \ : 'max_print_line=2000 ') . self.executable

  let l:cmd .= ' ' . join(self.options)
  let l:cmd .= ' ' . self.get_engine()

  if !empty(self.build_dir)
    let l:cmd .= ' -outdir=' . fnameescape(self.build_dir)
  endif

  if self.continuous
    let l:cmd .= ' -pvc -view=none'

    if self.callback
      for [l:opt, l:val] in [
            \ ['compiling_cmd', 'vimtex_compiler_callback_compiling'],
            \ ['success_cmd', 'vimtex_compiler_callback_success'],
            \ ['failure_cmd', 'vimtex_compiler_callback_failure'],
            \]
        let l:cmd .= s:wrap_option_appendcmd(l:opt, 'echo ' . l:val)
      endfor
    endif
  endif

  return l:cmd . ' ' . vimtex#util#shellescape(self.state.base)
endfunction

" }}}1
function! s:compiler.__pprint_append() abort dict " {{{1
  return [
        \ ['callback', self.callback],
        \ ['continuous', self.continuous],
        \ ['executable', self.executable],
        \]
endfunction

" }}}1

function! s:compiler.clean(full) abort dict " {{{1
  let l:cmd = self.executable . ' ' . (a:full ? '-C ' : '-c ')
  if !empty(self.build_dir)
    let l:cmd .= printf(' -outdir=%s ', fnameescape(self.build_dir))
  endif
  let l:cmd .= vimtex#util#shellescape(self.state.base)

  call vimtex#jobs#run(l:cmd, {'cwd': self.state.root})
endfunction

" }}}1
function! s:compiler.get_engine() abort dict " {{{1
  " Parse tex_program from TeX directive
  let l:tex_program_directive = self.state.get_tex_program()
  let l:tex_program = l:tex_program_directive


  " Parse tex_program from from pdf_mode option in .latexmkrc
  let [l:pdf_mode, l:is_local] =
        \ vimtex#compiler#latexmk#get_rc_opt(self.state.root, 'pdf_mode', 1, -1)

  if l:pdf_mode >= 1 && l:pdf_mode <= 5
    let l:tex_program_pdfmode = [
          \ 'pdflatex',
          \ 'pdfps',
          \ 'pdfdvi',
          \ 'lualatex',
          \ 'xelatex',
          \][l:pdf_mode-1]

    " Use pdf_mode if there is no TeX directive
    if l:tex_program_directive ==# '_'
      let l:tex_program = l:tex_program_pdfmode
    elseif l:is_local && l:tex_program_directive !=# l:tex_program_pdfmode
      " Give warning when there may be a confusing conflict
      call vimtex#log#warning(
            \ 'Value of pdf_mode from latexmkrc is inconsistent with ' .
            \ 'TeX program directive!',
            \ 'TeX program: ' . l:tex_program_directive,
            \ 'pdf_mode:    ' . l:tex_program_pdfmode,
            \ 'The value of pdf_mode will be ignored.')
    endif
  endif

  return get(g:vimtex_compiler_latexmk_engines,
        \ l:tex_program,
        \ g:vimtex_compiler_latexmk_engines._)
endfunction

" }}}1


function! s:wrap_option_appendcmd(name, value) abort " {{{1
  " Note: On Linux, we use double quoted perl strings; these interpolate
  "       variables. One should therefore NOT pass values that contain `$`.
  let l:win_cmd_sep = has('nvim') ? '^&' : '&'
  let l:common = printf('$%s = ($%s ? $%s', a:name, a:name, a:name)
  return has('win32')
        \ ? printf(' -e "%s . '' %s '' : '''') . ''%s''"',
        \          l:common, l:win_cmd_sep, a:value)
        \ : printf(' -e ''%s . " ; " : "") . "%s"''',
        \          l:common, a:value)
endfunction

"}}}1
