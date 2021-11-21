" Test: Relaxed completion of CamelCase words with fallback.
" Tests that the fallback is only active when the completion base does not
" contain uppercase characters.
" Tests that the fallback mostly yields the same results as 'smartcase'.

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(24)
edit CamelCaseComplete.txt

set completefunc=CamelCaseComplete#CamelCaseComplete
set iskeyword+=#

function! s:SmartCaseTests( what )
    call IsMatchesInIsolatedLine('vsfs', ['VirtColStrFromStart'], 'relaxed '.a:what.' matches for vsfs')
    call IsMatchesInIsolatedLine('icnip', ['IndentConsistencyCop_non_indent_pattern', 'IndentConsistencyCop_nonIndentPattern'], 'relaxed '.a:what.' matches for icnip')
    call IsMatchesInIsolatedLine('uu', ['UpperCrazyUpper', 'Upper_crazy_Upper', 'UPPER_CRAZY_UPPER'], 'relaxed '.a:what.' matches for uu')
    call IsMatchesInIsolatedLine('ew#rt', ['EchoWithoutScrolling#RenderTabs', 'EchoWithoutScrolling#ReplaceTabs'], 'relaxed '.a:what.' matches for ew#rt')
    call IsMatchesInIsolatedLine('eW#rt', [], 'no '.a:what.' matches for eW#rt')
    call IsMatchesInIsolatedLine('ew#Rt', [], 'no '.a:what.' matches for ew#Rt')
    call IsMatchesInIsolatedLine('ew#rT', [], 'no '.a:what.' matches for ew#rT')
    call IsMatchesInIsolatedLine('uN', ['underscore_Code_Name', 'underscore_CODE_NAME'], 'relaxed '.a:what.' matches for uN')
endfunction

let g:CamelCaseComplete_CaseInsensitiveFallback = 1
call s:SmartCaseTests('fallback')

let g:CamelCaseComplete_CaseInsensitiveFallback = 0
    call IsMatchesInIsolatedLine('vsfs', [], 'no matches for vsfs without fallback')
    call IsMatchesInIsolatedLine('icnip', [], 'no matches for icnip without fallback')
    call IsMatchesInIsolatedLine('uu', [], 'no matches for uu without fallback')
    call IsMatchesInIsolatedLine('ew#rt', [], 'no matches for ew#rt without fallback')
    call IsMatchesInIsolatedLine('eW#rt', [], 'no matches for eW#rt')
    call IsMatchesInIsolatedLine('ew#Rt', [], 'no matches for ew#Rt')
    call IsMatchesInIsolatedLine('ew#rT', [], 'no matches for ew#rT')
    call IsMatchesInIsolatedLine('uN', ['underscore_Code_Name', 'underscore_CODE_NAME'], 'relaxed matches for uN')

set ignorecase smartcase
call s:SmartCaseTests('smartcase')

call vimtest#Quit()
