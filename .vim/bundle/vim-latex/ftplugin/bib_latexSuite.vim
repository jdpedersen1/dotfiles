" File: bib_latexSuite.vim
" Author: Srinath Avadhanula
" License: Vim Charityware License
" Description:
" 	This file sources the bibtex.vim file distributed as part of latex-suite.
" 	That file sets up 3 maps BBB, BAS, and BBA which are easy wasy to type in
" 	bibliographic entries.
"

if exists('b:suppress_latex_suite') && b:suppress_latex_suite == 1
	finish
endif

" source main.vim because we need a few functions from it.
runtime ftplugin/latex-suite/main.vim
" Disable smart-quotes because we need to enter real quotes in bib files.
runtime ftplugin/latex-suite/bibtex.vim

" Infect the current buffer with <buffer>-local imaps for the IMAPs
call IMAP_infect()

" vim:fdm=marker:ff=unix:noet:ts=4:sw=4:nowrap
