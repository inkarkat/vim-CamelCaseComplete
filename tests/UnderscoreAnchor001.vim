" Test Completion of CamelCase word with underscore anchor.

runtime tests/helpers/completetest.vim
call append(0, ['the testDelete_predefinedCxWithoutContentPackDevMode() function', 'another testDeletePredefinedCxWithoutContentPackDevMode() function'])
set completefunc=CamelCaseComplete#CamelCaseComplete

call vimtest#StartTap()
call vimtap#Plan(9)

call IsMatchesInIsolatedLine('td_pCWCPDM', ['testDelete_predefinedCxWithoutContentPackDevMode'], 'single strict match with td_pCWCPDM')
call IsMatchesInIsolatedLine('tdpW', ['testDelete_predefinedCxWithoutContentPackDevMode', 'testDeletePredefinedCxWithoutContentPackDevMode'], 'single relaxed match with tdpW')
call IsMatchesInIsolatedLine('tdpC', ['testDelete_predefinedCxWithoutContentPackDevMode', 'testDeletePredefinedCxWithoutContentPackDevMode'], 'single relaxed match with tdpC')
call IsMatchesInIsolatedLine('tdcd', ['testDelete_predefinedCxWithoutContentPackDevMode', 'testDeletePredefinedCxWithoutContentPackDevMode'], 'single relaxed match with tdcd')
call IsMatchesInIsolatedLine('tddm', ['testDelete_predefinedCxWithoutContentPackDevMode', 'testDeletePredefinedCxWithoutContentPackDevMode'], 'single relaxed match with tddm')
call IsMatchesInIsolatedLine('td_CC', ['testDelete_predefinedCxWithoutContentPackDevMode'], 'single relaxed match with td_CC')
call IsMatchesInIsolatedLine('td_CM', ['testDelete_predefinedCxWithoutContentPackDevMode'], 'single relaxed match with td_CM')
call IsMatchesInIsolatedLine('td_pW', ['testDelete_predefinedCxWithoutContentPackDevMode'], 'single relaxed match with td_pW')
call IsMatchesInIsolatedLine('td_pC', ['testDelete_predefinedCxWithoutContentPackDevMode'], 'single relaxed match with td_pC')

call vimtest#Quit()
