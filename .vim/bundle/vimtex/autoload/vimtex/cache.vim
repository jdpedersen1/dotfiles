" VimTeX - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#cache#init_buffer() abort " {{{1
  command! -buffer -nargs=1 VimtexClearCache call vimtex#cache#clear(<q-args>)
endfunction

" }}}1

function! vimtex#cache#path(name) abort " {{{1
  let l:root = s:root()
  if !isdirectory(l:root)
    call mkdir(l:root, 'p')
  endif

  return vimtex#paths#join(l:root, a:name)
endfunction

" }}}1

function! vimtex#cache#open(name, ...) abort " {{{1
  let l:opts = a:0 > 0 ? a:1 : {}
  let l:name = get(l:opts, 'local') ? s:local_name(a:name) : a:name

  let s:caches = get(s:, 'caches', {})
  if has_key(s:caches, l:name)
    return s:caches[l:name]
  endif

  let s:caches[l:name] = s:cache.init(l:name, l:opts)
  return s:caches[l:name]
endfunction

" }}}1
function! vimtex#cache#close(name) abort " {{{1
  let s:caches = get(s:, 'caches', {})

  " Try global name first, then local name
  let l:name = a:name
  if !has_key(s:caches, l:name)
    let l:name = s:local_name(l:name)
  endif
  if !has_key(s:caches, l:name) | return | endif

  let l:cache = s:caches[l:name]
  call l:cache.write()
  unlet s:caches[l:name]
endfunction

" }}}1
function! vimtex#cache#wrap(Func, name, ...) abort " {{{1
  if !has('lambda')
    throw 'error: vimtex#cache#wrap requires +lambda'
  endif

  let l:opts = a:0 > 0 ? a:1 : {}
  let l:cache = vimtex#cache#open(a:name, l:opts)

  function! CachedFunc(key) closure
    if l:cache.has(a:key)
      return l:cache.get(a:key)
    else
      return l:cache.set(a:key, a:Func(a:key))
    endif
  endfunction

  return function('CachedFunc')
endfunction

" }}}1
function! vimtex#cache#clear(name) abort " {{{1
  if empty(a:name) | return | endif

  if a:name ==# 'ALL'
    let l:caches = globpath(s:root(), '*.json', 0, 1)
    for l:file in map(l:caches, {_, x -> fnamemodify(x, ':t:r')})
      let l:cache = vimtex#cache#open(l:file)
      call l:cache.clear()
    endfor
  else
    let l:persistent = get(g:, 'vimtex_cache_persistent', 1)
    let s:caches = get(s:, 'caches', {})

    " Clear global caches first (check if opened, then look for files)
    let l:cache = get(s:caches, a:name, {})
    if !empty(l:cache)
      call l:cache.clear()
    elseif l:persistent
      let l:cache = vimtex#cache#open(a:name)
      call l:cache.clear()
    endif

    " Clear local caches
    let l:cache = get(s:caches, s:local_name(a:name), {})
    if !empty(l:cache)
      call l:cache.clear()
    elseif l:persistent
      let l:cache = vimtex#cache#open(a:name, {'local': 1})
      call l:cache.clear()
    endif
  endif
endfunction

" }}}1
function! vimtex#cache#write_all() abort " {{{1
  for l:cache in values(get(s:, 'caches', {}))
    call l:cache.write()
  endfor
endfunction

" }}}1

let s:cache = {}

function! s:cache.init(name, opts) dict abort " {{{1
  let new = deepcopy(self)
  unlet new.init

  let new.name = a:name
  let new.path = vimtex#cache#path(a:name . '.json')
  let new.local = get(a:opts, 'local')
  let new.persistent = get(a:opts, 'persistent',
        \ get(g:, 'vimtex_cache_persistent', 1))

  if has_key(a:opts, 'default')
    let new.default = a:opts.default
  endif

  let new.data = {}
  let new.ftime = -1
  let new.modified = 0

  " Validate cache
  if new.persistent
    let l:validation = get(a:opts, 'validate', s:_version)
    if type(l:validation) == v:t_dict
      let l:validation._version = s:_version
    endif
    call new.read()
    if !has_key(new.data, '__validate')
          \ || type(new.data.__validate) != type(l:validation)
          \ || new.data.__validate != l:validation
      call new.clear()
      let new.data.__validate = deepcopy(l:validation)
      call new.write()
    endif
  endif

  return new
endfunction

" }}}1
function! s:cache.get(key) dict abort " {{{1
  call self.read()

  if has_key(self, 'default') && !has_key(self.data, a:key)
    let self.data[a:key] = deepcopy(self.default)
  endif

  return get(self.data, a:key)
endfunction

" }}}1
function! s:cache.has(key) dict abort " {{{1
  call self.read()

  return has_key(self.data, a:key)
endfunction

" }}}1
function! s:cache.set(key, value) dict abort " {{{1
  call self.read()

  let self.data[a:key] = a:value
  let self.modified = 1
  call self.write()

  return a:value
endfunction

" }}}1
function! s:cache.write() dict abort " {{{1
  if !self.persistent
    let self.modified = 0
    return
  endif

  call self.read()

  if !self.modified || empty(self.data) | return | endif

  call writefile([json_encode(self.data)], self.path)
  let self.ftime = getftime(self.path)
  let self.modified = 0
endfunction

" }}}1
function! s:cache.read() dict abort " {{{1
  if !self.persistent | return | endif
  if getftime(self.path) <= self.ftime | return | endif

  let self.ftime = getftime(self.path)
  let l:contents = join(readfile(self.path))
  if empty(l:contents) | return | endif

  let l:data = json_decode(l:contents)

  if type(l:data) != v:t_dict
    call vimtex#log#warning(
          \ 'Inconsistent cache data while reading: ' . self.name,
          \ 'Decoded data type: ' . type(l:data)
          \)
    return
  endif

  call extend(self.data, l:data, 'keep')
endfunction

" }}}1
function! s:cache.clear() dict abort " {{{1
  let self.data = {}
  let self.ftime = -1
  let self.modified = 0

  if self.persistent
    call delete(self.path)
  endif
endfunction

" }}}1

"
" Utility functions
"
function! s:root() abort " {{{1
  return get(g:, 'vimtex_cache_root',
        \ (empty($XDG_CACHE_HOME) ? $HOME . '/.cache' : $XDG_CACHE_HOME)
        \ . '/vimtex')
endfunction

" }}}1
function! s:local_name(name) abort " {{{1
  let l:filename = exists('b:vimtex.tex')
        \ ? fnamemodify(b:vimtex.tex, ':r')
        \ : expand('%:p:r')
  let l:filename = substitute(l:filename, '\s\+', '_', 'g')
  let l:filename = substitute(l:filename, '\/', '%', 'g')
  let l:filename = substitute(l:filename, '\\', '%', 'g')
  let l:filename = substitute(l:filename, ':', '%', 'g')
  return a:name . l:filename
endfunction

" }}}1


let s:_version = 'cache_v1'
