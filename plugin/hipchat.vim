
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
function! DispHipChat(count)
    let l:result = webapi#http#get(g:HIPCHAT)
    let l:contents = webapi#json#decode(result.content)
    let l:items = l:contents.items
    let l:submits = []
    for l:item in l:items
        let l:submit = {}
        if type(l:item.from) == 1
            let l:submit['name'] = l:item.from
        else
            let l:submit['name'] = l:item.from.name
        endif
        let l:submit['date'] =  l:item.date
        let l:submit['message'] = l:item.message
        call insert(l:submits, l:submit, 0)
    endfor
    let l:num = 0 
    for l:s in l:submits
        if a:count == l:num
            break
        endif
        let l:num += 1
        echo l:s.name
        echon ':' . l:s.date
        echo l:s.message
        echo '--------------------------------------'
    endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
