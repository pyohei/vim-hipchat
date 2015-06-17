"
" Hip Chat API document is
"   https://www.hipchat.com/docs/apiv2

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
        "echo l:s.name
        "echon ':' . l:s.date
        "echo l:s.message
        "echo '--------------------------------------'
    endfor
    setlocal nomodifiable
    setlocal readonly
endfunction

function! MakeUrlBase()
    let l:url = 'https://' . g:HIPCHAT_DOMAIN
    return l:url
endfunction

function! OpenBuffer()
    let l:buf_name = 'hip-rooms'
    execute 'buffer' . 1
    call setline(1, 'hogehoge')
    echo fnamemodify(bufname('%s'), ':p')
endfunction

function! GetRooms()
    let l:header_len = 12
    let l:contents = request#getRooms()
    enew
    nnoremap <buffer><silent>q <expr>:bd!<CR>
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
    setlocal nomodifiable
    setlocal readonly
endfunction

function! GetRoomMessage(cur_line)
    let l:id = split(a:cur_line, " ")[0]
    let l:url = MakeUrlBase()
    let l:url .= '/v2/room/' . l:id . '/history/latest?auth_token=' . g:HIPCHAT_TOKEN
    return l:url
endfunction

function! TmpDispHipChat(cur_line) " setting with argment
    let l:url = GetRoomMessage(a:cur_line)
    let l:result = webapi#http#get(l:url)
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
        "if a:count == l:num
        "    break
        " endif
        " treat for JIRA checket!

        call setline(l:num, l:s.message)
        let l:num += 1
        "echo l:s.name
        "echon ':' . l:s.date
        "echo l:s.message
        "echo '--------------------------------------'
    endfor
    setlocal nomodifiable
    setlocal readonly
endfunction

function! HipDebug()
    return request#getRooms()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
