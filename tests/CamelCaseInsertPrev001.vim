" Test: Insertion of previous matches of CamelCase words.

let g:CompleteHelper_IsDefaultToBackwardSearch = 1
source ../helpers/insert.vim
view CamelCaseComplete.txt
new

call SetCompletion("\<C-x>\<C-c>")

call Insert('Fmicw', 0)
call Insert('Fmiow', 0)
normal! o
call Insert('Fmiw', 1)
call Insert('Fmiw', 2)
normal! o
call Insert('uCN', 1)
call Insert('uCN', 2)
normal! o
call Insert('g:Fmicw', 0)
call Insert('s:Fmicw', 0)
normal! o||
normal! ^
call Insert('Fmicw', 0)

call vimtest#SaveOut()
call vimtest#Quit()

