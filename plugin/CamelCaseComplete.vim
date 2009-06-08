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
    " Each character is an anchor for the beginning of a CamelCaseWord. 
    let l:anchors = map(split(a:base, '\zs'), 'escape(v:val, "\\")')

    " Each CamelCase anchor except the first one must match an upper case
    " character; the CamelCaseWord may start with either lower or upper case. 
    " Note: We cannot simply use toupper(); 'ignorecase' may suspend this
    " distinction. We also cannot force case sensitivity via /\C/, because that
    " would apply to the entire pattern and thus also to the underscore_words. 
    let l:camelCaseAnchors = 
    \	[ (printf('\[%s%s]', tolower(l:anchors[0]), toupper(l:anchors[0]))) ] +
    \	map(l:anchors[1:], '"\\%(" . toupper(v:val) . "\\&\\u\\)"')

    " A strict CamelCase fragment consists of the CamelCase anchor followed by
    " (optional, to handle ACRONYMS inside a CamelCaseWord) non-uppercase
    " keyword characters without '_'. 
    let l:camelCaseStrictFragments = map(copy(l:camelCaseAnchors), 'v:val . ''\%(_\@!\k\&\U\)\*''')

    " A relaxed CamelCase fragment can also be followed by uppercase characters
    " and can swallow underscopes. 
    let l:camelCaseRelaxedFragments = map(copy(l:camelCaseAnchors), 'v:val . ''\k\*''')

    " A strict underscore_word fragment consists of the anchor preceded by
    " underscope(s) (except for the first fragment), followed by keyword
    " characters without '_'. To match, the first fragment must be followed by
    " underscore(s); otherwise, this would swallow arbitrary text at the
    " beginning of a CamelCaseWord. 
    let l:underscoreStrictFragments =
    \	[l:anchors[0] . '\%(_\@!\k\)\+_\@='] +
    \	map(l:anchors[1:], '"_\\+" . v:val . ''\%(_\@!\k\)\+''')

    " A relaxed underscore_word fragment can also swallow underscores for which
    " no anchor was provided. 
    let l:underscoreRelaxedFragments =
    \	[l:anchors[0] . '\k\+_\@='] +
    \	map(l:anchors[1:], '"_\\+" . v:val . ''\k\+''')

    " Assemble all fragments together to build the full regexp. 
    " Each fragment must match either one part of a CamelCaseWord or
    " underscore_word. This way, combined CamelCase_with_underScoreWords can
    " also be matched. 
    let l:strictFragmentsRegexp = ''
    let l:relaxedFragmentsRegexp = ''
    for l:i in range(len(l:anchors))
	let l:strictFragmentsRegexp  .= '\%(' . l:camelCaseStrictFragments[l:i]  . '\|' . l:underscoreStrictFragments[l:i]  . '\)'
	let l:relaxedFragmentsRegexp .= '\%(' . l:camelCaseRelaxedFragments[l:i] . '\|' . l:underscoreRelaxedFragments[l:i] . '\)'
    endfor
    return ['\V\<' . l:strictFragmentsRegexp . '\>', '\V\<' . l:relaxedFragmentsRegexp . '\>']
endfunction
function! s:CamelCaseComplete( findstart, base )
    if a:findstart
	" Locate the start of the keyword. 
	let l:startCol = searchpos('\k*\%#', 'bn', line('.'))[1]
	if l:startCol == 0
	    let l:startCol = col('.')
	endif
	let l:base = strpart(getline('.'), l:startCol - 1, (col('.') - l:startCol))
	let [s:strictRegexp, s:relaxedRegexp] = s:BuildRegexp(l:base)
	return l:startCol - 1 " Return byte index, not column. 
    elseif ! empty(a:base)
	" Find keywords matching the prepared regexp. Use the relaxed regexp
	" when the strict one doesn't yield any matches. 
	let l:matches = []
echomsg '****strict ' s:strictRegexp
	call CompleteHelper#FindMatches( l:matches, s:strictRegexp, {'complete': s:GetCompleteOption()} )
	if empty(l:matches)
echomsg '****relaxed' s:relaxedRegexp
	    call CompleteHelper#FindMatches( l:matches, s:relaxedRegexp, {'complete': s:GetCompleteOption()} )
	endif
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
