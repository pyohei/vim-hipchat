"
" Hip Chat API document is
"   https://www.hipchat.com/docs/apiv2

let s:save_cpo = &cpoptions
set cpo&vim

function! request#getRooms()
    return
endfunction

function! request#getHistory()
    return
endfunction

function! MakeUrlBase()
    let l:url = 'https://' . g:HIPCHAT_DOMAIN
    return l:url
endfunction

function! s:add_token()
    return
endfunction

function! s:open_url()
    return
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
