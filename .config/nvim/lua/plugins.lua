local packer = require('packer')
packer.init {
  display = {
    open_cmd = '65vnew packer'
  }
}
packer.reset()

vim.api.nvim_set_var('no_plugin_maps', true)

return packer.startup(function()
  use 'wbthomason/packer.nvim'

  use 'folke/tokyonight.nvim'
  use 'ryanoasis/vim-devicons'

  use {
    'itchyny/lightline.vim',
    requires = { 'mgee/lightline-bufferline', 'itchyny/vim-gitbranch' }
  }

  use 'junegunn/vim-peekaboo'
  use 'machakann/vim-highlightedyank'
  use 'winston0410/cmd-parser.nvim'
  use 'itchyny/vim-highlighturl'
  use 'norcalli/nvim-colorizer.lua'
  use 'DanilaMihailov/beacon.nvim'
  use 'junegunn/vim-slash'
  use 'lukas-reineke/indent-blankline.nvim'
  use {
    'kevinhwang91/nvim-hlslens',
    config = function()
      local hlslens = require('hlslens')
      hlslens.setup{}
    end
  }
  use {
    'winston0410/range-highlight.nvim',
    config = function()
      local range_hl = require('range-highlight')
      range_hl.setup{}
    end
  }
  use {
    'Yggdroot/indentLine',
    config = function()
      vim.api.nvim_set_var('indent_blankline_char', '┊')
      vim.api.nvim_set_var('indentLine_char', '┊')
    end
  }

  use {
    'inkarkat/vim-mark',
    requires = { 'inkarkat/vim-ingo-library' },
    cmd = 'Mark'
  }
  use {
    'tpope/vim-characterize',
    keys = 'ga'
  }
  use {
    'majutsushi/tagbar',
    keys = '<F10>',
    config = function()
      vim.api.nvim_set_var('tagbar_autofocus', 1)
      vim.api.nvim_set_var('tagbar_autoclose', 1)
      vim.api.nvim_set_var('tagbar_sort', 0)
      vim.api.nvim_set_var('tagbar_compact', 1)
      vim.api.nvim_set_var('tagbar_expand', 1)
      vim.api.nvim_set_var('tagbar_singleclick', 1)
      vim.api.nvim_set_var('tagbar_width', 42)
      vim.api.nvim_set_var('tagbar_map_nextfold', 'l')
      vim.api.nvim_set_var('tagbar_map_prevfold', 'h')
      vim.api.nvim_set_var('tagbar_map_showproto', 'p')
      vim.api.nvim_set_var('tagbar_map_preview', '<SPACE>')
      vim.api.nvim_set_var('tagbar_map_togglefold', ';')
      vim.api.nvim_set_var('tagbar_map_openfold', 'L')
      vim.api.nvim_set_var('tagbar_map_closefold', 'H')
      vim.api.nvim_set_var('tagbar_map_togglesort', 'S')
    end
  }
  use {
    'junegunn/goyo.vim',
    keys = '<Leader><Space>',
    cmd = "Goyo",
    config = function()
      vim.api.nvim_set_var('goyo_width', 150)
    end
  }

  use 'kana/vim-repeat'

  use 'machakann/vim-sandwich'
  use {
    'kana/vim-operator-user',
    requires = {
      'rhysd/vim-operator-surround'
    }
  }
  use {
    'kana/vim-textobj-user',
    requires = {
      'wellle/targets.vim',
      'rhysd/vim-textobj-anyblock',
      'rhysd/vim-textobj-conflict',
      'glts/vim-textobj-comment',
      'kana/vim-textobj-lastpat',
      'kana/vim-textobj-indent',
      'kana/vim-textobj-line',
      'I60R/vim-textobj-nonwhitespace'
    },
    config = function()
      vim.api.nvim_set_var('textobj_lastpat_no_default_key_mappings', true)
    end
  }

  use {
    'hrsh7th/nvim-compe',
    requires = {
      'neovim/nvim-lsp',
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
      'tamago324/compe-zsh',
      'GoldsteinE/compe-latex-symbols',
      'neovim/nvim-lspconfig',
      'onsails/lspkind-nvim'
    },
    config = function()
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
    end
  }
  use {
    'onsails/lspkind-nvim',
    config = function()
      local lspkind = require('lspkind')
      lspkind.init{}
    end
  }
  use {
    'neovim/nvim-lsp',
    config = function()
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
        --
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
        --
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
        --
        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
          buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        elseif client.resolved_capabilities.document_range_formatting then
          buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        end
        --
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
      --
      -- Use a loop to conveniently both setup defined servers
      -- and map buffer local keybindings when the language server attaches
      local servers = { "bashls", "clangd", "pyls", "sumneko_lua", "texlab", "rust_analyzer" }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup { on_attach = on_attach }
      end
    end
  }

  use { 'lotabout/skim', run = './install', requires = { 'lotabout/skim.vim' } }
  use { 'w0rp/ale', cmd = 'ALEEnable' }
  use { 'sbdchd/neoformat', cmd = 'Neoformat' }

  use 'kopischke/vim-stay'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-eunuch'
  use 'dylanaraps/root.vim'
  use 'airodactyl/neovim-ranger'
  use {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.api.nvim_set_var('better_whitespace_filetypes_blacklist', { 'diff', 'pandoc', 'markdown', 'gitcommit', 'qf', 'help' })
    end
  }


  use 'phaazon/hop.nvim'
  use 'bkad/CamelCaseMotion'
  use 'mg979/vim-visual-multi'

  use { 'tommcdo/vim-exchange', keys = 'cx' }
  use { 'AndrewRadev/switch.vim', keys = 't' }
  use { 'arthurxavierx/vim-caser', keys = 'gs' }
  use 'junegunn/vim-easy-align'
  use 'cohama/lexima.vim'
  use 'matze/vim-move'
  use 'triglav/vim-visual-increment'
  use 'terryma/vim-expand-region'
  use {
    'winston0410/commented.nvim',
    config = function()
      local commented = require('commented')
      commented.setup {
        keybindings = { n = ';', v = ';', nl = ';;' }
      }
    end
  }

  use 'aperezdc/vim-template'
  use 'antoyo/vim-licenses'
  use 'fidian/hexmode'
  use {
    'lambdalisue/suda.vim',
    config = function()
      vim.api.nvim_set_var('suda#prefix', 'sudo://')
      vim.api.nvim_set_var('suda_smart_edit', 1)
    end
  }

  use 'f-person/git-blame.nvim'
  use {
    'gisphm/vim-gitignore',
    ft = 'gitignore'
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires =  { 'nvim-lua/plenary.nvim' },
    config = function()
      local gitsigns = require('gitsigns')
      gitsigns.setup{}
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ":TSUpdate",
    config = function()
      local tree_sitter = require('nvim-treesitter.configs')
      tree_sitter.setup {
        ensure_installed = 'maintained',
        highlight = { enabled = true },
        indent = { enabled = true }
      }
    end,
    {
      'nvim-treesitter/playground',
      'plasticboy/vim-markdown',
      'dzeban/vim-log-syntax',
    }
  }
end)
