" Test: Completion base includes non-alphabetic characters. 

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(16) 
edit CamelCaseComplete.txt

set completefunc=CamelCaseComplete#CamelCaseComplete

setlocal iskeyword+=:
call IsMatchesInIsolatedLine('TMTMTM', ['TickMeTockMeTuckMe', 'Tick_Me_Tock_Me_Tuck_Me', 'TiggleMe:TaggleMe:ToggleMe', 'Tiggle_Me:Taggle_Me:Toggle_Me'], '4 strict matches for TMTMTM')
call IsMatchesInIsolatedLine('TM:TM:TM', ['TiggleMe:TaggleMe:ToggleMe', 'Tiggle_Me:Taggle_Me:Toggle_Me'], '2 strict matches for TM:TM:TM')

setlocal iskeyword+=!,.,@-@
call IsMatchesInIsolatedLine('@HH!tmtmtm', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe'], 'strict matches for @HH!tmtmtm')
call IsMatchesInIsolatedLine('@hh!tm', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @hh!tm')
call IsMatchesInIsolatedLine('@hh!', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @hh!')
call IsMatchesInIsolatedLine('@HH', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @HH')

call IsMatchesInIsolatedLine('@H!tmtmtm', ['@Hallo!TiggleMe:TaggleMe:ToggleMe'], 'strict matches for @H!tmtmtm')
call IsMatchesInIsolatedLine('@h!tm', ['@Hallo!TiggleMe:TaggleMe:ToggleMe', '@Hallo!Tiggle_Me:Taggle_Me:Toggle_Me', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @h!tm')
" Note: the '@Hello!...' identifiers do NOT match, because the single 'h' anchor
" requires an actual CamelCaseWord or underscore_word match at that position.
" Only when more anchors ('tm...') are given will the 'h' match a single
" CamelCase fragment, too. 
call IsMatchesInIsolatedLine('@h!', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @h!')
call IsMatchesInIsolatedLine('@H', ['@Hallo!TiggleMe:TaggleMe:ToggleMe', '@Hallo!Tiggle_Me:Taggle_Me:Toggle_Me', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @H')
call IsMatchesInIsolatedLine('!b!wmwmwm', ['!Boy!wiggle_me:waggle_me:woggle_me'], 'strict match for !b!wmwmwm')

call IsMatchesInIsolatedLine('@!tmtmtm', ['@...!TiggleMe:TaggleMe:ToggleMe'], 'strict match for @!tmtmtm')
call IsMatchesInIsolatedLine('@!tm', ['@...!TiggleMe:TaggleMe:ToggleMe', '@Hallo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe'], 'relaxed matches for @!tm')
call IsMatchesInIsolatedLine('@!TM', ['@...!TiggleMe:TaggleMe:ToggleMe', '@Hallo!TiggleMe:TaggleMe:ToggleMe', '@Hallo!Tiggle_Me:Taggle_Me:Toggle_Me', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @!TM')
call IsMatchesInIsolatedLine('@!', ['@...!TiggleMe:TaggleMe:ToggleMe'], 'strict match for @!')
setlocal iskeyword-=.
call IsMatchesInIsolatedLine('@!', ['@Hallo!TiggleMe:TaggleMe:ToggleMe', '@Hallo!Tiggle_Me:Taggle_Me:Toggle_Me', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @!')

call vimtest#Quit()

