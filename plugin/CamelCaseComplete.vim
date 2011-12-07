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
"   Non-alphabetic keyword characters can be thrown in, too, to narrow down the
"   number of matches. 
"
" USAGE:
" <i_CTRL-X_CTRL-C>	Find matches for CamelCaseWords and underscore_words
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
"   "an_identifier" and "AI" -> "AN_Identifier". For CamelCaseWords, the first
"   fragment must start with the same case as used in the first typed letter
"   (unless 'ignorecase'); all subsequent fragments must start with an uppercase
"   letter. Thus, you do not need to type "aCCW" to get "aCamelCaseWord"; "accw"
"   will do, too. To get "TheCamelCaseWord", type either "Tccw" or "TCCW". 
"
" INSTALLATION:
" DEPENDENCIES:
"   - Requires Vim 7.1 or higher. 
"   - CompleteHelper.vim autoload script. 
"
" CONFIGURATION:
"   Analoguous to the 'complete' option, you can specify which buffers will be
"   scanned for completion candidates. Currently, only '.' (current buffer) and
"   'w' (buffers from other windows) are supported. >
"	let g:CamelCaseComplete_complete string = '.,w'
"   The global setting can be overridden for a particular buffer
"   (b:CamelCaseComplete_complete). 
"
"   To disable the removal of the (mostly useless) completion base when there
"   are no matches: >
"	let g:CamelCaseComplete_FindStartMark = ''
"	
" INTEGRATION:
" LIMITATIONS:
" ASSUMPTIONS:
" KNOWN PROBLEMS:
" TODO:
"
" Copyright: (C) 2009-2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	011	07-Dec-2011	CHG: Do a default match for the anchor of
"				the first CamelCase fragment, not always a
"				case-insensitive match. This way, with
"				'noignorecase', "acw" will only match
"				"aCamelWord" and "Tcw"will only match
"				"TheCamelWord".  
"	010	02-Nov-2011	FIX: Do not clobber unnamed register when
"				removing base keys. 
"	009	30-Sep-2011	Use <silent> for <Plug> mapping instead of
"				default mapping. 
"	008	26-Feb-2010	Moved s:BuildRegexp() from "findstart" to "base"
"				invocation, so that the script-scoped
"				strictRegexp and relaxedRegexp become local
"				variables. It doesn't matter when this is
"				invoked; if the base becomes smaller (due to the
"				user undoing the completion via CTRL-E or by
"				repeating <BS>), Vim will re-invoke both modes,
"				anyway. 
"	007	12-Jan-2010	Now setting g:CamelCaseComplete_FindStartMark by
"				default, and considering the limited
"				availability of the '" mark. 
"				Found out that the plugin doesn't work on Vim
"				7.0; updated version guard. 
"	006	07-Aug-2009	Using a map-expr instead of i_CTRL-O to set
"				'completefunc', as the temporary leave of insert
"				mode caused a later repeat via '.' to only
"				insert the completed fragment, not the entire
"				inserted text.  
"	005	18-Jun-2009	Implemented optional setting of a mark at the
"				findstart position. If this is done, the
"				completion base is automatically removed if no
"				matches were found: As the base just consists of
"				a sequence of anchor characters, it isn't
"				helpful for further editing when the completion
"				failed. 
"	004	11-Jun-2009	Implemented keyword (i.e. non-alphabetic)
"				anchors. 
"				BF: Strict underscore_word fragments swallowed
"				CamelCaseWords. 
"	003	10-Jun-2009	BF: ACRONYMs inside CamelCaseWords are now
"				included in strict matches, not relaxed. 
"				BF: Relaxed CamelCase match does not match
"				anchor inside ACRONYMS, only at the beginning of
"				a fragment. 
"				BF: Anchor must not match inside ACRONYM, so
"				check that characters following the strict
"				CamelCase fragment do not belong to the same
"				ACRONYM. 
"	002	09-Jun-2009	BF: First relaxed CamelCase fragment must not
"				swallow underscores. 
"	001	08-Jun-2009	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_CamelCaseComplete') || (v:version < 701)
    finish
endif
let g:loaded_CamelCaseComplete = 1
let s:save_cpo = &cpo
set cpo&vim

if ! exists('g:CamelCaseComplete_complete')
    let g:CamelCaseComplete_complete = '.,w'
endif
if ! exists('g:CamelCaseComplete_FindStartMark')
    " To avoid clobbering user-set marks, we use the obscure "last exit point of
    " buffer" mark. 
    " Setting of mark '" is only supported since Vim 7.2; use last jump mark ''
    " for Vim 7.1. 
    let g:CamelCaseComplete_FindStartMark = (v:version < 702 ? "'" : '"')
endif

