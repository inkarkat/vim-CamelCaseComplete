" Test: Case-insensitive completion of CamelCase words. 

runtime plugin/CamelCaseComplete.vim
source helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(12) 
edit CamelCaseComplete.txt
set ignorecase nosmartcase

call SetCompletion("\<C-x>\<C-c>")

call IsMatchesInIsolatedLine('iicc', ['identifierInCamelCase'], 'single CamelCase strict match')
call IsMatchesInIsolatedLine('puw', ['preferring_underscore_words'], 'single underscore_word strict match')
call IsMatchesInIsolatedLine('jfms', [], 'no matches with jfms')
call IsMatchesInIsolatedLine('mtr', [], 'mtr')

call IsMatchesInIsolatedLine('acn', ['anyCrazyName', 'anotherCodeName', 'AnotherCodeName', 'any_crazy_name', 'another_code_name'], 'strict matches with acn')
call IsMatchesInIsolatedLine('an', ['anyCrazyName', 'anotherCodeName', 'AnotherCodeName', 'any_crazy_name', 'another_code_name'], 'relaxed matches with an')
call IsMatchesInIsolatedLine('ACN', ['anyCrazyName', 'anotherCodeName', 'AnotherCodeName', 'another_code_name', 'any_crazy_name' ], 'strict matches with ACN')
call IsMatchesInIsolatedLine('AN', ['anyCrazyName', 'anotherCodeName', 'AnotherCodeName', 'another_code_name', 'any_crazy_name' ], 'relaxed matches with AN')
call IsMatchesInIsolatedLine('ucn', ['underscore_code_name', 'underscore_Code_Name', 'underscore_CODE_NAME'], 'strict matches with ucn')
call IsMatchesInIsolatedLine('uCN', ['underscore_code_name', 'underscore_Code_Name', 'underscore_CODE_NAME'], 'strict matches with uCN')
call IsMatchesInIsolatedLine('tN',  ['thatCrazyName', 'this_crazy_name', 'this_Crazy_Name', 'this_CRAZY_NAME'], 'relaxed matches with tN')
call IsMatchesInIsolatedLine('UCN', ['underscore_code_name', 'underscore_Code_Name', 'underscore_CODE_NAME'], 'strict matches with UCN')

call vimtest#Quit()

