"------------------------------------------------------------------------------
"  Description: Perform Ada specific completion & tagging.
"     Language: Ada (2012)
"    Copyright: Copyright (C) 2006 … 2022 Martin Krischik
"   Maintainer: Martin Krischik <krischik@users.sourceforge.net>
"		Taylor Venable <taylor@metasyntax.net>
"		Neil Bird <neil@fnxweb.com>
"               Bartek Jasicki <thindil@laeran.pl>
"      Version: 5.0.0
"      History: 24.05.2006 MK Unified Headers
"		26.05.2006 MK ' should not be in iskeyword.
"		16.07.2006 MK Ada-Mode as vim-ball
"		02.10.2006 MK Better folding.
"		15.10.2006 MK Bram's suggestion for runtime integration
"               05.11.2006 MK Bram suggested not to use include protection for
"                             autoload
"		05.11.2006 MK Bram suggested to save on spaces
"		08.07.2007 TV fix default compiler problems.
"		28.08.2022 MK Merge Ada 2012 changes from thindil
"		01.09.2022 MK Use GitHub und dein to publish new versions
"    Help Page: ft-ada-plugin
"------------------------------------------------------------------------------
" Provides mapping overrides for tag jumping that figure out the current
" Ada object and tag jump to that, not the 'simple' vim word.
" Similarly allows <Ctrl-N> matching of full-length ada entities from tags.
"------------------------------------------------------------------------------

" Only do this when not done yet for this buffer
if exists ("b:did_ftplugin") || version < 700
   finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 45

"
" Temporarily set cpoptions to ensure the script loads OK
"
let s:cpoptions = &cpoptions
set cpoptions-=C

" Section: Comments  {{{1
"
setlocal comments=O:--,:--\ \
setlocal commentstring=--\ \ %s
setlocal complete=.,w,b,u,t,i

" Section: case	     {{{1
"
setlocal nosmartcase
setlocal ignorecase

" Section: formatoptions {{{1
"
setlocal formatoptions+=ron

" Section: Completion {{{1
"
setlocal completefunc=ada#User_Complete
setlocal omnifunc=adacomplete#Complete

if exists ("g:ada_extended_completion")
   if mapcheck ('<C-N>','i') == ''
      inoremap <unique> <buffer> <C-N> <C-R>=ada#Completion("\<lt>C-N>")<cr>
   endif
   if mapcheck ('<C-P>','i') == ''
      inoremap <unique> <buffer> <C-P> <C-R>=ada#Completion("\<lt>C-P>")<cr>
   endif
   if mapcheck ('<C-X><C-]>','i') == ''
      inoremap <unique> <buffer> <C-X><C-]> <C-R>=<SID>ada#Completion("\<lt>C-X>\<lt>C-]>")<cr>
   endif
   if mapcheck ('<bs>','i') == ''
      inoremap <silent> <unique> <buffer> <bs> <C-R>=ada#Insert_Backspace ()<cr>
   endif
endif

" Section: Matchit {{{1
"
" Only do this when not done yet for this buffer & matchit is used
"
if !exists ("b:match_words")  &&
  \ exists ("loaded_matchit")
   "
   " The following lines enable the macros/matchit.vim plugin for
   " Ada-specific extended matching with the % key.
   "
   let s:notend      = '\%(\<end\s\+\)\@<!'
   let b:match_words =
      \ s:notend . '\<if\>:\<elsif\>:\<else\>:\<end\>\s\+\<if\>,' .
      \ s:notend . '\<case\>:\<when\>:\<end\>\s\+\<case\>,' .
      \ '\%(\<while\>.*\|\<for\>.*\|'.s:notend.'\)\<loop\>:\<end\>\s\+\<loop\>,' .
      \ '\%(\<do\>\|\<begin\>\):\<exception\>:\<end\>\s*\%($\|[;A-Z]\),' .
      \ s:notend . '\<record\>:\<end\>\s\+\<record\>'
endif


" Section: Compiler {{{1
"
if ! exists("g:ada_default_compiler")
   let g:ada_default_compiler = 'alire'
endif

if ! exists("current_compiler")			||
   \ current_compiler != g:ada_default_compiler
   execute "compiler " . g:ada_default_compiler
endif

" Section: Folding {{{1
"
if exists("g:ada_folding")
   if g:ada_folding[0] == 'i'
      setlocal foldmethod=indent
      setlocal foldignore=--
      setlocal foldnestmax=5
   elseif g:ada_folding[0] == 'g'
      setlocal foldmethod=expr
      setlocal foldexpr=ada#Pretty_Print_Folding(v:lnum)
   elseif g:ada_folding[0] == 's'
      setlocal foldmethod=syntax
   endif
   setlocal tabstop=8
   setlocal softtabstop=3
   setlocal shiftwidth=3
endif

" Section: Abbrev {{{1
"
if exists("g:ada_abbrev")
   iabbrev ret	return
   iabbrev proc procedure
   iabbrev pack package
   iabbrev func function
endif

" Section: Commands, Mapping, Menus {{{1
"
execute "50amenu &Ada.-sep- :"

" Map_Menu parameter:
"  Text:	Menu text to display
"  Keys:	Key shortcut to define (used only when g:mapleader is used)
"  Command:  Command shortcut to define
"  Function: Function to call
"  Args:	Additional parameter.

call ada#Map_Menu (
   \ 'Toggle Space Errors',
   \ 'as',
   \ 'AdaSpaces',
   \ 'call ada#Switch_Syntax_Option',
   \ '''space_errors''')
call ada#Map_Menu (
   \'Toggle Lines Errors',
   \ 'al',
   \ 'AdaLines',
   \ 'call ada#Switch_Syntax_Option',
   \ '''line_errors''')
call ada#Map_Menu (
   \'Toggle Standard Types',
   \ 'at',
   \ 'AdaTypes',
   \ 'call ada#Switch_Syntax_Option',
   \ '''standard_types''')

" 1}}}
" Reset cpoptions
let &cpoptions = s:cpoptions
unlet s:cpoptions

finish " 1}}}

"------------------------------------------------------------------------------
"   Copyright (C) 2006 … 2020 Martin Krischik
"
"   Vim is Charityware - see ":help license" or uganda.txt for licence details.
"------------------------------------------------------------------------------
" vim: textwidth=78 nowrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab
" vim: foldmethod=marker
