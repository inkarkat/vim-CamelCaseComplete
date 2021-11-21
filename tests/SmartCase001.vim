" Test: Smartcase completion of CamelCase words.

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(12)
edit CamelCaseComplete.txt
set ignorecase smartcase

set completefunc=CamelCaseComplete#CamelCaseComplete

call IsMatchesInIsolatedLine('iicc', ['identifierInCamelCase'], 'single CamelCase strict match')
call IsMatchesInIsolatedLine('puw', ['preferring_underscore_words'], 'single underscore_word strict match')
call IsMatchesInIsolatedLine('jfms', [], 'no matches for jfms')
call IsMatchesInIsolatedLine('mtr', [], 'mtr')

call IsMatchesInIsolatedLine('acn', ['anyCrazyName', 'anotherCodeName', 'AnotherCodeName', 'any_crazy_name', 'another_code_name'], 'strict matches for acn')
call IsMatchesInIsolatedLine('an', ['anyCrazyName', 'anotherCodeName', 'AnotherCodeName', 'any_crazy_name', 'another_code_name'], 'relaxed matches for an')
call IsMatchesInIsolatedLine('ACN', ['AnotherCodeName'], 'strict matches for ACN')
call IsMatchesInIsolatedLine('AN', ['AnotherCodeName'], 'relaxed matches for AN')
call IsMatchesInIsolatedLine('ucn', ['underscore_code_name', 'underscore_Code_Name', 'underscore_CODE_NAME'], 'strict matches for ucn')
call IsMatchesInIsolatedLine('uCN', ['underscore_Code_Name', 'underscore_CODE_NAME'], 'strict matches for uCN')
call IsMatchesInIsolatedLine('tN',  ['thatCrazyName', 'this_Crazy_Name', 'this_CRAZY_NAME'], 'relaxed matches for tN')
call IsMatchesInIsolatedLine('UCN', [], 'no matches for UCN')

call vimtest#Quit()
