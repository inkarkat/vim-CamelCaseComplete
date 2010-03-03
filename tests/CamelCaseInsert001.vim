" Test: Insertion of CamelCase words. 

source ../helpers/insert.vim
view CamelCaseComplete.txt
new

call Insert('fmicw', 0)
call Insert('fmiow', 0)
normal! o
call Insert('fmiw', 1)
call Insert('fmiw', 2)
normal! o
call Insert('uCN', 1)
call Insert('uCN', 2)
normal! o
call Insert('g:fmicw', 0)
call Insert('s:fmicw', 0)
normal! o||
normal! ^
call Insert('fmicw', 0)

call vimtest#SaveOut()
call vimtest#Quit()

