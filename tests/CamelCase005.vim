" Test: Completion with augmented iskeyword. 

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(8) 
edit CamelCaseComplete.txt

set completefunc=CamelCaseComplete#CamelCaseComplete

call IsMatchesInIsolatedLine('tmtmtm', ['TickMeTockMeTuckMe'], 'single strict match for tmtmtm')
call IsMatchesInIsolatedLine('TMTMTM', ['TickMeTockMeTuckMe', 'Tick_Me_Tock_Me_Tuck_Me'], 'two strict matches for TMTMTM')

setlocal iskeyword+=:
call IsMatchesInIsolatedLine('tmtmtm', ['TickMeTockMeTuckMe', 'TiggleMe:TaggleMe:ToggleMe'], 'added :-match for tmtmtm')
call IsMatchesInIsolatedLine('TMTMTM', ['TickMeTockMeTuckMe', 'Tick_Me_Tock_Me_Tuck_Me', 'TiggleMe:TaggleMe:ToggleMe', 'Tiggle_Me:Taggle_Me:Toggle_Me'], 'added :-matches for TMTMTM')

call IsMatchesInIsolatedLine('HHTMTMTM', [], 'no strict matches for HHTMTMTM')
setlocal iskeyword+=!
call IsMatchesInIsolatedLine('HHTMTMTM', ['HeyHo!TickMeTockMeTuckMe', 'HeyHo!Tick_Me_Tock_Me_Tuck_Me', 'HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me', 'HeyHo!TiggleMe:TaggleMe:ToggleMe'], 'added !-matches for HHTMTMTM')
call IsMatchesInIsolatedLine('tmtmtm', [], 'no more !-match for tmtmtm')
call IsMatchesInIsolatedLine('TMTMTM', [], 'no more !-match for TMTMTM')

call vimtest#Quit()

