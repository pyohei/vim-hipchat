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
    execute 'buffer' . 1
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
    let l:baseurl = MakeUrlBase()
    let l:url = l:baseurl . '/v2/room'
    let l:url = l:url . '?auth_token=' . g:HIPCHAT_TOKEN
    let l:result = webapi#http#get(l:url)
    let l:contents = webapi#json#decode(l:result.content)
    for l:room in l:contents['items']
        echo 'id: ' . l:room.id
        echo 'name: ' . l:room.name
    endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
