function! s:SetUpAutoCommands()
   " TEMPORARY
  au VimEnter *
    \ :silent exec "!kill -s SIGWINCH $PPID"

  au CursorHold  *
    \ checktime

  au BufEnter *
    \ if empty(&ft) && &buftype != 'terminal' | set filetype=markdown | endif |
    \ if &buftype == 'terminal' | set filetype=noft | endif |

  au! User GoyoLeave
    \ hi Normal guibg=NONE ctermbg=NONE


  function! PageClose(page_alternate_bufnr)
    bd!
    if bufnr('%') == a:page_alternate_bufnr && mode('%') == 'n'
      norm a
    endif
  endfunction
  au User PageOpen
    \ | exe 'map <buffer> <C-c> :call PageClose(b:page_alternate_bufnr)<CR>'
    \ | exe 'tmap <bufer> <C-c> :call PageClose(b:page_alternate_bufnr)<CR>'

  aug VMlens
      au!
      au User visual_multi_start lua require('vmlens').start()
      au User visual_multi_exit lua require('vmlens').exit()
  aug END
endfunction



call s:SetUpAutoCommands()
