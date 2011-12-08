" Test: Keyword delimiting. 

" Keep the completion base when no matches here. 
let g:CamelCaseComplete_FindStartMark = ''

source ../helpers/insert.vim
view CamelCaseComplete.txt
new

call SetCompletion("\<C-x>\<C-c>")

call Insert('fmicw', 0)
call Insert('--fmicw', 0)
normal! o
setlocal iskeyword+=:
call Insert('gvscocc', 0)
wincmd p | setlocal iskeyword+=: | wincmd p
call Insert('imtr', 0)
call Insert('sgvcocc', 0)
call Insert('s:gvcocc', 1)
normal! o
call Insert('elelp', 0)
wincmd p | setlocal iskeyword+=# | wincmd p
call Insert('elelp', 0)
normal! o
call Insert('ews#tt', 0)
setlocal iskeyword+=#
call Insert('ews#tt', 0)


call vimtest#SaveOut()
call vimtest#Quit()

