function! s:SetUpPlugins()
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('Th3Whit3Wolf/one-nvim')
  call minpac#add('ryanoasis/vim-devicons')
  call minpac#add('itchyny/vim-highlighturl')

  call minpac#add('itchyny/lightline.vim')
    \| call minpac#add('mgee/lightline-bufferline')
    \| call minpac#add('itchyny/vim-gitbranch')

  call minpac#add('junegunn/goyo.vim')
  call minpac#add('kopischke/vim-stay')
  call minpac#add('junegunn/vim-peekaboo')

  call minpac#add('machakann/vim-highlightedyank')
  call minpac#add('DanilaMihailov/beacon.nvim')
  call minpac#add('norcalli/nvim-colorizer.lua')

  call minpac#add('inkarkat/vim-ingo-library')
    \| call minpac#add('inkarkat/vim-mark')

  call minpac#add('kana/vim-repeat')
  call minpac#add('junegunn/vim-slash')
  call minpac#add('kana/vim-operator-user')
    \| call minpac#add('rhysd/vim-operator-surround')

  call minpac#add('machakann/vim-sandwich')
  call minpac#add('kana/vim-textobj-user')
    \| call minpac#add('wellle/targets.vim')
    \| call minpac#add('rhysd/vim-textobj-anyblock')
    \| call minpac#add('rhysd/vim-textobj-conflict')
    \| call minpac#add('glts/vim-textobj-comment')
    \| call minpac#add('kana/vim-textobj-lastpat')
    \| call minpac#add('kana/vim-textobj-indent')
    \| call minpac#add('kana/vim-textobj-line')
    \| call minpac#add('I60R/vim-textobj-nonwhitespace')


  call minpac#add('hrsh7th/nvim-compe')
    \| call minpac#add('hrsh7th/vim-vsnip')
    \| call minpac#add('neovim/nvim-lsp')
    \| call minpac#add('tamago324/compe-zsh')
    \| call minpac#add('GoldsteinE/compe-latex-symbols')


  call minpac#add('lotabout/skim', { 'do': '!./install' })
  call minpac#add('lotabout/skim.vim')
  call minpac#add('aperezdc/vim-template')

  call minpac#add('w0rp/ale')
  call minpac#add('ntpeters/vim-better-whitespace')
  call minpac#add('tpope/vim-sleuth')
  call minpac#add('tpope/vim-characterize')
  call minpac#add('dylanaraps/root.vim')

  call minpac#add('easymotion/vim-easymotion')
  call minpac#add('bkad/CamelCaseMotion')

  call minpac#add('mg979/vim-visual-multi', { 'branch': 'test' })
  call minpac#add('tommcdo/vim-exchange')
  call minpac#add('AndrewRadev/switch.vim')
  call minpac#add('tomtom/tcomment_vim')
  call minpac#add('cohama/lexima.vim')
  call minpac#add('junegunn/vim-easy-align')
  call minpac#add('matze/vim-move')
  call minpac#add('triglav/vim-visual-increment')
  call minpac#add('terryma/vim-expand-region')
  call minpac#add('majutsushi/tagbar')

  call minpac#add('sbdchd/neoformat')
  call minpac#add('guns/xterm-color-table.vim')
  call minpac#add('airodactyl/neovim-ranger')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('antoyo/vim-licenses')
  call minpac#add('fidian/hexmode')
  call minpac#add('lambdalisue/suda.vim')

  call minpac#add('gisphm/vim-gitignore')
  call minpac#add('f-person/git-blame.nvim')
  call minpac#add('lewis6991/gitsigns.nvim')
    \| call minpac#add('nvim-lua/plenary.nvim')



  call minpac#add('sheerun/vim-polyglot')

  call minpac#add('plasticboy/vim-markdown')
  call minpac#add('hail2u/vim-css3-syntax')
  call minpac#add('elzr/vim-json')
  call minpac#add('dzeban/vim-log-syntax')
  call minpac#add('lervag/vimtex')

  packloadall
