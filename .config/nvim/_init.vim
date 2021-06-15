function! s:SetUpKeyMappings()

  nmap            <Space>                     <Nop>
  nmap <silent>   <Space><Space>              :Goyo<CR>
  nmap <silent>   <Space>                     <Leader>

  function! s:common()
    tnoremap         <Esc><Esc><Esc>  <C-\><C-n>M
    tnoremap         <Esc><Esc>       <C-\><C-n>
    map <silent>     <Esc><Esc>       <Esc>:call OnEscape()<CR>
    function! OnEscape()
      silent! TagbarClose
      silent! Goyo!
      helpclose
      lclose
    endfunction

    map              <M-`>            :Buffers<CR>

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
    " NOTE: Order is important. You can't lazy loading lexima.vim.
    let g:lexima_no_default_rules = v:true
    call lexima#set_default_rules()
    inoremap <silent><expr> <C-Space> compe#complete()
    inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
    inoremap <silent><expr> <C-e>     compe#close('<C-e>')
    inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
    inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

    lua << EOF
    local t = function(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col('.') - 1
        if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            return true
        else
            return false
        end
    end

    -- Use (s-)tab to:
    --- move to prev/next item in completion menuone
    --- jump to prev/next snippet's placeholder
    _G.tab_complete = function()
      if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
      elseif vim.fn.call("vsnip#available", {1}) == 1 then
        return t "<Plug>(vsnip-expand-or-jump)"
      elseif check_back_space() then
        return t "<Tab>"
      else
        return vim.fn['compe#complete']()
      end
    end
    _G.s_tab_complete = function()
      if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
      elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
      else
        return t "<S-Tab>"
      end
    end

    vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF
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



function! s:SetUpAppearance()
  setglobal termguicolors
  setglobal guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

  syntax enable

  function! GitbranchFunction()
    return winwidth(0) > 90 ? (&buftype != 'terminal' ? gitbranch#name() : '') : ''
  endfunction

  function! FiletypeFunction()
    return winwidth(0) > 80 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  endfunction

  function! FileformatFunction()
    return winwidth(0) > 60 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  endfunction

  let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'enable': {
    \   'statusline': 0,
    \   'tabline': 1
    \ },
    \ 'tabline': {
    \   'left': [ [ 'bufnum' ], [ 'buffers' ], ],
    \   'right': [ [ 'fileencoding', 'fileformat' ], [ 'gitbranch', 'filetype' ] ],
    \ },
    \ 'component_expand': {
    \   'buffers': 'lightline#bufferline#buffers',
    \ },
    \ 'component_type': {
    \   'buffers': 'tabsel',
    \ },
    \ 'component_function': {
    \   'fileformat': 'FileformatFunction',
    \   'filetype': 'FiletypeFunction',
    \   'gitbranch': 'GitbranchFunction'
    \ },
    \ 'tabline_separator': {
    \    'left': ' ',
    \    'right': '',
    \ },
    \ 'tabline_subseparator': {
    \    'left': '',
    \    'right': '',
    \ }
  \}
  let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
  let s:palette.tabline.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]

  let g:lightline#bufferline#number_map = { 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴', 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}
  let g:lightline#bufferline#show_number = 2
  let g:lightline#bufferline#number_separator = ''
  let g:lightline#bufferline#enable_devicons = 1
  let g:lightline#bufferline#unicode_symbols = 1

  let g:tokyonight_transparent = 1
  let g:tokyonight_style = "night"

  colorscheme tokyonight " onedark . apprentice . tangoshady

  hi Normal ctermbg=NONE guibg=NONE

  hi clear SignColumn
endfunction

call s:SetUpKeyMappings()
call s:SetUpAutoCommands()
call s:SetUpAppearance()
