" Test: Completion of CamelCase words corner cases. 

runtime plugin/CamelCaseComplete.vim
source helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(15) 
edit CamelCaseComplete.txt

call SetCompletion("\<C-x>\<C-c>")

call IsMatchesInIsolatedLine('iicc', ['identifierInCamelCase'], 'single CamelCase strict match with iicc')
call IsMatchesInIsolatedLine('IICC', ['identifierInCamelCase'], 'single CamelCase strict match with IICC')
call IsMatchesInIsolatedLine('IiCc', ['identifierInCamelCase'], 'single CamelCase strict match with IiCc')

call IsMatchesInIsolatedLine('masr', ['myACNSubscriptionRenewal', 'myAmbiguousLittleSpecialCommandInReality'], 'relaxed match for masr')
call IsMatchesInIsolatedLine('macnsr', ['myACNSubscriptionRenewal'], 'strict match for macnsr')

call IsMatchesInIsolatedLine('V', ['virtCol', 'VirtColStrFromStart', 'VirtColStrFromEnd'], 'single-anchor match for V')
call IsMatchesInIsolatedLine('b', ['BadCodeName', 'bad_code_name', 'bad_CODE_NAME'], 'single-anchor match for b')
call IsMatchesInIsolatedLine('x', [], 'no single-anchor match for x')

call IsMatchesInIsolatedLine('swu', ['_starting_with_underscore'], 'match for starting with underscore')
call IsMatchesInIsolatedLine('ewu', ['ending_with_underscore_'], 'match for ending with underscore')
call IsMatchesInIsolatedLine('ob', ['_or_both_'], 'match for starting and ending with underscore')

call IsMatchesInIsolatedLine('o', ['_or_both_'], 'single-anchor match starting and ending with underscore')

call IsMatchesInIsolatedLine('msu', ['multiple__subsequent____underscores'], 'match for multiple subsequent underscores')
call IsMatchesInIsolatedLine('msue', ['__mul__sub__und__everywhere__'], 'match for multiple subsequent underscores')


" Perform the no-anchor completions on a minimal set of completion candidates. 
%g!/^MINIMAL:/d

call IsMatchesInIsolatedLine('', ['identifierInCamelCase', 'jdentifierJnCamelCase', 'preferring_underscore_words', 'qreferring_underscore_xords', '_starting_with_underscore', 'ending_with_underscore_', '_or_both_'], 'no-anchor matches')

call vimtest#Quit()

