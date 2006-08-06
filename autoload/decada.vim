"------------------------------------------------------------------------------
"  Description: Vim Ada/Dec Ada compiler file
"     Language: Ada (Dec Ada)
"          $Id: decada.vim 343 2006-07-28 17:54:11Z krischik $
"    Copyright: Copyright (C) 2006 Martin Krischik
"   Maintainer:	Martin Krischik
"      $Author: krischik $
"        $Date: 2006-07-28 19:54:11 +0200 (Fr, 28 Jul 2006) $
"      Version: 3.5
"    $Revision: 343 $
"     $HeadURL: https://svn.sourceforge.net/svnroot/gnuada/trunk/tools/vim/autoload/decada.vim $
"      History: 21.07.2006 MK New Dec Ada
"    Help Page: compiler-decada
"------------------------------------------------------------------------------

if exists("g:loaded_decada_autoload") || version < 700
    finish
else
   let g:loaded_decada_autoload = 34

   " Section: decada#Unit_Name () {{{1
   "
   function decada#Unit_Name () dict
       "	Convert filename into acs unit:
       "	    1:  remove the file extenstion.
       "	    2:  replace all double '_' or '-' with an dot (which denotes a separate)
       "	    3:  remove a trailing '_' (wich denotes a specification)
       return substitute (substitute (expand ("%:t:r"), '__\|-', ".", "g"), '_$', "", '')
   endfunction decada#Unit_Name

   " Section: decada#Make () {{{1
   "
   function decada#Make () dict
       let l:make_prg   = substitute (g:self.Make_Command, '%<', self.Unit_Name(), '')
       let &errorformat = g:self.Error_Format
       let &makeprg     = l:make_prg
       wall
       make
       copen
       set wrap
       wincmd W
   endfunction decada#Build

   " Section: decada#New () {{{1
   "
   function decada#New ()
       return {
           \ 'Make'	      : function ('decada#Make'),
           \ 'Unit_Name'      : function ('decada#Unit_Name'),
           \ 'Make_Command'   : 'ACS COMPILE /Wait /Log /NoPreLoad /Optimize=Development /Debug %<',
           \ 'Error_Format'   : '%+A%%ADAC-%t-%m,%C  %#%m,%Zat line number %l in file %f,' .
       		       \  '%+I%%ada-I-%m,%C  %#%m,%Zat line number %l in file %f'}
   endfunction gnat#New

   " }}}1

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
" vim: textwidth=78 wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab
" vim: filetype=vim encoding=latin1 fileformat=unix foldmethod=marker