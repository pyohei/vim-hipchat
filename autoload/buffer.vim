" ----------------------------------------------------------------------
" hipchat plugin >> buffer
" Version: 0.0.0
" Author: Shohei Mukai
" Licence: MTI Licence
"
" HipChat API DOCUMENT: https://www.hipchat.com/docs/apiv2
" ----------------------------------------------------------------------
" 

let s:save_cpo = &cpoptions
set cpo&vim

function! SetLocalBuf()
    return
endfunction

function! buffer#open()
    enew
    call s:set_buffer_default()
endfunction

function! s:set_buffer_default()
    nnoremap <buffer><silent>q <expr>:bd!<CR>
endfunction

function! buffer#set_buffer()
    setlocal nomodifiable
    setlocal readonly
endfunction

function! buffer#write()
    return
endfunction

function! buffer#close()
    return
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
