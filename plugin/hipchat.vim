" ----------------------------------------------------------------------
" HipChat API operation.
" Version: 0.0.0
" Author: Phoohei
" Licence: MTI Licence
"
" HipChat API DOCUMENT: https://www.hipchat.com/docs/apiv2
" ----------------------------------------------------------------------
"
"   TODO: buffer writer
"         Display submit name and make newline between messages.
"
"  ---- Default Settings ----
"  g:HIPCHAT_DOMAIN
"  g:HIPCHAT_TOKEN

if !exists('g:HIPCHAT_TOKEN') || !exists('g:HIPCHAT_DOMAIN')
    echo '----------------------------------------------------'
    echo '[ERROR] vim-hipchat '
    echo '  You need below variabules in your `.vimrc`! *~~~~'
    echo '      `let g:HIPCHAT_TOKEN` ... Your HipChat Token.'
    echo '      `let g:HIPCHAT_DOMEIN` ... Your HipChat API Domain'
    finish
endif

let s:save_cpo = &cpoptions
set cpo&vim

" ----* Debug  *----
function! HipDebug()
    return request#getHistory(892922)
endfunction

" ----* Main process *----
command! -nargs=0 HipRoom call api#get_rooms()


let &cpo = s:save_cpo
unlet s:save_cpo
