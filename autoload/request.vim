"
" 
" Request functions.

let s:save_cpo = &cpoptions
set cpo&vim

function! request#getRooms()
    let l:room_url = '/v2/room'
    let l:baseurl = s:make_url_base()
    let l:baseurl .=  l:room_url
    let l:url = s:add_token(l:baseurl)
    let l:response= s:open_url(l:url)
    let l:result = s:decode(l:response.content)
    return l:result
endfunction

function! request#getHistory(id)
    let l:baseurl = s:make_url_base()
    let l:baseurl .= '/v2/room/' . a:id . '/history/latest'
    let l:url = s:add_token(l:baseurl)
    let l:response= s:open_url(l:url)
    let l:result = s:decode(l:response.content)
    return l:result
endfunction

function! s:make_url_base()
    let l:url = 'https://' . g:HIPCHAT_DOMAIN
    return l:url
endfunction

function! s:add_token(url)
    let l:url = a:url . '?auth_token=' . g:HIPCHAT_TOKEN
    return l:url
endfunction

function! s:open_url(url)
    let l:result = webapi#http#get(a:url)
    return l:result
endfunction

function! s:decode(response)
    let l:result = webapi#json#decode(a:response)
    return l:result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
