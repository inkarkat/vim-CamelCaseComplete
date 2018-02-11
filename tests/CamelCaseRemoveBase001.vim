" Test: Removal of CamelCase base when no match. 

let g:CamelCaseComplete_FindStartMark = 'z'
source ../helpers/insert.vim
view CamelCaseComplete.txt
new

call SetCompletion("\<C-x>\<C-c>")

call Insert('Fmicw', 0)
call Insert('Fmiow', 0)
normal! o
call Insert('Fxw', 0)
call Insert('no match:Fxw', 0)

let g:CamelCaseComplete_FindStartMark = ''
normal! o- no findstart mark -
normal! o
call Insert('Fxw', 0)
call Insert('no match:Fxw', 0)

call vimtest#SaveOut()
call vimtest#Quit()

