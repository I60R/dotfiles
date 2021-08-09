function! s:SetUpKeyMappings()

  function! s:common()

    nmap            <Space>                     <Nop>
    nmap <silent>   <Space><Space>              :Goyo<CR>
    nmap <silent>   <Space>                     <Leader>

    tnoremap         <Esc><Esc><Esc>  <C-\><C-n>M
    tnoremap         <Esc><Esc>       <C-\><C-n>
    map <silent>     <Esc><Esc>       <Esc>:call OnEscape()<CR>

    function! OnEscape()
      silent! TagbarClose
      silent! Goyo!
      helpclose
      lclose
    endfunction

    map              <M-`>            :BufferLinePick<CR>

    map              f                <Cmd>lua require('hop').hint_char1()<CR>
    map              F                <Cmd>lua require('hop').hint_lines()<CR>

    nmap <expr>      MM               ":setl so=" . ((&so == 0) ? 999 : 0) . "\<CR>M"

    nmap             <Leader>         zz

    noremap <silent> n                <Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>
    noremap <silent> N                <Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>
    noremap          *                *<Cmd>lua require('hlslens').start()<CR>
    noremap          #                #<Cmd>lua require('hlslens').start()<CR>
    noremap          g*               g*<Cmd>lua require('hlslens').start()<CR>
    noremap          g#               g#<Cmd>lua require('hlslens').start()<CR>
  endfunction()

  function! s:editing()
    nnoremap         U                <C-r>

    nmap             t                :Switch<CR>

    imap             <Del>            <Esc><Left>v?\(\S\\|\%^\)<CR><Right>x:noh<CR>i

    nmap             \|               <Plug>(EasyAlign)
    xmap             \|               <Plug>(EasyAlign)
  endfunction

  function! s:complete()
    inoremap <silent><expr> <C-Space> compe#complete()
    inoremap <silent><expr> <C-e>     compe#close('<C-e>')
    inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
    inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
  endfunction


  function! s:shortcut()
    map              <M-q>            :b # \| bd #<CR>
    map              <M-Q>            :b # \| bd! #<CR>
    tmap             <M-q>            <Esc><Esc>:b # \| bd #<CR>
    tmap             <M-Q>            <Esc><Esc>:b # \| bd! $<CR>

    nmap             <M-Right>        :bnext<CR>
    nmap             <M-Left>         :bprevious<CR>
    tmap             <M-Right>        <Esc><Esc>:bnext<CR>
    tmap             <M-Left>         <Esc><Esc>:bprevious<CR>

    map              <M-1>            <Plug>lightline#bufferline#go(1)
    map              <M-2>            <Plug>lightline#bufferline#go(2)
    map              <M-3>            <Plug>lightline#bufferline#go(3)
    map              <M-4>            <Plug>lightline#bufferline#go(4)
    map              <M-5>            <Plug>lightline#bufferline#go(5)
    map              <M-6>            <Plug>lightline#bufferline#go(6)
    map              <M-7>            <Plug>lightline#bufferline#go(7)
    map              <M-8>            <Plug>lightline#bufferline#go(8)
    map              <M-9>            <Plug>lightline#bufferline#go(9)
    map              <M-0>            <Plug>lightline#bufferline#go(10)
    tmap             <M-1>            <Esc><Esc><Plug>lightline#bufferline#go(1)
    tmap             <M-2>            <Esc><Esc><Plug>lightline#bufferline#go(2)
    tmap             <M-3>            <Esc><Esc><Plug>lightline#bufferline#go(3)
    tmap             <M-4>            <Esc><Esc><Plug>lightline#bufferline#go(4)
    tmap             <M-5>            <Esc><Esc><Plug>lightline#bufferline#go(5)
    tmap             <M-6>            <Esc><Esc><Plug>lightline#bufferline#go(6)
    tmap             <M-7>            <Esc><Esc><Plug>lightline#bufferline#go(7)
    tmap             <M-8>            <Esc><Esc><Plug>lightline#bufferline#go(8)
    tmap             <M-9>            <Esc><Esc><Plug>lightline#bufferline#go(9)
    tmap             <M-0>            <Esc><Esc><Plug>lightline#bufferline#go(10)

    map              <F10>            :TagbarToggle<CR>

    nmap <silent>    <F3>             <Plug>(ale_next_wrap)
    nmap <silent>    <S-F3>           <Plug>(ale_previous_wrap)
  endfunction

  function! s:camelcase()
    map              w                <Plug>CamelCaseMotion_w
    omap            iw                <Plug>CamelCaseMotion_iw
    xmap            iw                <Plug>CamelCaseMotion_iw
    omap            aw                <Plug>CamelCaseMotion_aw
    xmap            aw                <Plug>CamelCaseMotion_aw
    onoremap        iW                iw
    xnoremap        iW                iw
    nnoremap         W                :call SkipSymbols("w")<CR>
    onoremap         W                :call SkipSymbols("w")<CR>
    xnoremap         W                :call SkipSymbols("w")<CR>

    map              e                <Plug>CamelCaseMotion_b
    omap            ie                <Plug>CamelCaseMotion_ib
    xmap            ie                <Plug>CamelCaseMotion_ib
    omap            ae                <Plug>CamelCaseMotion_ab
    xmap            ae                <Plug>CamelCaseMotion_ab
    onoremap        iE                ib
    xnoremap        iE                ib
    nnoremap         E                :call SkipSymbols("b")<CR>
    onoremap         E                :call SkipSymbols("b")<CR>
    xnoremap         E                :call SkipSymbols("b")<CR>

    map              b                <Plug>CamelCaseMotion_e
    omap            ib                <Plug>CamelCaseMotion_ie
    xmap            ib                <Plug>CamelCaseMotion_ie
    omap            ab                <Plug>CamelCaseMotion_ae
    xmap            ab                <Plug>CamelCaseMotion_ae
    onoremap        iB                ie
    xnoremap        iB                if
    nnoremap         B                :call SkipSymbols("e")<CR>
    onoremap         B                :call SkipSymbols("e")<CR>
    xnoremap         B                :call SkipSymbols("e")<CR>

    function! SkipSymbols(motion)
      let b:iskeyword_backup=&iskeyword
      let &iskeyword=""
      exe ':call feedkeys("' . a:motion . ':let &isk=b:iskeyword_backup\<CR>", "n")'
    endfunction
  endfunction

  function! s:textobject()
    omap             an               <Plug>(textobj-lastpat-n)
    omap             aN               <Plug>(textobj-lastpat-N)

    omap             ai               <Plug>(textobj-indent-a)
    omap             ii               <Plug>(textobj-indent-i)
  endfunction

  call s:common()
  call s:editing()
  call s:complete()
  call s:shortcut()
  call s:camelcase()
  call s:textobject()
endfunction


function! s:SetUpAutoCommands()
   " TEMPORARY
  au VimEnter *
    \ :silent exec "!kill -s SIGWINCH $PPID"

  au CursorHold  *
    \ checktime

  au BufEnter *
    \ if index(g:better_whitespace_filetypes_blacklist, &ft) < 0 | exec 'EnableStripWhitespaceOnSave' | endif |
    \ if empty(&ft) && &buftype != 'terminal' | set filetype=markdown | endif |
    \ if &buftype == 'terminal' | set filetype=noft | endif |
    \ :ColorizerAttachToBuffer

  au! CompleteDone *
    \ if pumvisible() == 0 | pclose | endif

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

  if &diff
    let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
  endif
endfunction



call s:SetUpKeyMappings()
call s:SetUpAutoCommands()
