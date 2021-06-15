local exec = vim.cmd
local fn = vim.fn
local opt = vim.o


local packer_path = fn.stdpath('data') .. '/site/pack/packer/site/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
    exec('!git clone https://github.com/wbthomason/packer.nvim ' .. packer_path)
end

exec 'autocmd BufWritePost plugins.lua PackerCompile'

require 'plugins'


opt.title = true
opt.titlestring = '%{expand("%:p:h")}'

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
opt.virtualedit = 'all'
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


exec 'source ~/.config/nvim/_init.vim'
