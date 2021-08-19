local exec = vim.cmd
local fn = vim.fn
local opt = vim.o


local packer_path = fn.stdpath('data') .. '/site/pack/packer/site/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
    exec('!git clone https://github.com/wbthomason/packer.nvim ' .. packer_path)
end

exec 'packadd packer.nvim'
exec 'autocmd BufWritePost plugins.lua source <afile> | PackerCompile'

require 'plugins'


opt.title = true
opt.titlestring = '%{expand("%:p:h")}'

opt.termguicolors = true
opt.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'

opt.backup = false
opt.writebackup = false
opt.swapfile = false

opt.undofile = true
opt.undolevels = 10000
opt.undoreload = 100000

opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true

opt.number = true
opt.numberwidth = 1

opt.scrollback = -1

opt.clipboard = 'unnamedplus'
opt.mouse = 'a'
opt.virtualedit = 'block'
opt.selection = 'inclusive'
opt.linebreak = true

opt.concealcursor = 'nv'
opt.foldenable = false

opt.inccommand = 'split'
opt.wildignorecase = true
opt.completeopt = 'menuone,noselect'
opt.pumblend = 15
opt.smartindent = true
opt.matchtime = 2
opt.showmatch = true
opt.timeoutlen = 1500

opt.hidden = true
opt.lazyredraw = true
opt.hlsearch = false

opt.fillchars = ''
opt.signcolumn = 'yes'
opt.showtabline = 2
opt.laststatus = 0
opt.shortmess = ''

opt.ignorecase = true
opt.smartcase = true
opt.whichwrap = 'b,s,<,>,h,l,[,]'

opt.splitbelow = true
opt.splitright = true

vim.cmd [[
au! VimEnter * :silent exec "!kill -s SIGWINCH $PPID"
au! CursorHold * checktime

au BufEnter * if empty(&ft) && &buftype != 'terminal' | set filetype=markdown | endif

function! PageClose(page_alternate_bufnr)
bd!
if bufnr('%') == a:page_alternate_bufnr && mode('%') == 'n'
  norm a
endif
endfunction
au! User PageOpen exe 'map <buffer> <C-c> :call PageClose(b:page_alternate_bufnr)<CR>' | exe 'tmap <bufer> <C-c> :call PageClose(b:page_alternate_bufnr)<CR>'

au! User GoyoLeave hi Normal guibg=NONE ctermbg=NONE

aug VMlens
  au!
  au User visual_multi_start lua require('vmlens').start()
  au User visual_multi_exit lua require('vmlens').exit()
aug END]]

