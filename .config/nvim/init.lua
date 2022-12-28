vim.g.no_plugin_maps = true

if vim.g.neovide then
    vim.o.guifont = 'JetBrains Mono:h13'
    vim.g.neovide_transparency = 0.4
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_confirm_quit = false
    vim.g.neovide_scroll_animation_length = 0.0
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
       "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

local lazy = require('lazy')
local plugins = require('plugins')
lazy.setup(plugins)



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
vim.o.pumblend = 25
vim.o.wildoptions = 'pum'
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
vim.o.shortmess = 'oOWAIcFS'

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


vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*/home/*.md',
    callback = function()
        vim.defer_fn(function()
            require('zen-mode').open()

            vim.api.nvim_create_autocmd('BufWinLeave', {
                buffer = 0,
                callback = function()
                    vim.defer_fn(function()
                        require('zen-mode').close()
                    end, 100)
                end
            })
        end, 100)
    end
})


