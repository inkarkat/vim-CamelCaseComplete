" Test: Ignorecase completion of CamelCase words corner cases.

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(3)
edit CamelCaseComplete.txt

set completefunc=CamelCaseComplete#CamelCaseComplete
set ignorecase

call IsMatchesInIsolatedLine('mr', ['MaP1Roblem', 'MapPPPP123Roblem', 'myACNSubscriptionRenewal', 'myAmbiguousLittleSpecialCommandInReality'], 'relaxed match for mr')

call IsMatchesInIsolatedLine('V', ['virtCol', 'VirtColStrFromStart', 'VirtColStrFromEnd'], 'single-anchor match for V')
call IsMatchesInIsolatedLine('b', ['BadCodeName', 'bad_code_name', 'bad_CODE_NAME', 'BAD_CODE_NAME'], 'single-anchor match for b')

call vimtest#Quit()
