return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  vim.g.no_plugin_maps = true
  require('keymap')

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
      local highlights = {
        background = { gui = 'bold', }
      }
      for _, v in ipairs {
        'tab', 'close_button', 'buffer', 'diagnostic',
        'info', 'info_diagnostic',
        'warning', 'warning_diagnostic',
        'error', 'error_diagnostic',
        'modified', 'duplicate', 'separator', 'indicator', 'pick'
      } do
        highlights[v .. '_selected'] = { guibg = '#0000FF' }
      end

      local bufferline = require('bufferline')
      bufferline.setup {
        options = {
          right_mouse_command = 'vertical sbuffer %d',
          middle_mouse_command = 'bdelete! %d',
          diagnostics = 'nvim_lsp',
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = false,
          numbers = function(numbers)
            return numbers.ordinal .. '.' .. numbers.lower(numbers.id) .. ' '
          end,
          separator_style = { '', '' },
          indicator_icon = '',
          show_tab_indicators = false,
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
      for n = 1, 9 do
        local function focus_nth_buffer() require('bufferline').go_to_buffer(n) end
        map ['<M-' .. n .. '>'] = { focus_nth_buffer, "Go to (" .. n .. ") buffer", remap = false, silent = true }
      end
      map ['<M-`>'] = { '<Cmd>BufferLinePick<CR>', "Pick buffer" }
      map ['<M-Left>' ] = { '<Cmd>BufferLineCyclePrev<CR>', "Previous buffer" }
      map ['<M-Right>'] = { '<Cmd>BufferLineCycleNext<CR>', "Next buffer" }
      map ['<M-q>'] = { '<Cmd>b # | bd #<CR>', "Close buffer" }
      map:register { modes = 'nicxsot' }
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
        javascript = { css = true }
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
    end,
    config = function()
      map ['*' ] = { '<Plug>(asterisk-z*)<Cmd>lua require("hlslens").start()<CR>', "Search word" }
      map ['#' ] = { '<Plug>(asterisk-z#)<Cmd>lua require("hlslens").start()<CR>', "Search word backwards" }
      map ['g*'] = { '<Plug>(asterisk-gz*)<Cmd>lua require("hlslens").start()<CR>', "Search word" }
      map ['g#'] = { '<Plug>(asterisk-gz#)<Cmd>lua require("hlslens").start()<CR>', "Search word backwards" }
      map:register {}
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

      map ['n'] = { function() vim.cmd('normal! ' .. vim.v.count1 .. 'n'); require('hlslens').start() end, "Next match" }
      map ['N'] = { function() vim.cmd('normal! ' .. vim.v.count1 .. 'N'); require('hlslens').start() end, "Prev match" }
      map:register { remap = false }
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
    'winston0410/range-highlight.nvim',
    requires = 'winston0410/cmd-parser.nvim',
    config = function()
      local range_hl = require('range-highlight')
      range_hl.setup {}
    end
  }
  use {
    'nacro90/numb.nvim',
    config = function()
      local numb = require('numb')
      numb.setup {}
    end
  }
  use 'dstein64/nvim-scrollview'
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
      map ['<Space><Space>'] = { '<Cmd>Goyo<CR>', "Distraction-free writing" }
      map:register {}
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
    end,
    config = function()
      map ['ai'] = { '<Plug>(textobj-indent-a)', "Inner indent" }
      map ['iI'] = { '<Plug>(textobj-indent-i)', "Outer indent" }
      map ['an'] = { '<Plug>(textobj-lastpat-n)', "Last pattern" }
      map ['aN'] = { '<Plug>(textobj-lastpat-N)', "Prev pattern" }
      map:register { modes = 'o' }
    end
  }


  use {
    'neovim/nvim-lsp',
    requires = {
      'nvim-lua/lsp-status.nvim',
      'onsails/lspkind-nvim',
      'neovim/nvim-lspconfig',
      'simrat39/symbols-outline.nvim',
    },
    config = function()
      local lspkind = require('lspkind')
      lspkind.init {}

      local lsp_status = require('lsp-status')
      lsp_status.register_progress()

      local nvim_lsp = require('lspconfig')
      local on_attach = function(client, bufnr)
        lsp_status.on_attach(client, bufnr)

        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local function print_workspace_folders()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end
        map ['<Leader>wl'] = { print_workspace_folders, "Workspace folders" }
        map ['<Leader>wa'] = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" }
        map ['<Leader>wr'] = { vim.lsp.buf.remove_workspace_folder, "Remove workdspace folder" }

        map ['gD'] = { vim.lsp.buf.declaration, "Declaration" }
        map ['gd'] = { vim.lsp.buf.definition, "Definition" }
        map ['K'] = { vim.lsp.buf.hover, "Hover" }
        map ['gi'] = { vim.lsp.buf.implementation, "Implementation" }
        map ['<C-k>'] = { vim.lsp.buf.signature_help, "Signature" }
        map ['<Leader>D'] = { vim.lsp.buf.type_definition, "Type" }
        map ['<Leader>rn'] = { vim.lsp.buf.rename, "Rename" }
        map ['gr'] = { vim.lsp.buf.references, "References" }
        map ['<Leader>e' ] = { vim.lsp.diagnostic.show_line_diagnostics, "Diagnostics" }
        map ['[d'] = { vim.lsp.diagnostic.goto_prev, "Previous diagnostic" }
        map [']d'] = { vim.lsp.diagnostic.goto_next, "Next diagnostic" }
        map ['<Leader>q'] = { vim.lsp.diagnostic.set_loclist, "Set loclist" }

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
          map ['<Leader>f'] = { vim.lsp.buf.formatting, "Document formatting" }
        elseif client.resolved_capabilities.document_range_formatting then
          map ['<Leader>f'] = { vim.lsp.buf.range_formatting, "Range formatting" }
        end

        map:register { silent = true, remap = false }

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
      autopairs.setup {
        check_ts = true,
        enable_check_bracket_line = true,
      }
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

      -- Use (s-)tab to:
      --- move to prev/next item in completion menuone
      --- jump to prev/next snippet's placeholder
      local function t(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end
      local function check_back_space()
          local col = vim.fn.col('.') - 1
          if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
              return true
          else
              return false
          end
      end
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
      map ['<Tab>'] = { "v:lua.tab_complete()", "Smart Tab complete" }

      _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
          return t "<C-p>"
        elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
          return t "<Plug>(vsnip-jump-prev)"
        else
          return t "<S-Tab>"
        end
      end
      map ["<S-Tab>"] = { "v:lua.s_tab_complete()", "Smart Shift-Tab complete" }

      map:split { modes = 'is', expr = true }

      map ['<C-Space>'] = { '<Cmd>call compe#complete()<CR>', "Force completion" }
      map ['<C-e>'] = { '<Cmd>call compe#close("<C-e>")<CR>', "Cancel completion" }
      map ['<C-f>'] = { '<Cmd>call compe#scroll({ "delta": +4 })<CR>', "Scroll completion up" }
      map ['<C-d>'] = { '<Cmd>call compe#scroll({ "delta": -4 })<CR>', "Scroll completion down" }

      map:register { modes = 'i', remap = false }
    end
  }

  use {
    'lotabout/skim',
    requires = { 'lotabout/skim.vim' },
    run = './install',
  }
  use {
    'w0rp/ale',
    cmd = 'ALEEnable'
  }
  use {
    'sbdchd/neoformat',
    cmd = 'Neoformat'
  }

  use 'kopischke/vim-stay'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-eunuch'
  use {
    "ahmedkhalf/project.nvim",
    config = function()
      local project = require("project_nvim")
      project.setup {}
    end
  }
  use 'airodactyl/neovim-ranger'
  use {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.g.better_whitespace_filetypes_blacklist = { 'diff', 'pandoc', 'markdown', 'gitcommit', 'qf', 'help' }
      vim.cmd 'au BufEnter * if index(g:better_whitespace_filetypes_blacklist, &ft) < 0 | exec "EnableStripWhitespaceOnSave" | endif'
    end
  }


  use {
    'phaazon/hop.nvim',
    config = function()
      local hop = require('hop')
      hop.setup {
        inclusive_jump = true,
        uppercase_labels = true,
      }

      map ['F'] = { function() vim.cmd 'norm 0<CR>'; hop.hint_lines_skip_whitespace() end, "Jump to a line" }
      map ['f'] = { function() hop.hint_char1() end, "Jump to a letter" }
      map:split { modes = 'o' }

      map ['F'] = { function() hop.hint_lines_skip_whitespace(); vim.cmd 'norm zz' end, "Jump to a line and focus on it" }
      map ['f'] = { function() hop.hint_char1() end, "Jump to a letter" }
      map:register { modes = 'n' }
    end
  }
  use 'chaoren/vim-wordmotion'
  use 'mg979/vim-visual-multi'

  use {
    'AndrewRadev/switch.vim',
    keys = 't',
    config = function()
      map ['t'] = { '<Cmd>Switch<CR>', "Toggle value" }
      map:register {}
    end
  }
  use {
    'junegunn/vim-easy-align',
    config = function()
      map ['|'] = { '<Plug>(EasyAlign)', "Align" }
      map:register { modes = 'nxv' }
    end
  }
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
  use {
    'tommcdo/vim-exchange',
    keys = 'cx'
  }
  use {
    'arthurxavierx/vim-caser',
    keys = 'gs'
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

  use {
    'gisphm/vim-gitignore',
    ft = 'gitignore'
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires =  { 'nvim-lua/plenary.nvim' },
    config = function()
      local gitsigns = require('gitsigns')
      gitsigns.setup {
        watch_index = {
          interval = 5000
        },
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 0
        }
      }
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ":TSUpdate",
    requires = {
      'romgrk/nvim-treesitter-context',
      'RRethy/nvim-treesitter-textsubjects',
      'windwp/nvim-ts-autotag',
    },
    config = function()
      local tree_sitter = require('nvim-treesitter.configs')
      tree_sitter.setup {
        ensure_installed = 'maintained',
        highlight = {
          enable = true
        },
        indent = {
          enable = true
        },
        autotag = {
          enable = true,
          filetypes = {
            'html', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'markdown'
          }
        },
        textsubjects = {
          enable = true,
          keymaps = {
            [','] = 'textsubjects-smart'
          }
        }
      }

      local tree_sitter_parsers = require("nvim-treesitter.parsers").get_parser_configs()
      tree_sitter_parsers.markdown = {
        install_info = {
          url = "https://github.com/ikatyang/tree-sitter-markdown",
          files = { "src/parser.c", "src/scanner.cc" },
        },
        filetype = "markdown",
      }
    end,
  }

  use {
    'plasticboy/vim-markdown',
    requires = {
      'godlygeek/tabular'
    }
  }
  use {
    'kat0h/bufpreview.vim',
    requires = {
      'vim-denops/denops.vim'
    },
    config = function()
      vim.g.bufpreview_browser = 'chromium'
      vim.cmd 'autocmd Filetype markdown :PreviewMarkdown'
    end
  }

  use 'nvim-treesitter/playground'
  use 'dzeban/vim-log-syntax'

  use {
    'folke/which-key.nvim',
    config = function()
      local which_key = which_key or require('which-key')
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
          padding = { 3, 8, 3, 8 },
          winblend = 23
        },
      }
      map ['<Space>'] = { '<Nop>', "Unmap space" }
      map ['<Space>'] = { '<Leader>', "Space is the leader key!" }
      map:split { remap = true }

      map ['<Esc><Esc>'] = { '<Cmd>stopinsert<CR>',  "Exit from terminal mode" }
      map ['<Esc><Esc><Esc>'] = { '<Cmd>stopinsert<CR>M', "Exit from terminal mode and focus on center" }
      map:split { modes = 't', remap = false }

      map ['<Esc><Esc>'] = { function() vim.cmd 'helpcl | lcl | ccl | nohls | silent! Goyo!' end, "Exit all non-file windows" }

      local function keepmiddle_toggle()
        if vim.wo.scrolloff == 999 then
          if vim.w.keepmiddle_toggle_scrolloff_backup ~= nil then
            vim.wo.scrolloff = vim.w.keepmiddle_toggle_scrolloff_backup
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
      map ['MM'] = { keepmiddle_toggle, "Toggle scrolloff", remap = false }

      local function cursorcolumn_toggle()
        vim.wo.cursorcolumn = not vim.wo.cursorcolumn
      end
      map ['MC'] = { cursorcolumn_toggle, "Toggle cursorcolumn", remap = false }

      map ['U'] = { '<C-r>', "Undo" }

      map:register { modes = 'n' }
    end
  }
end)
