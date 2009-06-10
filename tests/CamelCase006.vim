" Test: Completion base includes non-alphabetic characters. 

runtime plugin/CamelCaseComplete.vim
source helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(9) 
edit CamelCaseComplete.txt

call SetCompletion("\<C-x>\<C-c>")

setlocal iskeyword+=:
call IsMatchesInIsolatedLine('TMTMTM', ['TickMeTockMeTuckMe', 'Tick_Me_Tock_Me_Tuck_Me', 'TiggleMe:TaggleMe:ToggleMe', 'Tiggle_Me:Taggle_Me:Toggle_Me'], '4 strict matches for TMTMTM')
call IsMatchesInIsolatedLine('TM:TM:TM', ['TiggleMe:TaggleMe:ToggleMe', 'Tiggle_Me:Taggle_Me:Toggle_Me'], '2 strict matches for TM:TM:TM')

setlocal iskeyword+=!
setlocal iskeyword+=@-@
call IsMatchesInIsolatedLine('@O!tmtmtm', [], 'no matches for @O!tmtmtm (Ola is no CamelCase)')
call IsMatchesInIsolatedLine('@HH!tmtmtm', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe'], 'strict matches for @HH!tmtmtm')
call IsMatchesInIsolatedLine('@!tm', [], 'no matches for @!tm (no wildcard between @!)')
call IsMatchesInIsolatedLine('@!', [], 'no matches for @! (no wildcard between @!)')
call IsMatchesInIsolatedLine('@hh!tm', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @hh!tm')
call IsMatchesInIsolatedLine('@hh!', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @hh!')
call IsMatchesInIsolatedLine('@HH', ['@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @HH')

call IsMatchesInIsolatedLine('@H!tmtmtm', ['@Hallo!TiggleMe:TaggleMe:ToggleMe'], 'strict matches for @H!tmtmtm')
call IsMatchesInIsolatedLine('@h!tm', ['@Hallo!TiggleMe:TaggleMe:ToggleMe', '@Hallo!Tiggle_Me:Taggle_Me:Toggle_Me', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @h!tm')
call IsMatchesInIsolatedLine('@h!', ['@Hallo!TiggleMe:TaggleMe:ToggleMe', '@Hallo!Tiggle_Me:Taggle_Me:Toggle_Me', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @h!')
call IsMatchesInIsolatedLine('@H', ['@Hallo!TiggleMe:TaggleMe:ToggleMe', '@Hallo!Tiggle_Me:Taggle_Me:Toggle_Me', '@HeyHo!TickMeTockMeTuckMe', '@HeyHo!Tick_Me_Tock_Me_Tuck_Me', '@HeyHo!TiggleMe:TaggleMe:ToggleMe', '@HeyHo!Tiggle_Me:Taggle_Me:Toggle_Me'], 'relaxed matches for @H')

call vimtest#Quit()

