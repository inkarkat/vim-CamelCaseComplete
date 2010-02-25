" Test: Insertion of CamelCase words. 

let g:CamelCaseComplete_FindStartMark = '"'
runtime plugin/CamelCaseComplete.vim
source helpers/insert.vim
view CamelCaseComplete.txt
new

call Insert('fmicw', 0)
call Insert('fmiow', 0)
normal! o
call Insert('fxw', 0)
call Insert('no match:fxw', 0)

let g:CamelCaseComplete_FindStartMark = ''
normal! o- no findstart mark -
normal! o
call Insert('fxw', 0)
call Insert('no match:fxw', 0)

call vimtest#SaveOut()
call vimtest#Quit()

