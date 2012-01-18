" Test: Strict completion of CamelCase words with fallback. 

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(14) 
edit CamelCaseComplete.txt

set completefunc=CamelCaseComplete#CamelCaseComplete
set iskeyword+=#

call IsMatchesInIsolatedLine('vcsfs', ['VirtColStrFromStart'], 'strict fallback matches for vcsfs')
call IsMatchesInIsolatedLine('iccnip', ['IndentConsistencyCop_non_indent_pattern', 'IndentConsistencyCop_nonIndentPattern'], 'strict fallback matches for iccnip')
call IsMatchesInIsolatedLine('ucu', ['UpperCrazyUpper', 'Upper_crazy_Upper', 'UPPER_CRAZY_UPPER'], 'strict fallback matches for ucu')
call IsMatchesInIsolatedLine('ews#rt', ['EchoWithoutScrolling#RenderTabs', 'EchoWithoutScrolling#ReplaceTabs'], 'strict fallback matches for ews#rt')
call IsMatchesInIsolatedLine('eWs#rt', [], 'no matches for eWs#rt')
call IsMatchesInIsolatedLine('ews#Rt', [], 'no matches for ews#Rt')
call IsMatchesInIsolatedLine('ews#rT', [], 'no matches for ews#rT')

let g:CamelCaseComplete_CaseInsensitiveFallback = 0
call IsMatchesInIsolatedLine('vcsfs', [], 'no matches for vcsfs without fallback')
call IsMatchesInIsolatedLine('iccnip', [], 'no matches for iccnip without fallback')
call IsMatchesInIsolatedLine('ucu', [], 'no matches for ucu without fallback')
call IsMatchesInIsolatedLine('ews#rt', [], 'no matches for ews#rt without fallback')
call IsMatchesInIsolatedLine('eWs#rt', [], 'no matches for eWs#rt')
call IsMatchesInIsolatedLine('ews#Rt', [], 'no matches for ews#Rt')
call IsMatchesInIsolatedLine('ews#rT', [], 'no matches for ews#rT')

call vimtest#Quit()
