" CamelCaseComplete.vim: Insert mode completion that expands CamelCaseWords and
" underscore_words based on anchor characters for each word fragment. 
"
" DESCRIPTION:
"   This plugin offers a keyword completion that is limited to identifiers which
"   adhere to either CamelCase ("anIdentifier") or underscore_notation
"   ("an_identifier") naming conventions. This often results in a single (or
"   very few) matches and thus allows quick completion of function, class and
"   variable names.
"   The list of completion candidates can be restricted by triggering completion
"   on all or some of the initial letters of each word fragment; e.g. "vlcn"
"   would expand to "VeryLongClassName" and "verbose_latitude_correction_numeric".
"
" USAGE:
" i_CTRL-X_CTRL-C	Find matches for CamelCaseWords and underscore_words
"			whose individual word fragments begin with the typed
"			letters in front of the cursor. 
"
"   The initial letter of the first fragment must always be included; initial
"   letters of subsequent fragments can, but need not be specified. If there are
"   matches where each fragment starts with one typed letter (e.g. "jaev" ->
"   "justAnExampleVar"), only those strict matches are offered. Otherwise, a
"   relaxed search for completions will also include matches where some
"   fragments have no representation in the typed letters (e.g. "je" ->
"   "justAnExampleVar"). In short: Type all initial letters for a precise and
"   narrow completion, or just a few initial letters (but always the first!)
"   when there are too many fragments (e.g. "avl" ->
"   "aVeryLongVarWithTooManyFragments") or the match is non-ambiguous, anyway
"   (e.g. "xz" -> "xVariableUsedForZipping"). 
"
"   The search for completions honors the 'ignorecase' and 'smartcase' settings
"   for underscore_words. Without 'ignorecase', "ai" will only match
"   "an_identifier" and "AI" -> "AN_Identifier". Case doesn't matter for
"   CamelCaseWords, the first fragment can start with either lower or upper
"   case; all subsequent fragments must start with an upper case letter. Thus,
"   you do not need to type "aCCW" to get "aCamelCaseWord"; "accw" will do, too. 
"
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
" Copyright: (C) 2009 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	003	10-Jun-2009	BF: ACRONYMs inside CamelCaseWords are now
"				included in strict matches, not relaxed. 
"				BF: Relaxed CamelCase match does not match
"				anchor inside ACRONYMS, only at the beginning of
"				a fragment. 
"	002	09-Jun-2009	BF: First relaxed CamelCase fragment must not
"				swallow underscores. 
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

function! s:BuildRegexpFragments( anchors )
    " We need at least two anchors to be able to build an exact match for
    " CamelCaseWords or underscore_words. If we have less than that, build
    " regexps that match anything resembling CamelCaseWords / underscore_words. 
    "
    " Without any anchors, build a regexp that matches any CamelCaseWord or
    " underscore_word. 
    if len(a:anchors) == 0
	return [
	\   ['\%(' .
	\	'\k\*\%(_\@!\k\&\U\)\k\*\u\k\+' .
	\   '\|' .
	\	'_\*\k\*\%(_\@!\k\)_\+\%(_\@!\k\)\%(\k\|_\)\*' .
	\   '\)'],
	\   []
	\]
    endif

    " Each CamelCase anchor except the first one must match an upper case
    " character; the CamelCaseWord may start with either lower or upper case. 
    " Note: We cannot simply use toupper(); 'ignorecase' may suspend this
    " distinction. We also cannot force case sensitivity via /\C/, because that
    " would apply to the entire pattern and thus also to the underscore_words. 
    let l:camelCaseAnchors = 
    \	[ (printf('\[%s%s]', tolower(a:anchors[0]), toupper(a:anchors[0]))) ] +
    \	map(a:anchors[1:], '"\\%(" . toupper(v:val) . "\\&\\u\\)"')

    " With just one anchor, build a regexp that matches any CamelCaseWord or
    " underscore_word starting with the anchor (possibly preceded by leading
    " underscore(s)). 
    if len(a:anchors) == 1
	return [
	\   ['\%(' .
	\	l:camelCaseAnchors[0] . '\%(_\@!\k\)\*\%(_\@!\k\&\U\)\%(_\@!\k\)\*\u\k\+' .
	\   '\|' .
	\	'_\*' . a:anchors[0] . '\k\*\%(_\@!\k\)_\+\%(_\@!\k\)\%(\k\|_\)\*' .
	\   '\)'],
	\   []
	\]
    endif

    " A strict CamelCase fragment consists of the CamelCase anchor followed by
    " non-uppercase keyword characters without '_', or the upper case anchor
    " followed by a sequence of upper case characters (to handle ACRONYMS); this
    " must not be followed by two (or more) uppercase characters, or the ACRONYM
    " would not yet have ended. (One following uppercase character is (probably)
    " okay, it is (hopefully) the beginning of the next CamelCase fragment.) To
    " match, the first fragment must be followed by an upper case character;
    " otherwise, this would make the match at the beginning of a underscore_word
    " always case insensitive. 
    let l:camelCaseStrictFragments =
    \	['\%(' . l:camelCaseAnchors[0] . '\%(_\@!\k\&\U\)\+\u\@=\|\%(' . toupper(a:anchors[0]) . '\&\u\)\u\+\%(\u\u\)\@!\)'] +
    \	map(l:camelCaseAnchors[1:], 'v:val . ''\%(\%(_\@!\k\&\U\)\+\|\u\+\%(\u\u\)\@!\)''')

    " A relaxed CamelCase fragment can also be followed by uppercase characters
    " and can swallow underscores. No uppercase character must precede this
    " fragment or the anchor must be followed by a lowercase character to avoid
    " that anything inside an ACRONYM matches. To match, the first fragment must
    " not contain underscores and be followed by an upper case character;
    " otherwise, this would make the match at the beginning of a underscore_word
    " always case insensitive.
    let l:camelCaseRelaxedFragments =
    \	[l:camelCaseAnchors[0] . '\%(_\@!\k\)\*\u\@='] +
    \	map(l:camelCaseAnchors[1:], '''\%(\U\@<='' . v:val . ''\k\*\|'' . v:val . ''\l\k\*\)''')

    " A strict underscore_word fragment consists of the anchor preceded by
    " underscore(s) (except for the first fragment, where any preceding
    " underscore(s) are optional), followed by keyword characters without '_'.
    " To match, the first fragment must be followed by underscore(s); otherwise,
    " this would swallow arbitrary text at the beginning of a CamelCaseWord. 
    let l:underscoreStrictFragments =
    \	['_\*' . a:anchors[0] . '\%(_\@!\k\)\+_\@='] +
    \	map(a:anchors[1:], '"_\\+" . v:val . ''\%(_\@!\k\)\+''')

    " A relaxed underscore_word fragment can also swallow underscores for which
    " no anchor was provided. 
    let l:underscoreRelaxedFragments =
    \	['_\*' . a:anchors[0] . '\k\+_\@='] +
    \	map(a:anchors[1:], '"_\\+" . v:val . ''\k\+''')

    " Each fragment must match either one part of a CamelCaseWord or
    " underscore_word. This way, combined CamelCase_with_underScoreWords can
    " also be matched. 
    let l:strictRegexpFragments = []
    let l:relaxedRegexpFragments = []
    for l:i in range(len(a:anchors))
	call add(l:strictRegexpFragments, '\%(' . l:camelCaseStrictFragments[l:i]  . '\|' . l:underscoreStrictFragments[l:i]  . '\)')
	call add(l:relaxedRegexpFragments, '\%(' . l:camelCaseRelaxedFragments[l:i] . '\|' . l:underscoreRelaxedFragments[l:i] . '\)')
    endfor
    return [l:strictRegexpFragments, l:relaxedRegexpFragments]