function! s:GetCompleteOption()
    return (exists('b:CamelCaseComplete_complete') ? b:CamelCaseComplete_complete : g:CamelCaseComplete_complete)
endfunction

function! s:BuildAnyMatchFragment()
    " Without any anchors, build a regexp that matches any CamelCaseWord or
    " underscore_word. 
    let l:anyFragmentRegexp = 
    \   '\%(' .
    \	'\k\*\%(_\@!\k\&\U\)\k\*\u\k\+' .
    \   '\|' .
    \	'_\*\k\*\%(_\@!\k\)_\+\%(_\@!\k\)\%(\k\|_\)\*' .
    \   '\)'
    return [l:anyFragmentRegexp, l:anyFragmentRegexp]
endfunction
function! s:BuildAlphabeticRegexpFragments( anchors )
    if len(a:anchors) == 0 | throw 'ASSERT: Must pass anchors.' | endif

    " We need at least two anchors to be able to build an exact match for
    " CamelCaseWords or underscore_words. If we have less than that, build
    " regexps that match anything resembling CamelCaseWords / underscore_words. 
    "
    " The CamelCaseWord may start with either lower or uppercase; each following
    " CamelCase anchor one must match an uppercase character, except when it is
    " preceded by non-alphabetic keyword characters. I.e. we recognize in
    " camelWord#isHere the fragments "c", "W", "i" and "H". 
    " Note: We cannot simply use toupper(); 'ignorecase' may suspend this
    " distinction. We also cannot force case sensitivity via /\C/, because that
    " would apply to the entire pattern and thus also to the underscore_words. 
    let l:camelCaseAnchors = 
    \	[ a:anchors[0]] +
    \	map(a:anchors[1:], '"\\%(" . toupper(v:val) . "\\&\\u\\|\\(\\k\\&\\A\\)\\+" . v:val . "\\)"')

    " With just one anchor, build a regexp that matches any CamelCaseWord or
    " underscore_word starting with the anchor (possibly preceded by leading
    " underscore(s)). 
    if len(a:anchors) == 1
	let l:singleAnchorFragmentRegexp = 
	\   '\%(' .
	\	l:camelCaseAnchors[0] . '\%(_\@!\k\)\*\%(_\@!\k\&\U\)\%(_\@!\k\)\*\u\k\+' .
	\   '\|' .
	\	'_\*' . a:anchors[0] . '\k\*\%(_\@!\k\)_\+\%(_\@!\k\)\%(\k\|_\)\*' .
	\   '\)'
	return [l:singleAnchorFragmentRegexp, l:singleAnchorFragmentRegexp]
    endif

    " A strict CamelCase fragment consists of the CamelCase anchor followed by
    " non-uppercase keyword characters without '_', or the uppercase anchor
    " followed by a sequence of uppercase characters (to handle ACRONYMS); this
    " must not be followed by two (or more) uppercase characters, or the ACRONYM
    " would not yet have ended. (One following uppercase character is okay, as
    " long as the keyword doesn't end there, it is then the beginning of the
    " next CamelCase fragment.)
    " To match, the first fragment must not be followed by 
    " a) an underscore character; otherwise, this would make the match at the
    "    beginning of a underscore_word always case insensitive.
    " b) a lowercase character; the match would stop in the middle of a fragment
    "    and thus introduce a phantom fragment which could match a strict
    "    underscore_word fragment. 
    let l:camelCaseStrictFragments =
    \	['\%(' . l:camelCaseAnchors[0] . '\%(_\@!\k\&\U\)\+\%(_\|\l\)\@!\|\%(' . toupper(a:anchors[0]) . '\&\u\)\u\+\%(\u\u\|\u\>\)\@!\)'] +
    \	map(l:camelCaseAnchors[1:], 'v:val . ''\%(\%(_\@!\k\&\U\)\+\|\u\+\%(\u\u\|\u\>\)\@!\)''')

    " A relaxed CamelCase fragment can also be followed by uppercase characters
    " and can swallow underscores. No uppercase character must precede this
    " fragment or the anchor must be followed by a lowercase character to avoid
    " that anything inside an ACRONYM matches.
    " To match, the first fragment must not contain underscores and not be
    " followed by an underscore character; otherwise, this would make the match
    " at the beginning of a underscore_word always case insensitive.
    let l:camelCaseRelaxedFragments =
    \	[l:camelCaseAnchors[0] . '\%(_\@!\k\)\*_\@!'] +
    \	map(l:camelCaseAnchors[1:], '''\%(\U\@<='' . v:val . ''\k\*\|'' . v:val . ''\l\k\*\)''')

    " A strict underscore_word fragment consists of either
    " a) the anchor preceded by underscore(s) (except for the first fragment,
    "    where any preceding underscore(s) are optional), followed by keyword
    "    characters without '_' that do not contain a CamelCaseWord. 
    " b) the anchor followed by keyword characters without '_' that do not
    "    contain a CamelCaseWord. After that, a second underscore_word fragment
    "    must start (i.e. an after-match of '_'), to ensure that the fragment is
    "    actually part of an underscore_word. 
    " To avoid matching a CamelCaseWord, the keywords without '_' must not
    " contain an uppercase character when there were lowercase characters
    " before, so (in negation) they must be either non-lowercase characters
    " optionally followed by lowercase characters, or all non-uppercase
    " characters. 
    "	Regexp: \%(_\@!\k\&\L\)\+\%(_\@!\k\&l\)\*\|\%(_\@!\k\&\U\)\+
    " To match, the first fragment must be followed by underscore(s); otherwise,
    " this would swallow arbitrary text at the beginning of a CamelCaseWord. 
    let l:underscoreStrictFragments =
    \	['_\*' . a:anchors[0] . '\%(\%(_\@!\k\&\L\)\+\%(_\@!\k\&l\)\*\|\%(_\@!\k\&\U\)\+\)_\@='] +
    \	map(a:anchors[1:], '''\%(_\+'' . v:val . ''\%(\%(_\@!\k\&\L\)\+\%(_\@!\k\&l\)\*\|\%(_\@!\k\&\U\)\+\)\|'' . v:val . ''\%(\%(_\@!\k\&\L\)\+\%(_\@!\k\&l\)\*\|\%(_\@!\k\&\U\)\+\)_\@=\)''')

    " A relaxed underscore_word fragment can also swallow underscores for which
    " no anchor was provided. 
    let l:underscoreRelaxedFragments =
    \	['_\*' . a:anchors[0] . '\k\+_\@='] +
    \	map(a:anchors[1:], '''_\+'' . v:val . ''\k\+''')

    " Each fragment must match either one part of a CamelCaseWord or
    " underscore_word. This way, combined CamelCase_with_underScoreWords can
    " also be matched. 
    let l:strictRegexpFragments = []
    let l:relaxedRegexpFragments = []
    for l:i in range(len(a:anchors))
	call add(l:strictRegexpFragments, '\%(' . l:camelCaseStrictFragments[l:i]  . '\|' . l:underscoreStrictFragments[l:i]  . '\)')
	call add(l:relaxedRegexpFragments, '\%(' . l:camelCaseRelaxedFragments[l:i] . '\|' . l:underscoreRelaxedFragments[l:i] . '\)')
    endfor
    return [join(l:strictRegexpFragments, ''), join(l:relaxedRegexpFragments, '')]
