" Test: Completion of CamelCase words corner cases.

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(22)
edit CamelCaseComplete.txt

set completefunc=CamelCaseComplete#CamelCaseComplete

call IsMatchesInIsolatedLine('iicc', ['identifierInCamelCase'], 'single CamelCase strict match with iicc')
call IsMatchesInIsolatedLine('iICC', ['identifierInCamelCase'], 'single CamelCase strict match with iICC')
call IsMatchesInIsolatedLine('iIcC', ['identifierInCamelCase'], 'single CamelCase strict match with iIcC')

call IsMatchesInIsolatedLine('rr', ['relaxedRegexp'], 'strict match for rr')
call IsMatchesInIsolatedLine('irr', ['inRelaxedRegexp'], 'strict match for irr')
call IsMatchesInIsolatedLine('RK', [], 'no REMAR-KS match for RK')
call IsMatchesInIsolatedLine('iRK', [], 'no in-REMAR-KS match for iRK')

call IsMatchesInIsolatedLine('masr', ['myACNSubscriptionRenewal'], 'strict match for masr')
call IsMatchesInIsolatedLine('macnsr', [], 'no match when spelling out acronym for macnsr')
call IsMatchesInIsolatedLine('mansr', [], 'no match inside acronym for mansr')
call IsMatchesInIsolatedLine('msr', ['myACNSubscriptionRenewal', 'myAmbiguousLittleSpecialCommandInReality'], 'relaxed match for msr')
call IsMatchesInIsolatedLine('mr', ['myACNSubscriptionRenewal', 'myAmbiguousLittleSpecialCommandInReality'], 'relaxed match for mr')

call IsMatchesInIsolatedLine('V', ['VirtColStrFromStart', 'VirtColStrFromEnd'], 'single-anchor match for V')
call IsMatchesInIsolatedLine('b', ['bad_code_name', 'bad_CODE_NAME'], 'single-anchor match for b')
call IsMatchesInIsolatedLine('x', [], 'no single-anchor match for x')

call IsMatchesInIsolatedLine('swu', ['_starting_with_underscore'], 'match for starting with underscore')
call IsMatchesInIsolatedLine('ewu', ['ending_with_underscore_'], 'match for ending with underscore')
call IsMatchesInIsolatedLine('ob', ['_or_both_'], 'match for starting and ending with underscore')

call IsMatchesInIsolatedLine('o', ['_or_both_'], 'single-anchor match starting and ending with underscore')

call IsMatchesInIsolatedLine('msu', ['multiple__subsequent____underscores'], 'match for multiple subsequent underscores')
call IsMatchesInIsolatedLine('msue', ['__mul__sub__und__everywhere__'], 'match for multiple subsequent underscores starting and ending')

" Perform the no-anchor completions on a minimal set of completion candidates.
%g!/^MINIMAL:/d
call IsMatchesInIsolatedLine('', ['identifierInCamelCase', 'jdentifierJnCamelCase', 'preferring_underscore_words', 'qreferring_underscore_xords', '_starting_with_underscore', 'ending_with_underscore_', '_or_both_'], 'no-anchor matches')

call vimtest#Quit()
