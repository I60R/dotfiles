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
      vim.cmd 'hi NormalFloat guibg=#000000 gui=bold'
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
            left = function()
              local result = {}
              local git = vim.b.gitsigns_status_dict
              local added = git['added']
              if added > 0 then
                result[#result + 1] = { text = tostring(added), guifg = 'grey'  }
                result[#result + 1] = { text = '樂', guifg = 'DarkGreen' }
              end
              local removed = git['removed']
              if removed > 0 then
                result[#result + 1] = { text = tostring(removed), guifg = 'grey' }
                result[#result + 1] = { text = ' ', guifg = 'DarkRed' }
              end
              local changed = git['changed']
              if changed > 0 then
                result[#result + 1] = { text = tostring(changed), guifg = 'grey'  }
                result[#result + 1] = { text = 'ﰣ ', guifg = 'DarkYellow' }
              end
              result[#result + 1] = { text = ' ' .. git.head, guifg = 'white', gui = 'bold' }
              return result
            end,
          },
        },
        highlights = highlights,
      }
      for n = 1, 9 do
        local function focus_nth_buffer() require('bufferline').go_to_buffer(n) end
        (map "Go to (" .. n .. ") buffer")
          .alt [n] = { focus_nth_buffer, remap = false, silent = true }
      end
      (map "Pick a buffer")
        .alt ['`'] = 'BufferLinePick'
      (map "Previous buffer")
        .alt ['Left'] = 'BufferLineCyclePrev'
      (map "Next buffer")
        .alt ['Right'] = 'BufferLineCycleNext'
      (map "Close buffer")
        .alt ['q'] = 'b # | bd #'
      (map "Previous buffer")
        ['<F13>'] = 'BufferLineCyclePrev'
      (map "Next buffer")
        ['<F14>'] = 'BufferLineCycleNext'
      map:register { as = 'cmd', modes = 'nicxsot' }
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
        html = { css = true },
        css = { css = true },
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
      local g = vim.api.nvim_create_augroup('VMlens', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = g,
        pattern = "visual_multi_start",
        callback = function() require('vmlens').start() end
      })
      vim.api.nvim_create_autocmd('User', {
        group = g,
        pattern = "visual_multi_exit",
        callback = function() require('vmlens').exit() end
      });
      (map "Search word")
        ['*'] = { plug = 'asterisk-z*', 'require("hlslens").start()' }
      (map "Search word backwards")
        ['#' ] = { plug = 'asterisk-z#', 'require("hlslens").start()' }
      (map "Go to search word")
        ['g*'] = { plug = 'asterisk-gz*', 'require("hlslens").start()' }
      (map "Go to search word backwards")
        ['g#'] = { plug = 'asterisk-gz#', 'require("hlslens").start()' }
      map:register { as = 'lua' }
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
      vim.cmd 'hi IncSearch gui=bold guifg=white';

      (map "Next match")
        ['n'] = function() vim.cmd('normal! ' .. vim.v.count1 .. 'n'); require('hlslens').start() end
      (map "Prev match")
        ['N'] = function() vim.cmd('normal! ' .. vim.v.count1 .. 'N'); require('hlslens').start() end
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
  use {
    'dstein64/nvim-scrollview',
    config = function()
      vim.g.scrollview_collumn = 1
      vim.g.scrollview_excluded_filetypes = {
        'aerial', 'packer', 'help'
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
    'junegunn/goyo.vim',
    keys = '<Leader>f',
    cmd = "Goyo",
    setup = function()
      vim.g.goyo_width = 150
      vim.api.nvim_create_autocmd('User', {
        pattern = 'GoyoEnter',
        command = "Gitsigns toggle_signs | ScrollViewDisable"
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'GoyoLeave',
        command = "hi Normal guibg=none ctermbg=none | Gitsigns toggle_signs | ScrollViewEnable"
      });
      (map "Distraction-free writing")
        ['<Space>f'] = 'Goyo'
      map:register { as = 'cmd' }
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
      (map "Inner indent")
        ['ai'] = { plug = 'textobj-indent-a' }
      (map "Outer indent")
        ['iI'] = { plug = 'textobj-indent-i' }
      (map "Last pattern")
        ['an'] = { plug = 'textobj-lastpat-n' }
      (map "Previous pattern")
        ['aN'] = { plug = 'textobj-lastpat-N' }
      map:register { modes = 'o' }
    end
  }


  use {
    'neovim/nvim-lsp',
    requires = {
      'onsails/lspkind-nvim',
      'neovim/nvim-lspconfig',
      'stevearc/aerial.nvim',
      'j-hui/fidget.nvim',
    },
    config = function()
      local lspkind = require('lspkind')
      lspkind.init {}

      local fidget = require('fidget')
      fidget.setup {
        window = {
          blend = 0,
        },
        fmt = {
          upwards = false,
        }
      }

      local aerial = require('aerial')
      aerial.setup {
        backends = { 'lsp', 'treesitter', 'markdown' },
        default_direction = "prefer_left",
        open_automatic = function(bufnr) return true end,
        markdown = { update_delay = 1000 },
        lsp = { update_delay = 1000 },
        treesitter = { update_delay = 1000 },
      }

      local cmp_nvim_lsp = require('cmp_nvim_lsp');
      local nvim_lsp = require('lspconfig')
      local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function on_attach(client, bufnr)
        aerial.on_attach(client, bufnr);

        -- Mappings.
        (map "Workspace folders")
          ['<Leader>wl'] = function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end
        (map "Add workspace folder")
          ['<Leader>wa'] = vim.lsp.buf.add_workspace_folder;
        (map "Remove workdspace folder")
          ['<Leader>wr'] = vim.lsp.buf.remove_workspace_folder;

        (map "Declaration")
          ['gD'] = vim.lsp.buf.declaration;
        (map "Definition")
          ['gd'] = vim.lsp.buf.definition;
        (map "Hover")
          ['K'] = vim.lsp.buf.hover;
        (map "Implementation")
          ['gi'] = vim.lsp.buf.implementation;
        (map "Signature")
          .ctrl ['k'] = vim.lsp.buf.signature_help;
        (map "Type")
          ['<Leader>D'] = vim.lsp.buf.type_definition;
        (map "Rename")
          ['<Leader>rn'] = vim.lsp.buf.rename;
        (map "References")
          ['gr'] = vim.lsp.buf.references;
        (map "Diagnostics")
          ['<Leader>e' ] = vim.lsp.diagnostic.show_line_diagnostics;
        (map "Previous diagnostic")
          ['[d'] = vim.lsp.diagnostic.goto_prev;
        (map "Next diagnostic")
          [']d'] = vim.lsp.diagnostic.goto_next;
        (map "Set loclist")
          ['<Leader>q'] = vim.lsp.diagnostic.set_loclist;

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
          (map "Document formatting")
            ['<Leader>f'] = vim.lsp.buf.formatting;
        elseif client.resolved_capabilities.document_range_formatting then
          (map "Range formatting")
            ['<Leader>f'] = vim.lsp.buf.range_formatting;
        end

        map:register { silent = true, remap = false, buffer = bufnr }

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_highlight then
          vim.cmd [[
            hi LspReferenceRead gui=underlineline
            hi LspReferenceText gui=underlineline
            hi LspReferenceWrite gui=underlineline
          ]]
          local g = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
          vim.api.nvim_create_autocmd('CursorHold', { callback = function() vim.lsp.buf.document_highlight() end, group = g, buffer = 0 })
          vim.api.nvim_create_autocmd('CursorMoved', { callback = function() vim.lsp.buf.clear_references() end, group = g, buffer = 0 })
        end
      end

      -- Enable snippet support
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        }
      }

      -- Use a loop to conveniently both setup defined servers
      -- and map buffer local keybindings when the language server attaches
      local servers = { "pyright", "bashls", "rust_analyzer", "clangd" }
      for _, server in ipairs(servers) do
        nvim_lsp[server].setup {
          on_attach = on_attach,
          capabilities = capabilities,
          flags = {
            debounce_text_changes = 150,
          }
        }
      end

      nvim_lsp.sumneko_lua.setup {
        cmd = { 'lua-language-server', '-E', '/usr/share/lua-language-server', "/main.lua" },
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            }
          },
          library = vim.api.nvim_get_runtime_file("", true),
          workspace = {
          },
          telemetry = {
            enable = false,
          },
        }
      }
    end
  }

  use {
    'windwp/nvim-autopairs',
    config = function()
      local autopairs = require('nvim-autopairs')
      autopairs.setup {
        check_ts = true,
        enable_check_bracket_line = true,
      }
    end
  }
  use {
    'L3MON4D3/LuaSnip',
    requires = {
      'rafamadriz/friendly-snippets'
    },
    config = function()
      require("luasnip/loaders/from_vscode").lazy_load()
    end
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      vim.o.completeopt = 'menu,menuone,noselect'
      local luasnip = require('luasnip')
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local cmp = require('cmp')
      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end
        },
        mapping = {
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
          ['<C-y>'] = cmp.config.disable,
          ['<C-e>'] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources {
          { name = 'luasnip', group_index = 1 },
          { name = 'nvim_lsp', group_index = 2 },
          { name = 'buffer', group_index = 3 },
          { name = 'path' },
          { name = 'cmdline' },
          { name = 'nvim_lua' },
        }
      }
      cmp.setup.cmdline('/', {
        sources = {
          { name = 'buffer' },
          { name = 'path' },
        }
      })
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources {
          { name = 'path', group_index = 1 },
          { name = 'nvim_lua', group_index = 2 },
          { name = 'cmdline', group_index = 3 },
        }
      })
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done {})
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
      project.setup {
        detection_methods = { "lsp", "pattern" },
        patterns = { "^.config" },
        silent_chdir = false,
      }
    end
  }
  use 'airodactyl/neovim-ranger'
  use {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.g.better_whitespace_filetypes_blacklist = { 'diff', 'pandoc', 'markdown', 'gitcommit', 'qf', 'help' }
      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function()
          for _, v in pairs(vim.g.better_whitespace_filetypes_blacklist) do
            if v == vim.o.ft then return end
          end
          vim.cmd 'EnableStripWhitespaceOnSave'
        end
      })
    end
  }


  use {
    'phaazon/hop.nvim',
    config = function()
      local hop = require('hop')
      hop.setup {
        inclusive_jump = true,
        uppercase_labels = true,
      };
      (map "Jump to a line")
        ['F'] = function() vim.cmd 'norm 0<CR>'; hop.hint_lines_skip_whitespace() end
      (map "Jump to a letter")
        ['f'] = function() hop.hint_char1() end
      map:split { modes = 'o' };

      (map "Jump to a line and focus on it")
        ['F'] = function() hop.hint_lines_skip_whitespace(); vim.cmd 'norm zz' end
      (map "Jump to a letter")
        ['f'] = function() hop.hint_char1() end
      map:register { modes = 'n' }
    end
  }
  use {
    'mfussenegger/nvim-treehopper',
    config = function()
      (map "Jump to a tree node")
        ['m'] = function() require('tsht').nodes() end
      (map "Jump to a tree node")
        ['m'] = { function() require('tsht').nodes() end, remap = false }
      map:register { modes = 'ov' }
    end
  }
  use 'chaoren/vim-wordmotion'
  use 'mg979/vim-visual-multi'

  use {
    'AndrewRadev/switch.vim',
    keys = 't',
    config = function()
      (map "Toggle value")
        ['t'] = 'Switch'
      map:register { as = 'cmd' }
    end
  }
  use {
    'junegunn/vim-easy-align',
    config = function()
      (map "Align by symbol")
        ['|'] = { plug = 'EasyAlign' }
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
    'saifulapm/chartoggle.nvim',
    config = function()
      local chartoggle = require('chartoggle')
      chartoggle.setup {
        leader = '<Leader>',
        keys = { ',', ';', "'", '"', ' ' }
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
        watch_gitdir = {
          interval = 5000,
          follow_files = true,
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
      'RRethy/nvim-treesitter-endwise',
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
        endwise = {
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
            ['<Space>'] = 'textsubjects-smart'
          }
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<CR>',
            scope_incremental = '<CR>',
            node_incremental = '<Tab>',
            node_decremental = '<S-Tab>',
          },
        },
      }
    end,
  }

  use {
    'plasticboy/vim-markdown',
    requires = {
      'godlygeek/tabular'
    },
    ft = 'markdown'
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
      };
      (map "Unmap space")
        ['<Space>'] = '<Nop>'
      (map "Space is the leader key!")
        ['<Space>'] = '<Leader>'
      map:split { remap = true };

      (map "Exit from terminal mode")
        ['<Esc><Esc>'] = 'stopinsert'
      (map "Exit from terminal mode and focus on center")
        ['<Esc><Esc><Esc>'] = 'stopinsert | call timer_start(100, { -> execute("norm M") }, {})'
      map:split { as = 'cmd', modes = 't', remap = false };

      (map "Close all non-file windows")
        ['<Esc><Esc>'] = { 'helpcl | lcl | ccl | nohls | silent! Goyo!', as = 'cmd' }

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
      (map "Toggle scrolloff")
        ['MM'] = { keepmiddle_toggle, remap = false }

      local function cursorcolumn_toggle()
        vim.wo.cursorcolumn = not vim.wo.cursorcolumn
      end
      (map "Toggle cursorcolumn")
        ['MC'] = { cursorcolumn_toggle, remap = false }

      (map "Undo")
        ['U'] = '<C-r>'

      (map "Create new file")
        .ctrl ['t'] = { '<Esc><Esc>:enew<CR>:redraw<CR>:w ~/', remap = true, modes = 'vto' }

      map:register { modes = 'n' }
    end
  }
end)
