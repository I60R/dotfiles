vim.g.no_plugin_maps = true
require('keymap')

local packer_path = vim.fn.stdpath('data')
packer_path = packer_path .. '/site/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
    vim.cmd('!git clone https://github.com/wbthomason/packer.nvim ' .. packer_path)
    vim.cmd 'packadd packer.nvim'
    local packer = require('packer')
    local arguments = require('plugins')
    packer.setup(arguments)
    packer.sync()
end


vim.o.title = true
vim.o.titlestring = '%{expand("%:p:h")}'

vim.o.termguicolors = true
vim.o.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'

vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.undoreload = 100000

vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true

vim.o.number = true
vim.o.numberwidth = 1

vim.o.scrollback = -1
vim.o.scrolloff = 1

vim.o.clipboard = 'unnamedplus'
vim.o.mouse = 'a'
vim.o.virtualedit = 'block'
vim.o.selection = 'inclusive'
vim.o.linebreak = true

vim.o.concealcursor = 'nv'
vim.o.foldenable = false

vim.o.inccommand = 'split'
vim.o.wildignorecase = true
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.pumblend = 15
vim.o.smartindent = true
vim.o.matchtime = 2
vim.o.showmatch = true

vim.o.timeoutlen = 1500
vim.o.updatetime = 200

vim.o.hidden = true
vim.o.lazyredraw = true
vim.o.hlsearch = false

vim.o.fillchars = ''
vim.o.signcolumn = 'yes:3'
vim.o.showtabline = 2
vim.o.laststatus = 0
vim.o.shortmess = ''

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.whichwrap = 'b,s,<,>,h,l,[,]'

vim.o.splitbelow = true
vim.o.splitright = true


vim.api.nvim_create_autocmd('VimEnter', {
    command = 'silent exec "!kill -s SIGWINCH $PPID"'
})

vim.api.nvim_create_autocmd('CursorHold', {
    command = 'checktime'
})

vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = 'plugins.lua, config.lua, init.lua',
    callback = function()
        vim.cmd 'source <afile>'
        vim.cmd 'PackerClean'
        vim.cmd 'PackerCompile'
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'PageOpen',
    callback = function()
        (map "Close page")
            .ctrl['c'] = {
            function()
                local current_buffer_num = vim.api.nvim_get_current_buf()
                vim.api.nvim_buf_delete(current_buffer_num, {
                    force = true
                })
                if current_buffer_num == vim.b.page_alternate_bufnr and
                    vim.api.nvim_get_mode() == 'n'
                then
                    vim.cmd 'norm a'
                end
            end,
            modes = 'nt'
        }
    end
})

vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank {
            higroup = 'TermCursor',
            timeout = 400
        }
    end
})
