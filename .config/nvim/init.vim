

function! s:SetUpPlugins()
  call plug#begin('~/.config/nvim/plugged/')

  Plug 'joshdick/onedark.vim'
  Plug 'ryanoasis/vim-devicons'
  Plug 'itchyny/vim-highlighturl'

  Plug 'itchyny/lightline.vim'
    \| Plug 'mgee/lightline-bufferline'

  Plug 'junegunn/goyo.vim'
  Plug 'kopischke/vim-stay'

  Plug 'machakann/vim-highlightedyank'
  Plug 'lfv89/vim-interestingwords'

  Plug 'kana/vim-repeat'
  Plug 'kana/vim-operator-user'
    \| Plug 'rhysd/vim-operator-surround'

  Plug 'kana/vim-textobj-user'
    \| Plug 'wellle/targets.vim'
    \| Plug 'rhysd/vim-textobj-anyblock'
    \| Plug 'rhysd/vim-textobj-conflict'
    \| Plug 'glts/vim-textobj-comment'
    \| Plug 'kana/vim-textobj-lastpat'
    \| Plug 'kana/vim-textobj-indent'
    \| Plug 'kana/vim-textobj-line'
    \| Plug 'I60R/vim-textobj-nonwhitespace'

  Plug 'prabirshrestha/asyncomplete.vim'
    \| Plug 'prabirshrestha/async.vim' | Plug 'prabirshrestha/vim-lsp' | Plug 'prabirshrestha/asyncomplete-lsp.vim'
    \| Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets' | Plug 'prabirshrestha/asyncomplete-neosnippet.vim'
    \| Plug 'Shougo/neco-vim' | Plug 'prabirshrestha/asyncomplete-necovim.vim'
    \| Plug 'prabirshrestha/asyncomplete-buffer.vim'
    \| Plug 'prabirshrestha/asyncomplete-file.vim'
    \| Plug 'prabirshrestha/asyncomplete-tags.vim'
    \| Plug 'yami-beta/asyncomplete-omni.vim'
  Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
  Plug 'lotabout/skim.vim'
  Plug 'aperezdc/vim-template'

  Plug 'w0rp/ale'
  Plug 'rhysd/vim-grammarous'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'junegunn/vim-peekaboo'
  Plug 'luochen1990/indent-detector.vim'
  Plug 'tpope/vim-characterize'
  Plug 'dylanaraps/root.vim'

  Plug 'easymotion/vim-easymotion'
  Plug 'bkad/CamelCaseMotion'

  Plug 'tommcdo/vim-exchange'
  Plug 'AndrewRadev/switch.vim'
  Plug 'tomtom/tcomment_vim'
  Plug 'cohama/lexima.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'matze/vim-move'
  Plug 'triglav/vim-visual-increment'
  Plug 'terryma/vim-expand-region'
  Plug 'majutsushi/tagbar'

  Plug 'sbdchd/neoformat'
  Plug 'airodactyl/neovim-ranger'
  Plug 'tpope/vim-eunuch'
  Plug 'antoyo/vim-licenses'
  Plug 'fidian/hexmode'

  Plug 'gisphm/vim-gitignore'
  Plug 'mhinz/vim-signify'

  Plug 'sheerun/vim-polyglot'

  Plug 'vim-pandoc/vim-pandoc'
  Plug 'vim-pandoc/vim-pandoc-syntax'

  call plug#end()
endfunction


