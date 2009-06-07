" TODO: summary
"
" DESCRIPTION:
" USAGE:
" INSTALLATION:
" DEPENDENCIES:
"   - CompleteHelper.vim autoload script. 
"
" CONFIGURATION:
" INTEGRATION:
" LIMITATIONS:
" ASSUMPTIONS:
" KNOWN PROBLEMS:
" TODO:
"
" Copyright: (C) 2008 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	08-Jun-2009	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_CamelCaseComplete') || (v:version < 700)
    finish
endif
let g:loaded_CamelCaseComplete = 1

let s:save_cpo = &cpo
set cpo&vim

if ! exists('g:CamelCaseComplete_complete')
    let g:CamelCaseComplete_complete = '.,w'
endif

function! s:GetCompleteOption()
    return (exists('b:CamelCaseComplete_complete') ? b:CamelCaseComplete_complete : g:CamelCaseComplete_complete)
endfunction

function! s:BuildRegexp( base )
    " Each character is an anchor for the beginning of a CamelCase word. 
    let l:anchors = map(split(a:base, '\zs'), 'escape(v:val, "\\")')

    " Each CamelCase anchor except the first one must match an upper case
    " character; the CamelCase word may start with either lower or upper case. 
    " Note: We cannot simply use toupper(); 'ignorecase' may suspend this
    " distinction. We also cannot force case sensitivity via /\C/, because that
    " would apply to the entire pattern and thus also to the underscore_words. 
    let l:camelCaseAnchors = 
    \	[ (printf('\[%s%s]', tolower(l:anchors[0]), toupper(l:anchors[0]))) ] +
    \	map(copy(l:anchors[1:]), '"\\%(" . toupper(v:val) . "\\&\\u\\)"') +
    \	['']
    let l:camelCaseStrictRegexp = join(l:camelCaseAnchors, '\%(\U\&\S\)\*')

    let l:underscoreStrictRegexp = join(l:anchors, '\%(_\@!\S\)\*_') . '\%(_\@!\S\)\*'
    return '\V\<\%(' . l:camelCaseStrictRegexp . '\|' . l:underscoreStrictRegexp . '\)\>'
endfunction
function! s:CamelCaseComplete( findstart, base )
    if a:findstart
	" Locate the start of the keyword. 
	let l:startCol = searchpos('\k*\%#', 'bn', line('.'))[1]
	if l:startCol == 0
	    let l:startCol = col('.')
	endif
	let l:base = strpart(getline('.'), l:startCol - 1, (col('.') - l:startCol))
	let s:regexp = s:BuildRegexp(l:base)
echomsg '****' s:regexp
	return l:startCol - 1 " Return byte index, not column. 
    elseif ! empty(a:base)
	" Find keywords matching s:regexp. 
	let l:matches = []
	call CompleteHelper#FindMatches( l:matches, s:regexp, {'complete': s:GetCompleteOption()} )
	return l:matches
    else
	" This completion doesn't work without a base. 
	return []
    endif
endfunction

inoremap <C-x><C-c> <C-o>:set completefunc=<SID>CamelCaseComplete<CR><C-x><C-u>

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
