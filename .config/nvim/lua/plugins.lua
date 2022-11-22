local PackerArguments = {}

PackerArguments.config = {
    compile_path = vim.fn.stdpath('data') .. '/site/plugin/packer_compiled.vim',
    display = {
        open_cmd = '90vnew \\[packer\\]'
    },
    autoremove = true,
}

PackerArguments[1] = function(use)

    use {
        'I60R/map-dsl.nvim',
        requires = 'folke/which-key.nvim',
        config = function()
            local map_dsl = require('map-dsl')
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

            local toggle = require('toggle');

            (map "Toggle scrolloff")
                ['MM'] = { toggle.scrolloff, remap = false }
            (map "Toggle cursorcolumn")
                ['MC'] = { toggle.cursorcolumn, remap = false }

            (map "Undo")
                ['U'] = '<C-r>'

            (map "Swap go to mark line with go to mark position")
                ["'"] = '`'
            (map "Swap go to mark position with go to mark line")
                ['`'] = "'"

            (map "Create new file")
                .ctrl['t'] = { '<Esc><Esc>:enew<CR>:redraw<CR>:w ~/', remap = true, modes = 'vto' }

            map:register { modes = 'n' }
        end
    }

    _G.use = function(spec)
        if type(spec.after) == 'string' then
            spec.after = { spec.after, }
        end
        spec.after[#spec.after+1] = "map-dsl.nvim"
    end

    use {
        'wbthomason/packer.nvim',
        config = function()
            local packer = require('packer')
            local arguments = require('plugins')
            packer.startup(arguments)
        end,
        cmd = {
            'PackerSync',
            'PackerCompile',
            'PackerClean',
            'PackerUpdate',
            'PackerInstall',
            'PackerStatus',
            'PackerProfile',
            'PackerSnapshot',
            'PackerSnapshotDelete',
            'PackerSnapshotRollback',
            'PackerLoad',
        }
    }

    use {
        'rebelot/kanagawa.nvim',
        config = function()
            local kanagawa = require('kanagawa')
            kanagawa.setup {
                transparent = true,
            }
            vim.cmd 'colorscheme kanagawa'
            vim.cmd 'syntax enable'
            vim.cmd 'hi! VertSplit guibg=NONE'
        end
    }

    use {
        'akinsho/nvim-bufferline.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        branch = 'main',
        config = function()
            local highlights = {}
            highlights.background = {
                bold = true
            }

            for _, v in ipairs {
                'tab', 'close_button', 'buffer', 'diagnostic',
                'info', 'info_diagnostic',
                'warning', 'warning_diagnostic',
                'error', 'error_diagnostic',
                'modified', 'duplicate', 'separator', 'indicator', 'pick', 'numbers',
            } do
                highlights[v .. '_selected'] = {
                    bg = '#7E9CD8'
                }
            end

            local bufferline = require('bufferline')
            bufferline.setup {
                options = {
                    right_mouse_command = 'vertical sbuffer %d',
                    middle_mouse_command = 'bdelete! %d',
                    diagnostics = true,
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local icon = level:match("error") and " " or " "
                        return " " .. icon .. count
                    end,
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                    always_show_bufferline = false,
                    numbers = function(numbers)
                        return numbers.ordinal .. '-' .. numbers.lower(numbers.id) .. ' '
                    end,
                    separator_style = { '', '' },
                    indicator = {
                        style = 'icon'
                    },
                    color_icons = true,
                    show_tab_indicators = false,
                    custom_areas = {
                        right = function()
                            local result = {}
                            local git = vim.b.gitsigns_status_dict
                            local added = git['added']
                            if added > 0 then
                                result[#result + 1] = { text = tostring(added), fg = 'grey' }
                                result[#result + 1] = { text = '樂', fg = 'DarkGreen' }
                            end
                            local removed = git['removed']
                            if removed > 0 then
                                result[#result + 1] = { text = tostring(removed), fg = 'grey' }
                                result[#result + 1] = { text = ' ', fg = 'DarkRed' }
                            end
                            local changed = git['changed']
                            if changed > 0 then
                                result[#result + 1] = { text = tostring(changed), fg = 'grey' }
                                result[#result + 1] = { text = 'ﰣ ', fg = 'DarkYellow' }
                            end
                            result[#result + 1] = { text = ' ' .. git.head, fg = 'white', bold = true }
                            return result
                        end,
                    },
                },
                highlights = highlights,
            }

            for n = 1, 9 do
                local function focus_nth_buffer() require('bufferline').go_to_buffer(n) end

                (map "Go to (" .. n .. ") buffer")
                    .alt[n] = { focus_nth_buffer, remap = false, silent = true };
            end

            (map "Pick a buffer")
                .alt['`'] = 'BufferLinePick'
            (map "Previous buffer")
                .alt['Left'] = 'BufferLineCyclePrev'
            (map "Next buffer")
                .alt['Right'] = 'BufferLineCycleNext'
            (map "Close buffer")
                .alt['q'] = 'b # | bd #'
            (map "Previous buffer")
                ['<F13>'] = 'BufferLineCyclePrev'
            (map "Next buffer")
                ['<F14>'] = 'BufferLineCycleNext'

            map:register { as = 'cmd', modes = 'nicxsot' }
        end
    }

    use {
        'chentoast/marks.nvim',
        config = function()
            local marks = require('marks')
            marks.setup {
                builtin_marks = { ".", "[", "]", "^", "'", '"', },
            }
        end
    }
    use {
        'RRethy/vim-illuminate',
        config = function()
            local illuminate = require('illuminate')
            illuminate.configure {
                providers = {
                    'lsp',
                    'treesitter',
                },
                delay = 500,
            }
        end
    }
    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            vim.o.termguicolors = true
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
                ['#'] = { plug = 'asterisk-z#', 'require("hlslens").start()' }
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
                virt_priority = 0,
            }
            vim.cmd 'hi IncSearch gui=bold guifg=white';

            (map "Next match")
                ['n'] = function()
                    vim.cmd('normal! ' .. vim.v.count1 .. 'n')
                    require('hlslens').start()
                end
            (map "Prev match")
                ['N'] = function()
                    vim.cmd('normal! ' .. vim.v.count1 .. 'N')
                    require('hlslens').start()
                end

            map:register { remap = false }
        end
    }
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            local indent_blankline = require('indent_blankline')
            indent_blankline.setup {
                char = '┊',
                use_treesitter = true,
                buftype_exclude = {
                    'aerial',
                    'terminal',
                    'help',
                },
                show_current_context = true,
                show_current_context_start = true,
            }
            vim.cmd 'hi! link IndentBlanklineContextStart QuickFixLine'
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
            numb.setup {
                number_only = true
            }
        end
    }
    use {
        'dstein64/nvim-scrollview',
        config = function()
            local scrollview = require('scrollview')
            scrollview.setup {
                column = 1,
                winblend = 20,
                base = 'left',
                excluded_filetypes = {
                    'aerial',
                    'packer',
                    'help',
                },
            }
        end
    }
    use {
        'tpope/vim-characterize',
        keys = 'ga'
    }

    use {
        'folke/zen-mode.nvim',
        config = function()
            vim.cmd 'hi Normal guibg=#00000000';

            local toggle = require('toggle')
            local zen_mode = require('zen-mode')
            zen_mode.setup {
                window = {
                    backdrop = 0.5,
                    width = 120,
                    height = 0.85,
                },
                on_open = toggle.scrolloff,
                on_close = toggle.scrolloff,
            };

            (map "Toggle zen mode")
                ['<F11>'] = function() require('zen-mode').toggle() end

            map:register {}
        end
    }

    use {
        'rainbowhxch/accelerated-jk.nvim',
        config = function()

            (map "Accelerated j")
                ['j'] = { plug = 'accelerated_jk_j', modes = 'n' }
            (map "Accelerated k")
                ['k'] = { plug = 'accelerated_jk_k', modes = 'n' }

            map:register {}
        end
    }
    use 'kana/vim-repeat'
    use {
        "kylechui/nvim-surround",
        config = function()
            local surround = require("nvim-surround")
            surround.setup {}
        end
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
        'neovim/nvim-lspconfig',
        requires = {
            'j-hui/fidget.nvim',
            'stevearc/aerial.nvim',
            'folke/neodev.nvim',
            'kosayoda/nvim-lightbulb',
            'ray-x/lsp_signature.nvim',
        },
        config = function()
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
                on_attach = function(bufnr)

                    (map "Jump next aerial")
                        ['{'] = 'AerialPrev'
                    (map "Jump next aerial")
                        ['}'] = 'AerialNext'

                    map:register {
                        as = 'cmd',
                        buffer = bufnr,
                    }
                end,
                backends = {
                    'lsp',
                    'treesitter',
                    'man',
                },
                layout = {
                    default_direction = "prefer_left",
                },
                close_automatic_events = {
                    'unsupported'
                },
                open_automatic = function(bufnr)
                    if aerial.num_symbols(bufnr) ~= 0 then
                        vim.api.nvim_create_autocmd('BufDelete', {
                            buffer = bufnr,
                            command = 'AerialCloseAll',
                        })
                        return true
                    else
                        return false
                    end
                end,
                ignore = {
                    buftypes = {
                        'special',
                        'terminal',
                    }
                },
                lsp = {
                    update_delay = 1000
                },
                treesitter = {
                    update_delay = 1000
                },
            }

            local lua_dev = require('neodev');
            lua_dev.setup {
                lspconfig = true,
                library = {
                    enabled = true,
                    runtime = true,
                    types = true,
                    plugins = true,
                },
                setup_jsonls = false,
            }

            local lspconfig = require('lspconfig')
            local capabilities = vim.lsp.protocol.make_client_capabilities();

            (map "Diagnostics")
                ['<Leader>e'] = vim.diagnostic.open_float;
            (map "Previous diagnostic")
                ['[d'] = vim.diagnostic.goto_prev;
            (map "Next diagnostic")
                [']d'] = vim.diagnostic.goto_next;
            (map "Set loclist")
                ['<Leader>q'] = vim.diagnostic.setloclist;

            map:register { silent = true }


            local cmp_nvim_lsp = require('cmp_nvim_lsp')
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

            local function on_attach(client, bufnr)
                local lsp_signature = require('lsp_signature')
                lsp_signature.on_attach({}, bufnr)

                local nvim_lightbulb = require('nvim-lightbulb')
                nvim_lightbulb.setup {
                    autocmd = {
                        enabled = true,
                        pattern = { '*' },
                        events = {
                            'CursorHold',
                            'CursorHoldI',
                        }
                    },
                    sign = {
                        enabled = false
                    },
                    float = {
                        enabled = true
                    }
                };

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
                    .ctrl['k'] = vim.lsp.buf.signature_help;
                (map "Type")
                    ['<Leader>D'] = vim.lsp.buf.type_definition;
                (map "Rename")
                    ['<Leader>rn'] = vim.lsp.buf.rename;
                (map "References")
                    ['gr'] = vim.lsp.buf.references;

                -- Set some keybinds conditional on server capabilities
                if client.server_capabilities.document_formatting then
                    (map "Document formatting")
                        ['<Leader>f'] = vim.lsp.buf.formatting;
                elseif client.server_capabilities.document_range_formatting then
                    (map "Range formatting")
                        ['<Leader>f'] = vim.lsp.buf.range_formatting;
                end

                map:register { silent = true, buffer = bufnr }

                -- Set autocommands conditional on server_capabilities
                if client.server_capabilities.document_highlight then
                    vim.cmd [[
                        hi LspReferenceRead gui=underlineline
                        hi LspReferenceText gui=underlineline
                        hi LspReferenceWrite gui=underlineline
                    ]]
                    local group = vim.api.nvim_create_augroup('lsp_document_highlight', {
                        clear = true
                    })
                    vim.api.nvim_create_autocmd('CursorHold', {
                        callback = function() vim.lsp.buf.document_highlight() end,
                        group = group,
                        buffer = 0,
                    })
                    vim.api.nvim_create_autocmd('CursorMoved', {
                        callback = function() vim.lsp.buf.clear_references() end,
                        group = group,
                        buffer = 0,
                    })
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
            local servers = {
                "pyright",
                "bashls",
                "rust_analyzer",
                "clangd",
            }
            for _, server in ipairs(servers) do
                lspconfig[server].setup {
                    on_attach = on_attach,
                    capabilities = capabilities,
                    flags = {
                        debounce_text_changes = 150,
                    }
                }
            end

            lspconfig.sumneko_lua.setup {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace"
                        }
                    }
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
            'onsails/lspkind-nvim',
        },
        config = function()
            vim.o.completeopt = 'menu,menuone,noselect'

            local luasnip = require('luasnip')
            local function has_words_before()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local function line_empty()
                local line = vim.api.nvim_get_current_line()
                local line_trimmed = line:gsub("^%s*(.-)%s*$", "%1")
                return line_trimmed == ''
            end

            local function str_ends_with(str, ending)
               return ending == "" or ending == nil or str:sub(-#ending) == ending
            end

            local lspkind = require('lspkind')
            lspkind.init {}

            local cmp = require('cmp')
            cmp.setup {
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',
                        maxwidth = 50,
                    })
                },
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-Space>'] = function()
                        if cmp.visible() then
                            cmp.select_next_item()
                            cmp.mapping.complete {}
                        else
                            cmp.mapping.complete {}
                        end
                    end,
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-y>'] = cmp.config.disable,
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping(
                        function(fallback)
                            if line_empty() and cmp.get_active_entry() == nil then
                                fallback()
                            elseif cmp.visible() then
                                cmp.mapping.confirm { select = true }
                            else
                                fallback()
                            end
                        end
                    ),
                    ["<Tab>"] = cmp.mapping(
                        function(fallback)
                            if line_empty() and cmp.get_active_entry() == nil then
                                cmp.abort()
                                fallback()
                            elseif cmp.visible() then
                                cmp.select_next_item()
                                cmp.complete()
                            elseif luasnip.expand_or_jumpable() then
                                luasnip.expand_or_jump()
                            elseif has_words_before() then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end,
                        { "i", "s" }
                    ),
                    ["<S-Tab>"] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            elseif luasnip.jumpable(-1) then
                                luasnip.jump(-1)
                            else
                                fallback()
                            end
                        end,
                        { "i", "s" }
                    ),
                },
                sources = cmp.config.sources {
                    { name = 'luasnip', group_index = 1 },
                    { name = 'nvim_lsp', group_index = 2 },
                    { name = 'buffer', group_index = 3 },
                    { name = 'path', group_index = 4 },
                    { name = 'cmdline', group_index = 5 },
                    { name = 'nvim_lua', group_index = 6 },
                }
            }
            cmp.setup.cmdline('/', {
                sources = {
                    { name = 'buffer', group_index = 1 },
                    { name = 'path', group_index = 2 },
                }
            })
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources {
                    { name = 'cmdline', group_index = 1 },
                    { name = 'path', group_index = 2 },
                    { name = 'nvim_lua', group_index = 3 },
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
                detection_methods = { "pattern", "lsp", },
                patterns = { "^.config" },
                silent_chdir = false,
            }
        end
    }
    use 'airodactyl/neovim-ranger'

    use {
        'phaazon/hop.nvim',
        config = function()
            local hop = require('hop')
            hop.setup {
                inclusive_jump = true,
                uppercase_labels = true,
            };

            (map "Jump to a line")
                ['f'] = function() vim.cmd 'norm V'; hop.hint_lines_skip_whitespace() end
            (map "Jump to a letter")
                ['F'] = function() hop.hint_words() end

            map:split { modes = 'o' };

            (map "Jump to a line and focus on it")
                ['f'] = function() hop.hint_lines_skip_whitespace(); vim.cmd 'norm zz' end
            (map "Jump to a letter")
                ['F'] = function() hop.hint_words() end

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
    use {
        'mizlan/iswap.nvim',
        config = function()

            (map "Swap with")
                ['s'] = { 'ISwapWith', as = 'cmd' }

            map:register {}
        end
    }
    use {
        'chaoren/vim-wordmotion',
        setup = function()
            vim.g.wordmotion_mappings = {
                w = 'W',
                b = 'B',
                e = 'E',
                ge = 'gE',
                aw = 'aW',
                iw = 'iW',
                W = 'w',
                B = 'b',
                E = 'e',
                gE = 'ge',
                aW = 'aw',
                iW = 'iw',
            }
        end
    }
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
        'numToStr/Comment.nvim',
        config = function()
            local comment = require('Comment')
            comment.setup {
                toggler = {
                    line = ';h',
                    block = ';;h',
                },
                opleader = {
                    line = ';',
                    block = ';;',
                },
                extra = {
                    above = ';k',
                    below = ';j',
                    eol = ';l',
                },
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
    use 'chrisbra/unicode.vim'
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
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            local gitsigns = require('gitsigns')
            gitsigns.setup {
                watch_gitdir = {
                    interval = 5000,
                    follow_files = true,
                },
                numhl = true,
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol',
                    delay = 0,
                    ignore_whitespace = false,
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
            vim.cmd 'hi! link TreesitterContext QuickFixLine'
            vim.cmd 'hi! link TreesitterContextLineNumber QuickFixLine'

            local tree_sitter = require('nvim-treesitter.configs')
            tree_sitter.setup {
                ensure_installed = 'all',
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
                        scope_incremental = '<Tab>',
                        node_incremental = '<CR>',
                        node_decremental = '<S-Tab>',
                    },
                },
            }
            local tree_sitter_context = require('treesitter-context')
            tree_sitter_context.setup {
                max_lines = 1,
                patterns = {
                    default = {
                        'class',
                        'function',
                        'method',
                        'field',
                        'for',
                        'while',
                        'if',
                        'switch',
                        'case',
                    }
                }
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
    use {
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        ft = { "markdown" },
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_browser = "chromium"
        end,
    }

    use 'dzeban/vim-log-syntax'

    use 'arjunmahishi/run-code.nvim'
    use 'nvim-treesitter/playground'

    use {
        'zakharykaplan/nvim-retrail',
        config = function()
            local retrail = require('retrail')
            retrail.setup {
                filetype = {
                    exclude = {
                        "",
                        "alpha",
                        "checkhealth",
                        "diff",
                        "help",
                        "lspinfo",
                        "man",
                        "terminal",
                        "Trouble",
                        "WhichKey",
                        "aerial",
                        "pager",
                    }
                }
            }
        end
    }
end


return PackerArguments