endfunction
function! s:BuildKeywordRegexpFragment( anchor )
    " A strict keyword fragment consists of the keyword anchor optionally
    " followed by anything that is not a CamelCase or underscore fragment. 
    let l:strictRegexpFragment = a:anchor . '\%(_\@!\k\&\A\)\*'

    " A relaxed keyword fragment can also be followed by uppercase characters
    " and can swallow underscores. 
    let l:relaxedRegexpFragment = a:anchor . '\%(\k\&\L\)\*'
    
    return [l:strictRegexpFragment, l:relaxedRegexpFragment]
endfunction
function! s:WholeWordMatch( expr )
    return '\V\<' . a:expr . '\>'
endfunction
function! s:IsAlpha( expr )
    return (a:expr =~# '^\a\+$')
endfunction
function! s:BuildRegexp( base )
    " Each alphabetic character is an anchor for the beginning of a
    " CamelCaseWord or underscore_word. 
    " All other (keyword) characters must just match at that position. 
    let l:anchors = map(split(a:base, '\zs'), 'escape(v:val, "\\")')

    " Assemble all regexp fragments together to build the full regexp. 
    " There is a strict regexp which is tried first and a relaxed regexp to fall
    " back on. 
    let l:strictRegexp = ''
    let l:relaxedRegexp = ''
    let l:idx = 0
    let l:alphabeticCnt = 0
    while l:idx < len(l:anchors)
	let l:anchor = l:anchors[l:idx]
	if s:IsAlpha(l:anchor)
	    " If an anchor is alphabetic, build a regexp fragment from it and
	    " all following alphabetic anchors. We cannot just concatenate
	    " individual regexp fragments because the regexp is different. 
	    let l:alphabeticAnchors = [l:anchor]
	    let l:alphabeticCnt += 1
	    while s:IsAlpha(get(l:anchors, l:idx + 1, ''))
		let l:idx += 1
		let l:alphabeticCnt += 1
		call add(l:alphabeticAnchors, l:anchors[l:idx])
	    endwhile
	    let [l:strictRegexpFragment, l:relaxedRegexpFragment] = s:BuildAlphabeticRegexpFragments(l:alphabeticAnchors)
echomsg '####' join(l:alphabeticAnchors)
	else
	    " If an anchor is a keyword character, just match that character. 
	    let [l:strictRegexpFragment, l:relaxedRegexpFragment] = s:BuildKeywordRegexpFragment(l:anchor)
echomsg '####' '"'. l:anchor . '"'
	endif

	let l:strictRegexp  .= l:strictRegexpFragment
	let l:relaxedRegexp .= l:relaxedRegexpFragment
	let l:idx += 1
    endwhile

    " Each alphabetic anchor results in one fragment; there still is one
    " fragment to match any CamelCaseWords and underscore_words when there are
    " no alphabetic anchors. 
    if l:alphabeticCnt == 0
	let [l:strictRegexpFragment, l:relaxedRegexpFragment] = s:BuildAnyMatchFragment()
	let l:strictRegexp  .= l:strictRegexpFragment
	let l:relaxedRegexp .= l:relaxedRegexpFragment
    endif

"****D return [s:WholeWordMatch(l:strictRegexp), '']
    " With no keyword anchors and no or only one alphabetic anchor, the relaxed
    " regexp may be identical with the strict one. In this case, omit the
    " relaxed regexp to avoid searching for (no existing) matches twice. 
    return [s:WholeWordMatch(l:strictRegexp), (l:relaxedRegexp ==# l:strictRegexp ? '' : s:WholeWordMatch(l:relaxedRegexp))]
endfunction
function! CamelCaseComplete#CamelCaseComplete( findstart, base )
    if a:findstart
	" Locate the start of the keyword that represents the initial letters. 
	let l:startCol = searchpos('\k*\%#', 'bn', line('.'))[1]
	if l:startCol == 0
	    let l:startCol = col('.')
	endif

	if ! empty(g:CamelCaseComplete_FindStartMark)
	    " Record the position of the start of the completion base to allow
	    " removal of the completion base if no matches were found. 
	    let l:findstart = [0, line('.'), l:startCol, 0]
	    call setpos(printf("'%s", g:CamelCaseComplete_FindStartMark), l:findstart)
	endif

	return l:startCol - 1 " Return byte index, not column. 
    else
	let [l:strictRegexp, l:relaxedRegexp] = s:BuildRegexp(a:base)
"****D let [g:sr, g:rr] = [l:strictRegexp, l:relaxedRegexp]
	if empty(l:strictRegexp) | throw 'ASSERT: At least a strict regexp should have been built.' | endif

	" Find keywords matching the prepared regexp. Use the relaxed regexp
	" when the strict one doesn't yield any matches. 
	let l:matches = []
"****D echomsg '****strict ' l:strictRegexp
	call CompleteHelper#FindMatches( l:matches, l:strictRegexp, {'complete': s:GetCompleteOption()} )
	if empty(l:matches) && ! empty(l:relaxedRegexp)
"****D echomsg '****relaxed' l:relaxedRegexp
	    echohl ModeMsg
	    echo '-- User defined completion (^U^N^P) -- Relaxed search...'
	    echohl None
	    call CompleteHelper#FindMatches( l:matches, l:relaxedRegexp, {'complete': s:GetCompleteOption()} )
	endif
	let s:isNoMatches = empty(l:matches)
	return l:matches
    endif
endfunction

function! s:RemoveBaseKeys()
    return (s:isNoMatches && ! empty(g:CamelCaseComplete_FindStartMark) ? "\<C-e>\<C-\>\<C-o>\"_dg`" . g:CamelCaseComplete_FindStartMark : '')
endfunction
inoremap <silent> <script> <Plug>(CamelCasePostComplete) <C-r>=<SID>RemoveBaseKeys()<CR>

function! s:CamelCaseCompleteExpr()
    set completefunc=CamelCaseComplete#CamelCaseComplete
    return "\<C-x>\<C-u>"
endfunction
inoremap <script> <expr> <Plug>(CamelCaseComplete) <SID>CamelCaseCompleteExpr()
if ! hasmapto('<Plug>(CamelCaseComplete)', 'i')
    if empty(maparg("\<C-c>", 'i'))
	" The i_CTRL-C command quits insert mode; it seems this even happens
	" when <C-c> is part of a mapping. To avoid this, the <C-c> command is
	" turned off here (unless it has already been remapped elsewhere). 
	inoremap <C-c> <Nop>
    endif
    execute 'imap <C-x><C-c> <Plug>(CamelCaseComplete)' . (empty(g:CamelCaseComplete_FindStartMark) ? '' : '<Plug>(CamelCasePostComplete)')
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
