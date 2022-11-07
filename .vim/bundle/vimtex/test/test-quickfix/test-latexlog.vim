set nocompatible
let &rtp = '../..,' . &rtp
filetype plugin on

silent edit ../example-quickfix/main.tex

try
  call vimtex#qf#setqflist()
catch /VimTeX: No log file found/
  echo 'VimTeX: No log file found'
  cquit
endtry

let s:qf = getqflist()

let s:n = 0
for s:expect in [
      \ {'lnum': 99,  'type': 'W', 'text': 'Package natbib Warning: Citation `Einstein:1905'' on page 1 undefined on input line 99.'},
      \ {'lnum': 12,  'type': 'W', 'text': 'Package refcheck Warning: Unused label `eq:my_equation_label'' on input line 12.'},
      \ {'lnum': 9,   'type': 'W', 'text': "Package hyperref Warning: Token not allowed in a PDF string (PDFDocEncoding):\n                removing `\\gamma'"},
      \ {'lnum': 5,   'type': 'W', 'text': "Package hyperref Warning: Composite letter `\\textdotbelow+u'\n                not defined in PD1 encoding,\n                removing `\\textdotbelow'"},
      \ {'lnum': 477, 'type': 'W', 'text': 'LaTeX Warning: Reference `fig:my_picture'' on page 37 undefined on input line 477.'},
      \ {'lnum': 9,   'type': 'W', 'text': 'Overfull \hbox (22.0021pt too wide) in paragraph at lines 9--9'},
      \ {'lnum': 0,   'type': 'W', 'text': 'Package biblatex warning: No "backend" specified, using Biber backend. To use BibTex, load biblatex with the "backend=bibtex" option.'},
      \ {'lnum': 0,   'type': 'W', 'text': "Package biblatex Warning: Data encoding is 'utf8'.\n                Use backend=biber."},
      \ {'lnum': 0,   'type': 'W', 'text': "Package babel Warning: No hyphenation patterns were loaded for\n                the language `Latin'\n                I will use the patterns loaded for \\language=0 instead."},
      \ {'lnum': 18,  'type': 'W', 'text': "Package onlyamsmath Warning: Environment eqnarray or eqnarray* used, please use\nonly the environments provided by the amsmath\npackage"},
      \ {'lnum': 21,  'type': 'W', 'text': "Package typearea Warning: \\typearea used at group level 2.\n               Using \\typearea inside any group, e.g.\n               environments, math mode, boxes, etc. may result in\n               many type setting problems.\n               You should move the command \\typearea\n               outside all groups"},
      \ {'lnum': 0,   'type': 'W', 'text': "Package caption Warning: Unsupported document class (or package) detected,\nusage of the caption package is not recommended."},
      \ {'lnum': 0,   'type': 'E', 'text': "Runaway argument?\n{\\sqrt {{1}} \\end {equation} \\par \\end {document} \nFile ended while scanning use of \\frac ."},
      \ {'lnum': 0,   'type': 'E', 'text': 'Runaway argument?'},
      \ {'lnum': 16,  'type': 'E', 'text': 'Paragraph ended before \date  was complete.'},
      \]
  call assert_equal(s:expect.lnum, s:qf[s:n].lnum, 'Failed at index ' . s:n)
  call assert_equal(s:expect.type, s:qf[s:n].type, 'Failed at index ' . s:n)
  call assert_equal(s:expect.text, s:qf[s:n].text, 'Failed at index ' . s:n)
  let s:n += 1
endfor

call assert_equal(s:n, len(s:qf))

call vimtex#test#finished()