endfunction
function! s:WholeWordMatch( expr )
    return '\V\<' . a:expr . '\>'
endfunction
function! s:BuildRegexp( base )
    " Each character is an anchor for the beginning of a CamelCaseWord. 
    let l:anchors = map(split(a:base, '\zs'), 'escape(v:val, "\\")')

    let [l:strictRegexpFragments, l:relaxedRegexpFragments] = s:BuildRegexpFragments(l:anchors)

    " Each anchor results in one fragment; there still is one fragment when
    " there are no anchors. 
    let l:fragmentsNum = (len(l:anchors) == 0 ? 1 : len(l:anchors))

    " Assemble all regexp fragments together to build the full regexp. 
    let l:strictRegexp = ''
    let l:relaxedRegexp = ''
    for l:i in range(l:fragmentsNum)
	let l:strictRegexp  .= get(l:strictRegexpFragments,  l:i, '')
	let l:relaxedRegexp .= get(l:relaxedRegexpFragments, l:i, '')
    endfor
    return [s:WholeWordMatch(l:strictRegexp), s:WholeWordMatch(l:relaxedRegexp)]
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
    elseif ! empty(s:strictRegexp)
	" Find keywords matching the prepared regexp. Use the relaxed regexp
	" when the strict one doesn't yield any matches. 
	let l:matches = []
echomsg '****strict ' s:strictRegexp
	call CompleteHelper#FindMatches( l:matches, s:strictRegexp, {'complete': s:GetCompleteOption()} )
	if empty(l:matches) && ! empty(s:relaxedRegexp)
echomsg '****relaxed' s:relaxedRegexp
	    echohl ModeMsg
	    echo '-- User defined completion (^U^N^P) -- Relaxed search...'
	    echohl None
	    call CompleteHelper#FindMatches( l:matches, s:relaxedRegexp, {'complete': s:GetCompleteOption()} )
	endif
	return l:matches
    else
	" This completion doesn't work without a base. 
	return []
    endif
endfunction

inoremap <Plug>CamelCaseComplete <C-o>:set completefunc=<SID>CamelCaseComplete<CR><C-x><C-u>
if ! hasmapto('<Plug>CamelCaseComplete', 'i')
    if empty(maparg("\<C-c>", 'i'))
	" The i_CTRL-C command quits insert mode; it seems this even happens
	" when <C-c> is part of a mapping. To avoid this, the <C-c> command is
	" turned off here (unless it has already been remapped elsewhere). 
	inoremap <C-c> <Nop>
    endif
    imap <C-x><C-c> <Plug>CamelCaseComplete
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
