"
" Hip Chat API document is
"   https://www.hipchat.com/docs/apiv2
"
"   TODO: buffer writer
"         setting local buffer
"         make main process
"

if !exists('g:HIPCHAT')
    echo 'You have no setting hipchat URL'
    finish
endif

let s:save_cpo = &cpoptions
set cpo&vim

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
    "silent execute 'silent edit'
    enew
    "execute 'buffer' . 1
    "execute bufwinnr(1) . 'wincmd w'
    nnoremap <buffer><silent>q <expr>:bd!<CR>
    for l:s in l:submits
        if a:count == l:num
            break
        endif
        call setline(l:num, l:s.message)
        let l:num += 1
    endfor
    setlocal nomodifiable
    setlocal readonly
endfunction

function! GetRooms()
    let l:header_len = 12
    let l:contents = request#getRooms()
    call buffer#open()
    let l:num = 0
    for l:room in l:contents['items']
        "let l:line = strlen(substitute(l:room.name, ".", "x", "g")) . l:room.name
        let l:line = l:room.id
        let l:id_len = len(l:room.id)
        let l:space_num = l:header_len - l:id_len
        while l:space_num >= 0
            let l:line .= " "
            let l:space_num -= 1
        endwhile
        let l:line .= l:room.name
        call setline(l:num, l:line)
        let l:num += 1
    endfor
    nnoremap <buffer><silent><CR> :call TmpDispHipChat(getline("."))<CR>
    call buffer#set_buffer()
endfunction

function! TmpDispHipChat(cur_line) " setting with argment
    let l:id = split(a:cur_line, " ")[0]
    let l:contents = request#getHistory(l:id)
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
    "silent execute 'silent edit'
    enew
    "execute 'buffer' . 1
    "execute bufwinnr(1) . 'wincmd w'
    nnoremap <buffer><silent>q <expr>:bd!<CR>
    for l:s in l:submits
        "if a:count == l:num
        "    break
        " endif
        " treat for JIRA checket!

        call setline(l:num, l:s.message)
        let l:num += 1
    endfor
    setlocal nomodifiable
    setlocal readonly
endfunction

function! HipDebug()
    return request#getHistory(892922)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
