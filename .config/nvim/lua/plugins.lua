local packer = require('packer')
packer.init {
  display = {
    open_cmd = '65vnew packer'
  }
}
packer.reset()

return packer.startup(function()
  use 'wbthomason/packer.nvim'

  vim.api.nvim_set_var('no_plugin_maps', true)

  use {
    'folke/tokyonight.nvim',
    config = function()
      vim.api.nvim_set_var('tokyonight_transparent', true)
      vim.api.nvim_set_var('tokyonight_style', 'night')
      vim.g.tokyonight_colors = { black = '#00000000' }
      vim.cmd 'colorscheme tokyonight'
      vim.cmd 'syntax enable'
    end
  }
  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      local bufferline = require('bufferline')
      bufferline.setup {
        options = {
          right_mouse_command = 'vertical sbuffer %d',
          middle_mouse_command = 'bdelete! %d',
          diagnostics = 'nvim_lsp',
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = false,
          numbers = 'both',
          show_tab_indicators = false,
          mappings = false,
          custom_areas = {
            right = function()
              local git = vim.b.gitsigns_status_dict
              local result = {}
              local removed = git['removed']
              if removed > 0 then
                result[#result + 1] = { text = '  ', guifg = 'DarkRed' }
                result[#result + 1] = { text = tostring(removed) }
              end
              local added = git['added']
              if added > 0 then
                result[#result + 1] = { text = ' 樂', guifg = 'DarkGreen' }
                result[#result + 1] = { text = tostring(added) }
              end
              local changed = git['changed']
              if changed > 0 then
                result[#result + 1] = { text = ' ﰣ ', guifg = 'DarkYellow' }
                result[#result + 1] = { text = tostring(changed) }
              end
              result[#result + 1] = { text = ' ', guifg = 'blue' }
              result[#result + 1] = { text = '  ', guibg = 'blue' }
              result[#result + 1] = { text = git['head'] .. ' ', guibg = 'blue', gui = 'bold' }
              result[#result + 1] = { text = ' ' }
              return result
            end,
          }
      }
    }
    local modes = { "n", "i", "c", "x", "s", "o", "t" }
    for _, m in ipairs(modes) do
      for i = 1, 9 do
        local cmd = '<C-\\><C-n>:lua require("bufferline").go_to_buffer(' .. tostring(i) .. ')<CR>'
        vim.api.nvim_set_keymap(m, '<M-' .. i .. '>',  cmd, { noremap = true, silent = true })
      end
    end
  end
  }

  use 'machakann/vim-highlightedyank'
  use 'itchyny/vim-highlighturl'
  use 'norcalli/nvim-colorizer.lua'
  use 'DanilaMihailov/beacon.nvim'
  use 'junegunn/vim-slash'
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.api.nvim_set_var('indent_blankline_char', '┊')
      vim.api.nvim_set_var('indent_blankline_use_treesitter', true)
      vim.api.nvim_set_var('indent_blankline_buftype_exclude', { 'terminal', 'help' })
      vim.api.nvim_set_var('indent_blankline_show_current_context', true)
    end
  }
  use {
    'kevinhwang91/nvim-hlslens',
    config = function()
      local hlslens = require('hlslens')
      hlslens.setup{}
    end
  }
  use {
    'winston0410/range-highlight.nvim',
    requires = 'winston0410/cmd-parser.nvim',
    config = function()
      local range_hl = require('range-highlight')
      range_hl.setup{}
    end
  }
  use {
    'folke/which-key.nvim',
    config = function()
      local which_key = require('which-key')
      vim.cmd 'silent! unmap zz'
      which_key.setup {
        icons = {
          separator = ''
        },
        window = {
          position = 'top',
          margin = { 0, 0, 0, 0 },
          padding = { 3, 3, 3, 3 }
        },
        layout = {
          align = 'center',
          width = { min = 20, max = 120 }
        }
      }
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
    'neovim/nvim-lsp',
    requires = {
      'nvim-lua/lsp-status.nvim',
      'onsails/lspkind-nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      local lspkind = require('lspkind')
      lspkind.init{}

      local lsp_status = require('lsp-status')
      lsp_status.register_progress()

      local nvim_lsp = require('lspconfig')
      local on_attach = function(client, bufnr)
        lsp_status.on_attach(client, bufnr)

        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
        --
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
        --
        -- Mappings.
        local opts = { noremap = true, silent = true }
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

      -- Enable snippet support
      lsp_status.capabilities.textDocument.completion.completionItem.snippetSupport = true
      lsp_status.capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        }
      }

      -- Use a loop to conveniently both setup defined servers
      -- and map buffer local keybindings when the language server attaches
      local servers = { "bashls", "rust_analyzer" }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          on_attach = on_attach,
          capabilities = lsp_status.capabilities
        }
      end

      nvim_lsp.sumneko_lua.setup {
        cmd = { 'lua-language-server', '-E', '/usr/share/lua-language-server', "/main.lua" },
        on_attach = on_attach,
        capabilities = lsp_status.capabilities
      }
    end
  }

  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use 'tamago324/compe-zsh'
  use 'GoldsteinE/compe-latex-symbols'
  use {
    'windwp/nvim-autopairs',
    config = function()
      local autopairs = require('nvim-autopairs')
      autopairs.setup {}
      local autopairs_compe = require("nvim-autopairs.completion.compe")
      autopairs_compe.setup {
        map_cr = true, --  map <CR> on insert mode
        map_complete = true, -- it will auto insert `(` after select function or method item
        auto_select = true,  -- auto select first item
      }
    end
  }
  use {
    'hrsh7th/nvim-compe',
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
      vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
      vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
      vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
      vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
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
