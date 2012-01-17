" Test: Completion of CamelCase words. 

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(22) 
edit CamelCaseComplete.txt

set completefunc=CamelCaseComplete#CamelCaseComplete

call IsMatchesInIsolatedLine('iicc', ['identifierInCamelCase'], 'single CamelCase strict match')
call IsMatchesInIsolatedLine('jjcc', ['jdentifierJnCamelCase'], 'single CamelCase strict match')
call IsMatchesInIsolatedLine('jc', ['jdentifierJnCamelCase'], 'single CamelCase relaxed match')

call IsMatchesInIsolatedLine('puw', ['preferring_underscore_words'], 'single underscore_word strict match')
call IsMatchesInIsolatedLine('qux', ['qreferring_underscore_xords'], 'single underscore_word strict match')
call IsMatchesInIsolatedLine('qx', ['qreferring_underscore_xords'], 'single underscore_word relaxed match')

call IsMatchesInIsolatedLine('tcn', ['thatCrazyName', 'this_crazy_name'], 'mixed strict matches')
call IsMatchesInIsolatedLine('acn', ['anyCrazyName', 'anotherCodeName', 'any_crazy_name', 'another_code_name'], 'strict matches with acn')
call IsMatchesInIsolatedLine('an', ['anyCrazyName', 'anotherCodeName', 'any_crazy_name', 'another_code_name'], 'relaxed matches with an')
call IsMatchesInIsolatedLine('ACN', ['AnotherCodeName' ], 'strict matches with ACN')
call IsMatchesInIsolatedLine('AN', ['AnotherCodeName' ], 'relaxed matches with AN')
call IsMatchesInIsolatedLine('ucn', ['underscore_code_name'], 'strict matches with ucn')
call IsMatchesInIsolatedLine('uCN', ['underscore_Code_Name', 'underscore_CODE_NAME'], 'strict matches with uCN')
call IsMatchesInIsolatedLine('uN', ['underscore_Code_Name', 'underscore_CODE_NAME'], 'relaxed matches with uN')
call IsMatchesInIsolatedLine('UCN', [], 'no matches with UCN')

call IsMatchesInIsolatedLine('Icch', ['IndentConsistencyCop_highlighting'], 'strict match for Icch')
call IsMatchesInIsolatedLine('Iccnip', ['IndentConsistencyCop_non_indent_pattern', 'IndentConsistencyCop_nonIndentPattern'], 'strict matches for Iccnip')
call IsMatchesInIsolatedLine('Iccn', ['IndentConsistencyCop_non_indent_pattern', 'IndentConsistencyCop_nonIndentPattern'], 'relaxed matches for Iccn')
call IsMatchesInIsolatedLine('Icci', ['IndentConsistencyCop_non_indent_pattern', 'IndentConsistencyCop_nonIndentPattern'], 'relaxed matches for Icci')
call IsMatchesInIsolatedLine('Iccp', ['IndentConsistencyCop_non_indent_pattern', 'IndentConsistencyCop_nonIndentPattern'], 'relaxed matches for Iccp')

call IsMatchesInContext('some text ', ' trailing text', 'iicc', ['identifierInCamelCase'], 'single CamelCase strict match inside space-delimted text')
call IsMatchesInContext('some text;', ';trailing text', 'iicc', ['identifierInCamelCase'], 'single CamelCase strict match inside ;-delimted text')

call vimtest#Quit()