function! s:SetUpKeyMappings()

  function! s:common()
    tnoremap         <Esc>            <C-\><C-n>

    map <silent>     <Esc><Esc>       <Esc>:call OnEscape()<CR>
    function! OnEscape()
      TagbarClose
      Goyo!
      helpclose
      lclose
    endfunction

    map              <Space>          \
    map              <M-`>            :Buffers<CR>
    nmap             <Leader><Space>  :Goyo<CR>

    map              s                <Plug>(easymotion-s)
    map              S                <Plug>(easymotion-bd-jk)

    nmap <expr>      MM               ":setl so=" . ((&so == 0) ? 999 : 0) . "\<CR>M"

    nmap          	 <Leader>         zz

    nmap             *                :call InterestingWords('n')<CR>
  endfunction()

  function! s:editing()
    nnoremap         U                <C-r>

    nmap             t                :Switch<CR>

    imap             <Del>            <Esc><Left>v?\(\S\\|\%^\)<CR><Right>x:noh<CR>i

    nmap             \|               <Plug>(EasyAlign)
    xmap             \|               <Plug>(EasyAlign)
  endfunction

  function! s:complete()
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
		imap <expr>  		 <CR> 					  <SID>on_cr()
		smap <expr>  		 <CR> 					  <SID>on_cr()
  endfunction


  function! s:shortcut()
    map              <M-q>            :bd<CR>
    map              <M-Q>            :bd!<CR>
    tmap             <M-q>            <Esc>:bd<CR>
    tmap             <M-Q>            <Esc>:bd!<CR>

    nmap             <M-Right>        :bnext<CR>
    nmap             <M-Left>         :bprevious<CR>
    tmap             <M-Right>        <Esc>:bnext<CR>
    tmap             <M-Left>         <Esc>:bprevious<CR>

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
    tmap             <M-1>            <Esc><Plug>lightline#bufferline#go(1)
    tmap             <M-2>            <Esc><Plug>lightline#bufferline#go(2)
    tmap             <M-3>            <Esc><Plug>lightline#bufferline#go(3)
    tmap             <M-4>            <Esc><Plug>lightline#bufferline#go(4)
    tmap             <M-5>            <Esc><Plug>lightline#bufferline#go(5)
    tmap             <M-6>            <Esc><Plug>lightline#bufferline#go(6)
    tmap             <M-7>            <Esc><Plug>lightline#bufferline#go(7)
    tmap             <M-8>            <Esc><Plug>lightline#bufferline#go(8)
    tmap             <M-9>            <Esc><Plug>lightline#bufferline#go(9)
    tmap             <M-0>            <Esc><Plug>lightline#bufferline#go(10)

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
    nnoremap         W                w
    onoremap         W                w
    xnoremap         W                w

    map              b                <Plug>CamelCaseMotion_b
    omap            ib                <Plug>CamelCaseMotion_ib
    xmap            ib                <Plug>CamelCaseMotion_ib
    omap            ab                <Plug>CamelCaseMotion_ab
    xmap            ab                <Plug>CamelCaseMotion_ab
    onoremap        iB                ib
    xnoremap        iB                ib
    nnoremap         B                b
    onoremap         B                b
    xnoremap         B                b

    map              e                <Plug>CamelCaseMotion_e
    omap            ie                <Plug>CamelCaseMotion_ie
    xmap            ie                <Plug>CamelCaseMotion_ie
    omap            ae                <Plug>CamelCaseMotion_ae
    xmap            ae                <Plug>CamelCaseMotion_ae
    onoremap        iE                ie
    xnoremap        iE                if
    nnoremap         E                e
    onoremap         E                e
    xnoremap         E                e
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
  \ if index(g:better_whitespace_filetypes_blacklist, &ft) < 0 | exec 'EnableStripWhitespaceOnSave' | endif

  au TermOpen *
  \ setlocal scrolloff=999

  au! CompleteDone *
  \ if pumvisible() == 0 | pclose | endif

  if &diff
    let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
  endif

  if executable('clangd')
    au User lsp_setup call lsp#register_server({
		  \  'name': 'clangd',
      \  'cmd': {server_info->['clangd']},
      \  'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
      \ })
	endif
	if executable('rls')
    au User lsp_setup call lsp#register_server({
      \  'name': 'rls',
      \  'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
      \  'whitelist': ['rust'],
      \ })
  endif
	au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \  'name': 'file',
    \  'whitelist': ['*'],
    \  'priority': 10,
    \  'completor': function('asyncomplete#sources#file#completor')
    \ }))
	au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
    \  'name': 'tags',
    \  'whitelist': ['c', 'markdown'],
    \  'completor': function('asyncomplete#sources#tags#completor'),
    \  'config': {
    \    'max_file_size': 50000000,
    \  }
    \ }))
	au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
    \  'name': 'necovim',
    \  'whitelist': ['vim'],
    \  'completor': function('asyncomplete#sources#necovim#completor'),
    \ }))
	call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
    \  'name': 'neosnippet',
    \  'whitelist': ['*'],
    \  'completor': function('asyncomplete#sources#neosnippet#completor'),
    \ }))
  call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \  'name': 'buffer',
    \  'whitelist': ['*'],
    \  'blacklist': ['go'],
    \  'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))
	call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
    \  'name': 'omni',
    \  'whitelist': ['*'],
    \  'blacklist': ['html'],
    \  'completor': function('asyncomplete#sources#omni#completor')
    \ }))
endfunction


function! s:SetUpAppearance()
  setglobal termguicolors
  setglobal guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

  syntax enable

  function! FiletypeFunction()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  endfunction

  function! FileformatFunction()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  endfunction

  let g:onedark_terminal_italics = 1
  let g:lightline = {
    \ 'colorscheme': 'onedark',
    \ 'enable': {
    \   'statusline': 0,
    \   'tabline': 1
    \ },
    \ 'tabline': {
    \   'left': [ [ 'bufnum' ], ['buffers'], ],
    \   'right': [ [ 'lines' ], [ 'fileencoding', 'fileformat', ], [ 'filetype'] ],
    \ },
    \ 'component_expand': {
    \   'buffers': 'lightline#bufferline#buffers',
    \ },
    \ 'component': {
    \   'lines': '%L'
    \ },
    \ 'component_type': {
    \   'buffers': 'tabsel',
    \ },
    \ 'component_function': {
    \   'filetype': 'FiletypeFunction',
    \   'fileformat': 'FileformatFunction',
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

  let g:lightline#bufferline#number_map = { 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴', 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}
  let g:lightline#bufferline#show_number = 2
  let g:lightline#bufferline#unicode_symbols = 1
  let g:lightline#bufferline#shorten_path = 1

  colorscheme onedark " apprentice . tangoshady
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

  let g:pandoc#modules#disabled = [ "spell" ]

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
  let g:switch_custom_definitions = [
    \  ['Left', 'Right', 'Up', 'Down'],
    \  ['left', 'right', 'up', 'down'],
    \  ['Next', 'Prev'],
    \  ['next', 'prev'],
    \  ['Enable', 'Disable'],
    \  ['enable', 'disable'],
    \  [ 'pick', 'reword', 'edit', 'squash', 'fixup', 'exec' ],
    \  ['Lesser', 'Smaller', 'Bigger', 'Greater'],
    \  ['lesser', 'smaller', 'bigger', 'greater'],
    \  ['width', 'height', 'Width', 'Height'],
    \  ['x', 'y', 'w', 'h'],
    \  ['X', 'Y', 'W', 'H'],
    \  ['On', 'Off'],
    \  ['on', 'off'],
    \  ['!=', '==', '>', '<'],
    \  ['Yes', 'No'],
    \  ['yes', 'no'],
    \  ['0', '1'],
    \  ['Put', 'Get', 'Set'],
    \  ['put', 'get', 'set'],
    \ ]

  let g:better_whitespace_filetypes_blacklist = [
    \  'diff',
    \  'pandoc',
    \  'markdown',
    \  'gitcommit',
    \  'qf',
    \  'help'
    \ ]

endfunction


function! s:SetUpVimVariables()
  setglobal showmode
  setglobal modeline
  setglobal modelines=5

  setglobal ttimeoutlen=50
  setglobal nobackup nowb noswapfile
  setglobal encoding=utf-8 termencoding=utf-8 fileencoding=utf-8

  setglobal scrollback=-1
  setglobal clipboard=unnamedplus
  setglobal mouse=a
  setglobal selection=exclusive
  setglobal virtualedit+=block
  setglobal conceallevel=2 concealcursor=niv
  setglobal fillchars=""

  setglobal nohlsearch
  setglobal inccommand=split

  setglobal completeopt+=preview

  setglobal undofile
  setglobal undolevels=10000
  setglobal undoreload=100000

  setglobal foldlevel=0

  setglobal signcolumn=yes
  setglobal showtabline=2 laststatus=0
  setglobal hidden
  setglobal wildmode=list:longest,full
  setglobal shortmess+=c
  setglobal lazyredraw

  setglobal number numberwidth=1

  setglobal shiftwidth=4 tabstop=4 expandtab
  setglobal smartindent showmatch mat=2
  setglobal smartcase ignorecase

  setglobal whichwrap+=<,>,h,l,[,]

  setglobal splitbelow splitright
endfunction


call s:SetUpVimVariables()
call s:SetUpPluginVariables()
call s:SetUpPlugins()
call s:SetUpKeyMappings()
call s:SetUpAutoCommands()
call s:SetUpAppearance()
