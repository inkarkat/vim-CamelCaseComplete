" Test: Relaxed completion of CamelCase words with fallback. 

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(14) 
edit CamelCaseComplete.txt

set completefunc=CamelCaseComplete#CamelCaseComplete
set iskeyword+=#

call IsMatchesInIsolatedLine('vsfs', ['VirtColStrFromStart'], 'relaxed fallback matches for vsfs')
call IsMatchesInIsolatedLine('icnip', ['IndentConsistencyCop_non_indent_pattern', 'IndentConsistencyCop_nonIndentPattern'], 'relaxed fallback matches for icnip')
call IsMatchesInIsolatedLine('uu', ['UpperCrazyUpper', 'Upper_crazy_Upper', 'UPPER_CRAZY_UPPER'], 'relaxed fallback matches for uu')
call IsMatchesInIsolatedLine('ew#rt', ['EchoWithoutScrolling#RenderTabs', 'EchoWithoutScrolling#ReplaceTabs'], 'relaxed fallback matches for ew#rt')
call IsMatchesInIsolatedLine('eW#rt', [], 'no matches for eW#rt')
call IsMatchesInIsolatedLine('ew#Rt', [], 'no matches for ew#Rt')
call IsMatchesInIsolatedLine('ew#rT', [], 'no matches for ew#rT')

let g:CamelCaseComplete_CaseInsensitiveFallback = 0
call IsMatchesInIsolatedLine('vsfs', [], 'no matches for vsfs without fallback')
call IsMatchesInIsolatedLine('icnip', [], 'no matches for icnip without fallback')
call IsMatchesInIsolatedLine('uu', [], 'no matches for uu without fallback')
call IsMatchesInIsolatedLine('ew#rt', [], 'no matches for ew#rt without fallback')
call IsMatchesInIsolatedLine('eW#rt', [], 'no matches for eW#rt')
call IsMatchesInIsolatedLine('ew#Rt', [], 'no matches for ew#Rt')
call IsMatchesInIsolatedLine('ew#rT', [], 'no matches for ew#rT')

call vimtest#Quit()
