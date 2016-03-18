" ----------------------------------------------------------------------
" hipchat plugin >> api
" Version: 0.0.0
" Author: Shohei Mukai
" Licence: MTI Licence
"
" HipChat API DOCUMENT: https://www.hipchat.com/docs/apiv2
" ----------------------------------------------------------------------

function! api#get_rooms()
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
    nnoremap <buffer><silent><CR> :call api#get_messages(getline("."))<CR>
    call buffer#set_buffer()
    nnoremap <buffer><silent>q <expr>:bd!<CR>
    setlocal modifiable
endfunction

function! api#get_messages(cur_line) " setting with argment
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
        let l:submit['messages'] = split(strtrans(l:item.message), '\^@')
        " let l:submit['message'] = l:item.message
        call insert(l:submits, l:submit, 0)
    endfor
    let l:num = 1 
    "silent execute 'silent edit'
    enew
    "execute 'buffer' . 1
    "execute bufwinnr(1) . 'wincmd w'
    
    nnoremap <buffer><silent>q <expr>:bd!<CR>
    "nnoremap <buffer><silent>q <expr>:wincmd =<CR>
    for l:s in l:submits
        "if a:count == l:num
        "    break
        " endif
        " treat for JIRA checket!

        " Header
        call setline(l:num, '-----------------')
        let l:num += 1

        " Name
        let l:name_line = '### ' . l:s.name . ' ### (' . l:s.date . ')'
        call setline(l:num, l:name_line) 
        let l:num += 1

        " Name
        for l:message in l:s.messages
            if l:s.name == 'JIRA'
                " Check if chicket name or not
                let l:pat = '^<img'
                if match(l:message, l:pat) == -1
                    break
                endif
                let l:jirastr = '<div>' . l:message . '</div>'
                let l:jira_trees = webapi#xml#parse(l:jirastr)
                let l:chicket_name = l:jira_trees.child[2].child[0].child[0]
                call setline(l:num, l:chicket_name)
                let l:num += 1
            elseif l:s.name == 'Bitbucket'
                let l:jirastr = '<div>' . l:message . '</div>'
                let l:hoge = webapi#xml#parse(l:jirastr)
                let l:branch_name = l:hoge.child[2].attr.href
                let l:message = 'REPOGITORY: ' . l:branch_name
                echo l:message
                call setline(l:num, l:message)
                let l:num += 1
                break
            elseif l:s.name == 'Jenkins'
                call setline(l:num, l:message)
                let l:num += 1
                break
            else
                call setline(l:num, l:message)
                let l:num += 1
            endif
        endfor
    endfor
    setlocal modifiable
    setlocal readonly
endfunction

