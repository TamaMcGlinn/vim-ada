"------------------------------------------------------------------------------
"  Description: Vim Ada/GNAT compiler file
"     Language: Ada (GNAT)
"          $Id: gnat.vim 314 2006-07-18 17:11:31Z krischik $
"    Copyright: Copyright (C) 2006 Martin Krischik
"   Maintainer:	Martin Krischik
"      $Author: krischik $
"        $Date: 2006-07-18 19:11:31 +0200 (Di, 18 Jul 2006) $
"      Version: 3.2
"    $Revision: 314 $
"     $HeadURL: https://svn.sourceforge.net/svnroot/gnuada/trunk/tools/vim/compiler/gnat.vim $
"      History: 24.05.2006 MK Unified Headers
"		16.07.2006 MK Ada-Mode as vim-ball
"    Help Page: compiler-gnat
"------------------------------------------------------------------------------

if version < 700
    finish
else
    if !exists("g:gnat")
	let g:gnat = gnat#New ()
    endif

    let current_compiler = "gnat"
    execute "CompilerSet makeprg="     . escape (eval (g:gnat.Make_Command), ' ')
    execute "CompilerSet errorformat=" . escape (g:gnat.Error_Format, ' ')

    command! -buffer Build	:call g:gnat.Make ()
    command! -buffer BuildTags  :call s:gnat.Tags ()

    nnoremap <buffer> <F7>      :call g:gnat.Make ()<CR>
    inoremap <buffer> <F7> <C-O>:call g:gnat.Make ()<CR>

    finish
endif

"------------------------------------------------------------------------------
"   Copyright (C) 2006  Martin Krischik
"
"   This program is free software; you can redistribute it and/or
"   modify it under the terms of the GNU General Public License
"   as published by the Free Software Foundation; either version 2
"   of the License, or (at your option) any later version.
"
"   This program is distributed in the hope that it will be useful,
"   but WITHOUT ANY WARRANTY; without even the implied warranty of
"   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"   GNU General Public License for more details.
"
"   You should have received a copy of the GNU General Public License
"   along with this program; if not, write to the Free Software
"   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
"------------------------------------------------------------------------------
" vim: textwidth=78 wrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab
" vim: filetype=vim encoding=latin1 fileformat=unix
