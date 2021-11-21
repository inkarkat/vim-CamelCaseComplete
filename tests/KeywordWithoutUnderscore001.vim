" Test: Completion of CamelCase words when '_' is not a keyword character;

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(10)
edit CamelCaseComplete.txt
setlocal iskeyword-=_

set completefunc=CamelCaseComplete#CamelCaseComplete

call IsMatchesInIsolatedLine('V', ['VirtColStrFromStart', 'VirtColStrFromEnd'], 'single-anchor match for V')
call IsMatchesInIsolatedLine('b', ['bad_code_name', 'bad_CODE_NAME'], 'single-anchor match for b')
call IsMatchesInIsolatedLine('x', [], 'no single-anchor match for x')

call IsMatchesInIsolatedLine('swu', ['starting_with_underscore'], 'match for starting with underscore')
call IsMatchesInIsolatedLine('ewu', ['ending_with_underscore'], 'match for ending with underscore')
call IsMatchesInIsolatedLine('ob', ['or_both'], 'match for starting and ending with underscore')

call IsMatchesInIsolatedLine('o', ['or_both'], 'single-anchor match starting and ending with underscore')

call IsMatchesInIsolatedLine('msu', ['mul__sub__und', 'multiple__subsequent____underscores'], 'match for multiple subsequent underscores')
call IsMatchesInIsolatedLine('msue', ['mul__sub__und__everywhere'], 'match for multiple subsequent underscores starting and ending')

" Perform the no-anchor completions on a minimal set of completion candidates.
%g!/^MINIMAL:/d
call IsMatchesInIsolatedLine('', ['identifierInCamelCase', 'jdentifierJnCamelCase', 'preferring_underscore_words', 'qreferring_underscore_xords', 'starting_with_underscore', 'ending_with_underscore', 'or_both'], 'no-anchor matches')

call vimtest#Quit()
