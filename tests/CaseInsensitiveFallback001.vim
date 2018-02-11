" Test: Strict completion of CamelCase words with fallback. 
" Tests that the fallback is only active when the completion base does not
" contain uppercase characters. 
" Tests that the fallback mostly yields the same results as 'smartcase'. 

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(27) 
edit CamelCaseComplete.txt

set completefunc=CamelCaseComplete#CamelCaseComplete
set iskeyword+=#

function! s:SmartCaseTests( what )
    call IsMatchesInIsolatedLine('vcsfs', ['VirtColStrFromStart'], 'strict '.a:what.' matches for vcsfs')
    call IsMatchesInIsolatedLine('iccnip', ['IndentConsistencyCop_non_indent_pattern', 'IndentConsistencyCop_nonIndentPattern'], 'strict '.a:what.' matches for iccnip')
    call IsMatchesInIsolatedLine('ucu', ['UpperCrazyUpper', 'Upper_crazy_Upper', 'UPPER_CRAZY_UPPER'], 'strict '.a:what.' matches for ucu')
    call IsMatchesInIsolatedLine('ews#rt', ['EchoWithoutScrolling#RenderTabs', 'EchoWithoutScrolling#ReplaceTabs'], 'strict '.a:what.' matches for ews#rt')
    call IsMatchesInIsolatedLine('eWs#rt', [], 'no '.a:what.' matches for eWs#rt')
    call IsMatchesInIsolatedLine('ews#Rt', [], 'no '.a:what.' matches for ews#Rt')
    call IsMatchesInIsolatedLine('ews#rT', [], 'no '.a:what.' matches for ews#rT')
    call IsMatchesInIsolatedLine('uCN', ['underscore_Code_Name', 'underscore_CODE_NAME'], 'strict '.a:what.' matches for uCN')
endfunction

let g:CamelCaseComplete_CaseInsensitiveFallback = 1
call s:SmartCaseTests('fallback')
call IsMatchesInIsolatedLine('ccn', ['camelCodeName'], 'strict fallback matches for ccn')

let g:CamelCaseComplete_CaseInsensitiveFallback = 0
    call IsMatchesInIsolatedLine('vcsfs', [], 'no matches for vcsfs without fallback')
    call IsMatchesInIsolatedLine('iccnip', [], 'no matches for iccnip without fallback')
    call IsMatchesInIsolatedLine('ucu', [], 'no matches for ucu without fallback')
    call IsMatchesInIsolatedLine('ews#rt', [], 'no matches for ews#rt without fallback')
    call IsMatchesInIsolatedLine('eWs#rt', [], 'no matches for eWs#rt')
    call IsMatchesInIsolatedLine('ews#Rt', [], 'no matches for ews#Rt')
    call IsMatchesInIsolatedLine('ews#rT', [], 'no matches for ews#rT')
    call IsMatchesInIsolatedLine('uCN', ['underscore_Code_Name', 'underscore_CODE_NAME'], 'strict matches for uCN')
    call IsMatchesInIsolatedLine('ccn', ['camelCodeName'], 'strict matches for ccn')

set ignorecase smartcase
call s:SmartCaseTests('smartcase')
call IsMatchesInIsolatedLine('ccn', ['CamelCodeName', 'camelCodeName'], 'strict smartcase matches for ccn')

call vimtest#Quit()
