" Test: Keyword delimiting of next matches.

" Keep the completion base when no matches here.
let g:CamelCaseComplete_FindStartMark = ''

let g:CompleteHelper_IsDefaultToBackwardSearch = 0
runtime tests/helpers/insert.vim
view CamelCaseComplete.txt
new

call SetCompletion("\<C-x>\<C-c>")

call Insert('Fmicw', 0)
call Insert('--Fmicw', 0)
normal! o
setlocal iskeyword+=:
call Insert('Gvscocc', 0)
wincmd p | setlocal iskeyword+=: | wincmd p
call Insert('imtr', 0)
call Insert('sGvcocc', 0)
call Insert('s:Gvcocc', 1)
normal! o
call Insert('Elelp', 0)
wincmd p | setlocal iskeyword+=# | wincmd p
call Insert('Elelp', 0)
normal! o
call Insert('ews#Tt', 0)
setlocal iskeyword+=#
call Insert('Ews#Tt', 0)

call vimtest#SaveOut()
call vimtest#Quit()
