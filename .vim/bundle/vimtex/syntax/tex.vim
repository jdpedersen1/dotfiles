" VimTeX - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"
"
" This script is a fork of version 119 (dated 2020-06-29) of the syntax script
" "tex.vim" created and maintained by Charles E. Campbell [0].
"
" [0]: http://www.drchip.org/astronaut/vim/index.html#SYNTAX_TEX

if !get(g:, 'vimtex_syntax_enabled', 1) | finish | endif
if exists('b:current_syntax') | finish | endif
if exists('s:is_loading') | finish | endif
let s:is_loading = 1

" Syntax may be loaded without the main VimTeX functionality, thus we need to
" ensure that the options are loaded!
call vimtex#options#init()

" Load core syntax and highlighting rules (does not depend on VimTeX state)
call vimtex#syntax#core#init()
call vimtex#syntax#core#init_highlights()

" Initialize buffer local syntax state
unlet! b:vimtex_syntax_did_postinit
let b:vimtex_syntax = {}
call vimtex#syntax#nested#reset()

" Load syntax rules that depend on VimTeX state
" * This includes e.g. package specific syntax
if exists('b:vimtex')
  call vimtex#syntax#core#init_post()
endif

" Use autocommands to ensure
" 1. that highlight groups are defined when colorschemes are changed or the
"    background is toggled, and
" 2. that the init_post function is executed when VimTeX state is loaded (if it
"    was not already done).
augroup vimtex_syntax
  autocmd! * <buffer>
  autocmd ColorScheme <buffer> call vimtex#syntax#core#init_highlights()
  autocmd! User VimtexEventInitPost call vimtex#syntax#core#init_post()
augroup END

unlet s:is_loading
