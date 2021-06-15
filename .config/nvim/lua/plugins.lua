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
  use 'winston0410/range-highlight.nvim'
  use 'itchyny/vim-highlighturl'
  use 'norcalli/nvim-colorizer.lua'
  use 'DanilaMihailov/beacon.nvim'
  use 'junegunn/vim-slash'
  use 'kevinhwang91/nvim-hlslens'
  use 'lukas-reineke/indent-blankline.nvim'
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
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
      'neovim/nvim-lsp',
      'tamago324/compe-zsh',
      'GoldsteinE/compe-latex-symbols',
      'neovim/nvim-lspconfig',
      'onsails/lspkind-nvim'
    }
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
  use 'winston0410/commented.nvim'
  use 'cohama/lexima.vim'
  use 'matze/vim-move'
  use 'triglav/vim-visual-increment'
  use 'terryma/vim-expand-region'

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
  use { 'lewis6991/gitsigns.nvim', requires =  { 'nvim-lua/plenary.nvim' } }
  use { 'gisphm/vim-gitignore', ft = 'gitignore' }


  use {
    'nvim-treesitter/nvim-treesitter',
    run = ":TSUpdate",
    {
      'nvim-treesitter/playground',
      'plasticboy/vim-markdown',
      'dzeban/vim-log-syntax',
    }
  }
end)
