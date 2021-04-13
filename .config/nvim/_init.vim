function! s:SetUpKeyMappings()

  nmap <silent>   <Space><Space>              :Goyo<CR>
  nmap <silent>   <Space>                     <Leader>

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

    map              <M-`>            :Buffers<CR>

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

  lua << EOF
  local nvim_lsp = require('lspconfig')
  nvim_lsp.bashls.setup {}
  nvim_lsp.clangd.setup {}
  nvim_lsp.pyls.setup {}
  nvim_lsp.sumneko_lua.setup { cmd = { 'lua-language-server', '-E', '/usr/share/lua-language-server', "/main.lua" } }
  nvim_lsp.texlab.setup {}
  nvim_lsp.rust_analyzer.setup {}
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<Leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<Leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
      buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
      buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
      vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]], false)
    end
  end

  -- Use a loop to conveniently both setup defined servers
  -- and map buffer local keybindings when the language server attaches
  local servers = { "pyright", "rust_analyzer", "tsserver" }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach }
  end

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

  local tree_sitter = require('nvim-treesitter.configs')
  tree_sitter.setup {
    ensure_installed = 'maintained',
    highlight = { enabled = true },
    indent = { enabled = true }
  }
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

  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_toc_autofit = 1

  let g:fzf_buffers_jump = 1

  let g:goyo_width = 150

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

  let g:indent_blankline_char = '┊'
  let g:indentLine_char = '┊'

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
call s:SetUpKeyMappings()
call s:SetUpAutoCommands()
call s:SetUpAppearance()
