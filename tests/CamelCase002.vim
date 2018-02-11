" Test: Completion base includes non-alphabetic characters. 

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(15) 
edit CamelCaseComplete.txt

set completefunc=CamelCaseComplete#CamelCaseComplete

setlocal iskeyword+=:
call IsMatchesInIsolatedLine('TMTMTM', ['TickMeTockMeTuckMe', 'Tick_Me_Tock_Me_Tuck_Me', 'TiggleMe:TaggleMe:ToggleMe', 'Tiggle_Me:Taggle_Me:Toggle_Me'], '4 strict matches for TMTMTM')
call IsMatchesInIsolatedLine('TM:TM:TM', ['TiggleMe:TaggleMe:ToggleMe', 'Tiggle_Me:Taggle_Me:Toggle_Me'], '2 strict matches for TM:TM:TM')

setlocal iskeyword+=!,.,@-@
call IsMatchesInIsolatedLine('@HH!Tmtmtm', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe'], 'strict matches for @HH!Tmtmtm')
call IsMatchesInIsolatedLine('@Hh!TM', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @Hh!TM')
call IsMatchesInIsolatedLine('@Hh!', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @Hh!')
call IsMatchesInIsolatedLine('@HH', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @HH')

call IsMatchesInIsolatedLine('@H!Tmtmtm', ['@Hallo!TiggleMe:TaggleMe:ToggleMe'], 'strict matches for @H!Tmtmtm')
call IsMatchesInIsolatedLine('@H!TM', ['@Hallo!TiggleMe:TaggleMe:ToggleMe', '@Hallo!Tiggle_Me:Taggle_Me:Toggle_Me', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @H!TM')
" Note: the '@Hello!...' identifiers do NOT match, because the single 'h' anchor
" requires an actual CamelCaseWord or underscore_word match at that position.
" Only when more anchors ('tm...') are given will the 'h' match a single
" CamelCase fragment, too. 
call IsMatchesInIsolatedLine('@H', ['@Hallo!TiggleMe:TaggleMe:ToggleMe', '@Hallo!Tiggle_Me:Taggle_Me:Toggle_Me', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @H')
call IsMatchesInIsolatedLine('!B!wmwmwm', ['!Boy!wiggle_me:waggle_me:woggle_me'], 'strict match for !B!wmwmwm')

call IsMatchesInIsolatedLine('@!Tmtmtm', ['@...!TiggleMe:TaggleMe:ToggleMe'], 'strict match for @!Tmtmtm')
call IsMatchesInIsolatedLine('@!Tm', ['@...!TiggleMe:TaggleMe:ToggleMe', '@Hallo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe'], 'relaxed matches for @!Tm')
call IsMatchesInIsolatedLine('@!TM', ['@...!TiggleMe:TaggleMe:ToggleMe', '@Hallo!TiggleMe:TaggleMe:ToggleMe', '@Hallo!Tiggle_Me:Taggle_Me:Toggle_Me', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @!TM')
call IsMatchesInIsolatedLine('@!', ['@...!TiggleMe:TaggleMe:ToggleMe'], 'strict match for @!')
setlocal iskeyword-=.
call IsMatchesInIsolatedLine('@!', ['@Hallo!TiggleMe:TaggleMe:ToggleMe', '@Hallo!Tiggle_Me:Taggle_Me:Toggle_Me', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @!')

call vimtest#Quit()

