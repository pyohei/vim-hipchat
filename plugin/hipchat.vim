
" movet to autoload
if !exists('g:HIPCHAT')
    echo 'You have no setting hipchat URL'
    finish
endif

let s:save_cpo = &cpoptions
set cpo&vim

" Add function
"   - room name(number)
"   - from Time
"   - number of comment
"       insert list and get nessesary submot
"       
"   - message template
"       ---------------------
"       UNKNOW: 2013/12/12 11:11:11
"       message~~~~~~~
"       tefdsaffdafdaffda
function! DispHipChat()
    let l:result = webapi#http#get(g:HIPCHAT)
    let l:contents = webapi#json#decode(result.content)
    let l:items = l:contents.items
    for l:item in l:items
        if type(l:item.from) == 1
            echo l:item.from
        else
            echo l:item.from.name
        endif
        echo l:item.date
        echo l:item.message
        echo '--------------------------------------'
    endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
