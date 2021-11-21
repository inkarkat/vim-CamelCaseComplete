" Test: Completion with augmented iskeyword.

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(8)
edit CamelCaseComplete.txt

set completefunc=CamelCaseComplete#CamelCaseComplete

call IsMatchesInIsolatedLine('Tmtmtm', ['TickMeTockMeTuckMe'], 'single strict match for Tmtmtm')
call IsMatchesInIsolatedLine('TMTMTM', ['TickMeTockMeTuckMe', 'Tick_Me_Tock_Me_Tuck_Me'], 'two strict matches for TMTMTM')

setlocal iskeyword+=:
call IsMatchesInIsolatedLine('Tmtmtm', ['TickMeTockMeTuckMe', 'TiggleMe:TaggleMe:ToggleMe'], 'added :-match for Tmtmtm')
call IsMatchesInIsolatedLine('TMTMTM', ['TickMeTockMeTuckMe', 'Tick_Me_Tock_Me_Tuck_Me', 'TiggleMe:TaggleMe:ToggleMe', 'Tiggle_Me:Taggle_Me:Toggle_Me'], 'added :-matches for TMTMTM')

call IsMatchesInIsolatedLine('HHTMTMTM', [], 'no strict matches for HHTMTMTM')
setlocal iskeyword+=!
call IsMatchesInIsolatedLine('HHTMTMTM', ['HeyHo!TickMeTockMeTuckMe', 'HeyHo!Tick_Me_Tock_Me_Tuck_Me', 'HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me', 'HeyHo!TiggleMe:TaggleMe:ToggleMe'], 'added !-matches for HHTMTMTM')
call IsMatchesInIsolatedLine('Tmtmtm', [], 'no more !-match for Tmtmtm')
call IsMatchesInIsolatedLine('TMTMTM', [], 'no more !-match for TMTMTM')

call vimtest#Quit()
