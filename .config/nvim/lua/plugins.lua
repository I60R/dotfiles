local packer = require('packer')

return packer.startup(function()
  use 'wbthomason/packer.nvim'

  vim.g.no_plugin_maps = true

  use {
    'folke/tokyonight.nvim',
    setup = function()
      vim.g.tokyonight_transparent = true
      vim.g.tokyonight_style = 'night'
    end,
    config = function()
      vim.cmd 'colorscheme tokyonight'
      vim.cmd 'syntax enable'
      vim.cmd 'hi NormalFloat guibg=none gui=bold'
    end
  }
  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      local bufferline = require('bufferline')
      local highlights = {
        background = { gui = 'bold', }
      }
      for _, v in ipairs {
        'tab', 'close_button', 'buffer', 'diagnostic',
        'info', 'info_diagnostic',
        'warning', 'warning_diagnostic',
        'error', 'error_diagnostic',
        'modified', 'duplicate', 'separator', 'indicator', 'pick'
      } do highlights[v .. '_selected'] = { guibg = '#0000FF' } end
      local x;
      bufferline.setup {
        options = {
          right_mouse_command = 'vertical sbuffer %d',
          middle_mouse_command = 'bdelete! %d',
          diagnostics = 'nvim_lsp',
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = false,
          numbers = 'ordinal_first',
          number_style = { "none", "subscript" },
          separator_style = { '', '' },
          indicator_icon = '',
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
              result[#result + 1] = { text = git['head'] .. ' ', guibg = 'blue', guifg = 'white', gui = 'bold' }
              result[#result + 1] = { text = ' ' }
              return result
            end,
          },
        },
        highlights = highlights,
      }
    end
  }

  use 'machakann/vim-highlightedyank'
  use 'itchyny/vim-highlighturl'
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
    local colorizer = require('colorizer')
    colorizer.setup {
      '*',
      '!noft',
      css = { css = true },
      html = { css = true },
      javascript = { css = true}
    }
    end
  }
  use {
    'edluffy/specs.nvim',
    config = function()
      local specs = require('specs')
      specs.setup {
        min_jump = 5,
        popup = {
          inc_ms = 50,
          blend = 60,
          winhl = 'TermCursor',
        }
      }
    end
  }
  use {
    'haya14busa/vim-asterisk',
    event = 'VimEnter',
    setup = function()
      vim.g['asterisk#keeppos'] = 1
    end
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    setup = function()
      vim.g.indent_blankline_char = '┊'
      vim.g.indent_blankline_use_treesitter = true
      vim.g.indent_blankline_buftype_exclude = { 'terminal', 'help' }
      vim.g.indent_blankline_show_current_context = true
    end
  }
  use {
    'kevinhwang91/nvim-hlslens',
    config = function()
      local hlslens = require('hlslens')
      hlslens.setup {
        calm_down = true,
        nearest_float_when = 'never',
      }
      vim.cmd 'hi IncSearch gui=bold guifg=white'
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
      which_key.setup {
        icons = {
          separator = ''
        },
        layout = {
          align = 'center',
          width = { min = 0, max = 200 },
        },
        window = {
          position = 'top',
          margin = { 3, 8, 3, 8 },
          padding = { 3, 8, 3, 8 }
        },
      }
      local map = setmetatable({}, { __newindex = function(map, key, into) rawset(map, #map + 1, { [key] = into }) end })
      -- Mapleader mappings
      map['<Space>'] = { '<Nop>',    "Unmap space",              noremap = false }
      map['<Space>'] = { '<Leader>', "Space is the leader key!", noremap = false }
      map['<Space>'] = {
        name = '+<Space> mappings',
        ['<Space>'] = { '<Cmd>Goyo<CR>', "Distraction-free writing" }
      }
      -- Bufferline mappings
      for _, mode in ipairs({ "n", "i", "c", "x", "s", "o", "t" }) do
        for n = 1, 9 do
          local function focus_nth_buffer() require('bufferline').go_to_buffer(n) end
          map['<M-' .. n .. '>'] = { focus_nth_buffer, 'Go to (' .. n .. ') buffer', noremap = true, silent = true, mode = mode }
        end
        map['<M-`>'  ] = { '<Cmd>BufferLinePick<CR>', "Pick buffer", mode = mode }
        map['<M-q>'  ] = { '<Cmd>b # | bd #<CR>', "Buffer close", mode = mode }
        map['<M-q>'  ] = { '<Cmd>b # | bd #<CR>', "Buffer close", mode = mode }
        map['M-Left' ] = { '<Cmd>BufferLineCyclePrev<CR>', "Buffer prev", mode = mode }
        map['M-Right'] = { '<Cmd>BufferLineCycleNext<CR>', "Buffer prev", mode = mode }
      end
      -- Escape mappings
      local function closeall() vim.cmd 'helpclose | lclose | cclose | sil! Goyo! | sil! TagbarClose' end
      map['<Esc>'] = {
          name = '+<Esc> mappings',
          ['<Esc>'     ] = { '<Cmd>stopinsert<CR>',  "Exit from terminal mode",                     mode = 't', noremap = true },
          ['<Esc><Esc>'] = { '<Cmd>stopinsert<CR>M', "Exit from terminal mode and focus on center", mode = 't', noremap = true },
          ['<Esc>'     ] = { closeall,               "Exit all non-file windows" }
      }
      -- Movement mappings
      map['f'] = { function() require('hop').hint_char1() end, "Jump to a letter", mode = 'n' }
      map['f'] = { function() require('hop').hint_char1() end, "Jump to a letter", mode = 'o' }
      map['F'] = { function() require('hop').hint_lines() end, "Jump to a line",   mode = 'n' }
      map['F'] = { function() require('hop').hint_lines() end, "Jump to a line",   mode = 'o' }
      map['an'] = { '<Plug>(textobj-lastpat-n)', "Last pattern", mode = 'o' }
      map['aN'] = { '<Plug>(textobj-lastpat-N)', "Prev pattern", mode = 'o' }
      map['ai'] = { '<Plug>(textobj-indent-a)',  "Inner indent", mode = 'o' }
      map['iI'] = { '<Plug>(textobj-indent-i)',  "Outer indent", mode = 'o' }
      -- Search mappings
      map['n'] = { function() vim.cmd('normal! ' .. vim.v.count1 .. 'n'); require('hlslens').start() end, "Next match", noremap = true }
      map['n'] = { function() vim.cmd('normal! ' .. vim.v.count1 .. 'N'); require('hlslens').start() end, "Prev match", noremap = true }
      map['*'] = { '<Plug>(asterisk-z*)<Cmd>lua require("hlslens").start()<CR>',  "Search word"           }
      map['#'] = { '<Plug>(asterisk-z#)<Cmd>lua require("hlslens").start()<CR>',  "Search word backwards" }
      map['g*'] = { '<Plug>(asterisk-gz*)<Cmd>lua require("hlslens").start()<CR>', "Search word"           }
      map['g#'] = { '<Plug>(asterisk-gz#)<Cmd>lua require("hlslens").start()<CR>', "Search word backwards" }
      -- Togglers
      local function keepmiddle()
        if vim.wo.scrolloff == 999 then
          if vim.w.keepmiddle_scrolloff_backup ~= nil then
            vim.wo.scrolloff = vim.w.scrolloff_backup
          else
            vim.wo.scrolloff = 0
          end
        else
          if vim.wo.scrolloff ~= 0 then
            vim.w.keepmiddle_scrolloff_backup = vim.wo.scrolloff
          end
          vim.wo.scrolloff = 999
          vim.cmd 'norm M'
        end
      end
      map['MM'] = { keepmiddle, "Toggle scrolloff", noremap = true }
      -- Remaps
      map['U'] = { '<C-r>',           "Undo"   }
      map['t'] = { '<Cmd>Switch<CR>', "Toggle" }
      map['|'] = { '<Plug>(EasyAlign)', mode = 'n' }
      map['|'] = { '<Plug>(EasyAlign)', mode = 'x' }
      -- Completion
      map['<C-Space>'] = { '<Cmd>call compe#complete()<CR>',     "Force completion",  mode = 'i', noremap = true }
      map['<C-e>'    ] = { '<Cmd>call compe#close("<C-e>")<CR>', "Cancel completion", mode = 'i', noremap = true }
      map['<C-f>'    ] = { '<Cmd>call compe#scroll({ "delta": +4 })<CR>', "Scroll completion up",   mode = 'i', noremap = true }
      map['<C-d>'    ] = { '<Cmd>call compe#scroll({ "delta": -4 })<CR>', "Scroll completion down", mode = 'i', noremap = true }

      for _, mapping in ipairs(map) do
        which_key.register(mapping)
      end
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
    'junegunn/goyo.vim',
    keys = '<Leader><Space>',
    cmd = "Goyo",
    setup = function()
      vim.g.goyo_width = 150
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
    setup = function()
      vim.g.textobj_lastpat_no_default_key_mappings = true
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
          vim.cmd([[
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
      local servers = { "bashls", "rust_analyzer", "clangd" }
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
      vim.g.better_whitespace_filetypes_blacklist = { 'diff', 'pandoc', 'markdown', 'gitcommit', 'qf', 'help' }
      vim.cmd 'au BufEnter * if index(g:better_whitespace_filetypes_blacklist, &ft) < 0 | exec "EnableStripWhitespaceOnSave" | endif'
    end
  }


  use 'phaazon/hop.nvim'
  use 'chaoren/vim-wordmotion'
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
    setup = function()
      vim.g['suda#prefix'] = 'sudo://'
      vim.g['suda_smart_edit'] = true
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
      'romgrk/nvim-treesitter-context',
    }
  }
end)