endfunction


function! s:SetUpKeyMappings()

  function! s:common()
    tnoremap         <Esc><Esc><Esc>  <C-\><C-n>M
    tnoremap         <Esc><Esc>       <C-\><C-n>
    map <silent>     <Esc><Esc>       <Esc>:call OnEscape()<CR>
    function! OnEscape()
      TagbarClose
      Goyo!
      helpclose
      lclose
    endfunction

    map              <Space>          \
    map              <M-`>            :Buffers<CR>
    nmap             <Leader><Space>  :Goyo 120<CR>

    map              f                <Plug>(easymotion-s)
    map              F                <Plug>(easymotion-bd-jk)

    nmap <expr>      MM               ":setl so=" . ((&so == 0) ? 999 : 0) . "\<CR>M"

    nmap             <Leader>         zz

    "nmap             *                :call InterestingWords('n')<CR>
  endfunction()

  function! s:editing()
    nnoremap         U                <C-r>

    nmap             t                :Switch<CR>

    imap             <Del>            <Esc><Left>v?\(\S\\|\%^\)<CR><Right>x:noh<CR>i

    nmap             \|               <Plug>(EasyAlign)
    xmap             \|               <Plug>(EasyAlign)
  endfunction

  function! s:complete_old()
    imap             <C-c>            <Esc>

    imap             <C-Space>        <C-n>

    inoremap <expr>  <Tab>            pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr>  <S-Tab>          pumvisible() ? "\<C-p>" : "\<S-Tab>"

    let g:lexima_no_default_rules = 1 "based on github.com/cohama/lexima.vim/issues/65#issuecomment-339338677
    call lexima#set_default_rules()
    call lexima#insmode#map_hook('before', '<CR>', '')
    function! s:on_cr() abort
      let l:e = pumvisible() ? "\<C-y>" : ""
      let l:e.= neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : lexima#expand('<CR>', 'i')
      return l:e
    endfunction
    imap <expr>       <CR>             <SID>on_cr()
    smap <expr>       <CR>             <SID>on_cr()
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

  lua << EOF
  local lsp = require('lspconfig')
  lsp.bashls.setup {}
  lsp.clangd.setup {}
  lsp.pyls.setup {}
  lsp.sumneko_lua.setup {}
  lsp.texlab.setup {}

  local compe = require('compe')
  compe.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;
    source = {
      path = true;
      buffer = true;
      calc = true;
      nvim_lsp = true;
      nvim_lua = true;
      vsnip = true;
      zsh = true;
      latex_symbols = true;
    };
  }

  local lspkind = require('lspkind')
  lspkind.init()

  local gitsigns = require('gitsigns')
  gitsigns.setup()
EOF

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

  colorscheme one-nvim " onedark . apprentice . tangoshady

  lua << EOF
  vim.g.one_nvim_transparent_bg = true
EOF

  hi Normal ctermbg=NONE guibg=NONE

  hi clear SignColumn
endfunction


function! s:SetUpPluginVariables()
  let g:no_plugin_maps = 1
  let g:textobj_lastpat_no_default_key_mappings = 1
  let g:EasyMotion_do_mapping = 0

  let g:signify_realtime = 1
  let g:signify_vcs_list = [ 'git' ]
  let g:signify_sign_change = '~'
  let g:signify_sign_changedelete = '!'

  let g:ale_completion_enabled = 1

  let g:asyncomplete_remove_duplicates = 1

  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_toc_autofit = 1

  let g:fzf_buffers_jump = 1

  let g:tagbar_autofocus = 1
  let g:tagbar_autoclose = 1
  let g:tagbar_sort = 0
  let g:tagbar_compact = 1
  let g:tagbar_expand = 1
  let g:tagbar_singleclick = 1
  let g:tagbar_width = 42
  let g:tagbar_map_nextfold = 'l'
  let g:tagbar_map_prevfold = 'h'
  let g:tagbar_map_showproto = 'p'
  let g:tagbar_map_preview = '<SPACE>'
  let g:tagbar_map_togglefold = ';'
  let g:tagbar_map_openfold = 'L'
  let g:tagbar_map_closefold = 'H'
  let g:tagbar_map_togglesort = 'S'

  let g:switch_mapping = ""
  function! s:build_switch_custom_definitions(...)
    let definitions = []
    for words in a:000
      call add(definitions, words)
      let uppercase_definitions = []
      let lowercase_definitions = []
      let titlecase_definitions = []
      for word in words
        let uppercase = toupper(word)
        if uppercase !=# word | call add(uppercase_definitions, uppercase) | endif
        let titlecase = substitute(word, "\\<.", "\\u&", "")
        if titlecase !=# word | call add(titlecase_definitions, titlecase) | endif
      endfor
      if len(uppercase_definitions) != 0 | call add(definitions, uppercase_definitions) | endif
      if len(lowercase_definitions) != 0 | call add(definitions, lowercase_definitions) | endif
      if len(titlecase_definitions) != 0 | call add(definitions, titlecase_definitions) | endif
    endfor
    return definitions
  endfunction
  let g:switch_custom_definitions = s:build_switch_custom_definitions(
    \  ['left', 'right', 'up', 'down'],
    \  ['next', 'previous'],
    \  ['enable', 'disable'],
    \  ['enabled', 'disabled'],
    \  ['pick', 'reword', 'edit', 'squash', 'fixup', 'exec'],
    \  ['lesser', 'smaller', 'bigger', 'greater'],
    \  ['width', 'height'],
    \  ['x', 'y', 'w', 'h'],
    \  ['yes', 'no'],
    \  ['on', 'off'],
    \  ['put', 'get', 'set'],
    \  ['!=', '=='],
    \  ['>', '<'],
    \  ['0', '1'])

  let g:better_whitespace_filetypes_blacklist = [
    \  'diff',
    \  'pandoc',
    \  'markdown',
    \  'gitcommit',
    \  'qf',
    \  'help'
    \ ]

  let g:vimtex_compiler_progname = 'nvr'
  let g:vimtex_view_method = 'zathura'
  let g:tex_flavor = "latex"

  let g:suda#prefix = 'sudo://'
  let g:suda_smart_edit = 1

endfunction


function! s:SetUpVimVariables()
  setglobal showmode
  setglobal modeline
  setglobal modelines=5
  setglobal synmaxcol=9999

  setglobal title
  setglobal titlestring=%{expand(\"%:p:h\")}

  setglobal ttimeoutlen=50
  setglobal nobackup nowb noswapfile
  setglobal encoding=utf-8 termencoding=utf-8 fileencoding=utf-8

  setglobal scrollback=-1
  setglobal clipboard=unnamedplus
  setglobal mouse=a
  setglobal selection=exclusive
  setglobal virtualedit+=block
  setglobal conceallevel=0 concealcursor=niv
  setglobal wildignorecase
  setglobal fillchars=""

  setglobal nohlsearch
  setglobal inccommand=split

  setglobal completeopt=menuone,noselect

  setglobal undofile
  setglobal undolevels=10000
  setglobal undoreload=100000

  setglobal foldlevel=0 nofoldenable

  setglobal signcolumn=yes
  setglobal showtabline=2 laststatus=0
  setglobal hidden
  setglobal shortmess+=c
  setglobal lazyredraw
  setglobal pumblend=15

  setglobal number numberwidth=1

  setglobal shiftwidth=4 tabstop=4 expandtab
  setglobal smartindent showmatch mat=2
  setglobal smartcase ignorecase
  setglobal linebreak

  setglobal whichwrap+=<,>,h,l,[,]

  setglobal splitbelow splitright
endfunction


call s:SetUpVimVariables()
call s:SetUpPluginVariables()
call s:SetUpPlugins()
call s:SetUpKeyMappings()
call s:SetUpAutoCommands()
call s:SetUpAppearance()
