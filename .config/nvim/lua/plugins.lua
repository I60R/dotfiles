local plugins = {
    {
        'I60R/map-dsl.nvim',
        dependencies = 'folke/which-key.nvim',
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
            }

            ;(map "Unmap space")
                ['<Space>'] = '<Nop>'
            ;(map "Space is the leader key!")
                ['<Space>'] = '<Leader>'

            map:split { remap = true }

            ;(map "Exit from terminal mode")
                ['<Esc><Esc>'] = 'stopinsert'
            ;(map "Exit from terminal mode and focus on center")
                ['<Esc><Esc><Esc>'] = 'stopinsert | call timer_start(100, { -> execute("norm M") }, {})'

            map:split { as = 'cmd', modes = 't', remap = false }

            ;(map "Close all non-file windows")
                ['<Esc><Esc>'] = { 'helpclose | lclose | cclose | nohlsearch', as = 'cmd' }

            local toggle = require('toggle')

            ;(map "Toggle scrolloff")
                ['MM'] = { toggle.scrolloff, remap = false }
            ;(map "Toggle cursorcolumn")
                ['MC'] = { toggle.cursorcolumn, remap = false }

            ;(map "Undo")
                ['U'] = '<C-r>'

            ;(map "Swap go to mark line with go to mark position")
                ["'"] = '`'
            ;(map "Swap go to mark position with go to mark line")
                ['`'] = "'"

            ;(map "Create new file")
                .ctrl['t'] = { '<Esc><Esc>:enew<CR>:redraw<CR>:w ~/', remap = true, modes = 'vto' }

            map:register { modes = 'n' }
        end
    },

    {
        'folke/lazy.nvim',
        config = function()
            local packer = require('lazy')
            local plugins = require('plugins')
            packer.startup(plugins)
        end,
        cmd = 'Lazy',
    },

    {
        'rebelot/kanagawa.nvim',
        config = function()
            local kanagawa = require('kanagawa')
            kanagawa.setup {
                transparent = true,
            }
            vim.cmd 'colorscheme kanagawa'
            vim.cmd 'syntax enable'

            vim.api.nvim_set_hl(0, 'VertSplit', {
                ctermbg = 0
            })
        end
    },

    {
        'akinsho/nvim-bufferline.lua',
        dependencies = {
            'I60R/map-dsl.nvim',
            'lewis6991/gitsigns.nvim',
            'kyazdani42/nvim-web-devicons',
        },
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

                ;(map "Go to (" .. n .. ") buffer")
                    .alt[n] = { focus_nth_buffer, remap = false, silent = true };
            end

            ;(map "Pick a buffer")
                .alt['`'] = 'BufferLinePick'
            ;(map "Previous buffer")
                .alt['Left'] = 'BufferLineCyclePrev'
            ;(map "Next buffer")
                .alt['Right'] = 'BufferLineCycleNext'
            ;(map "Close buffer")
                .alt['q'] = 'b # | bd #'
            ;(map "Previous buffer")
                ['<F13>'] = 'BufferLineCyclePrev'
            ;(map "Next buffer")
                ['<F14>'] = 'BufferLineCycleNext'

            map:register { as = 'cmd', modes = 'nicxsot' }
        end
    },

    {
        'chentoast/marks.nvim',
        config = function()
            local marks = require('marks')
            marks.setup {
                builtin_marks = { ".", "^", "'", '"', "`" },
            }
            vim.api.nvim_set_hl(0, 'MarkSignNumHL', {
                link = 'LineNr'
            })
        end
    },
    {
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
    },
    {
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
    },
    {
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
    },
    {
        'haya14busa/vim-asterisk',
        dependencies = 'I60R/map-dsl.nvim',
        setup = function()
            vim.g['asterisk#keeppos'] = 1
        end,
        config = function()
            ( map "Search word")
                ['*'] = { plug = 'asterisk-z*', 'require("hlslens").start()' }
            ;(map "Search word backwards")
                ['#'] = { plug = 'asterisk-z#', 'require("hlslens").start()' }
            ;(map "Go to search word")
                ['g*'] = { plug = 'asterisk-gz*', 'require("hlslens").start()' }
            ;(map "Go to search word backwards")
                ['g#'] = { plug = 'asterisk-gz#', 'require("hlslens").start()' }

            map:register { as = 'lua' }
        end
    },
    {
        'kevinhwang91/nvim-hlslens',
        dependencies = 'I60R/map-dsl.nvim',
        config = function()
            local hlslens = require('hlslens')
            hlslens.setup {
                calm_down = true,
                nearest_float_when = 'never',
                virt_priority = 0,
            }

            vim.api.nvim_set_hl(0, 'IncSearch', {
                bold = true,
                ctermfg = 'white'
            })

            ;(map "Next match")
                ['n'] = function()
                    vim.cmd('normal! ' .. vim.v.count1 .. 'n')
                    require('hlslens').start()
                end
            ;(map "Prev match")
                ['N'] = function()
                    vim.cmd('normal! ' .. vim.v.count1 .. 'N')
                    require('hlslens').start()
                end

            map:register { remap = false }
        end
    },
    {
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

            vim.api.nvim_set_hl(0, 'IndentBlanklineContextStart', {
                link = 'QuickFixLine'
            })
        end
    },
    {
        'winston0410/range-highlight.nvim',
        dependencies = 'winston0410/cmd-parser.nvim',
        config = function()
            local range_hl = require('range-highlight')
            range_hl.setup {}
        end
    },
    {
        'nacro90/numb.nvim',
        config = function()
            local numb = require('numb')
            numb.setup {
                number_only = true
            }
        end
    },
    {
        'dstein64/nvim-scrollview',
        config = function()
            local scrollview = require('scrollview')
            scrollview.setup {
                column = 1,
                winblend = 20,
                excluded_filetypes = {
                    'aerial',
                    'packer',
                    'help',
                },
            }
        end
    },
    {
        'tpope/vim-characterize',
        keys = 'ga'
    },

    {
        'folke/zen-mode.nvim',
        dependencies = 'I60R/map-dsl.nvim',
        config = function()
            vim.api.nvim_set_hl(0, "ZenBg", {
                ctermbg = 0,
            })

            local toggle = require('toggle')
            local zen_mode = require('zen-mode')
            zen_mode.setup {
                window = {
                    backdrop = 1.0,
                    width = 120,
                    height = 0.85,
                },
                on_open = toggle.scrolloff,
                on_close = toggle.scrolloff,
            }


            ;(map "Toggle zen mode")
                ['<F11>'] = function() require('zen-mode').toggle() end

            map:register {}
        end
    },

    {
        'rainbowhxch/accelerated-jk.nvim',
        dependencies = 'I60R/map-dsl.nvim',
        config = function()

            ( map "Accelerated j")
                ['j'] = { plug = 'accelerated_jk_j', modes = 'n' }
            ;(map "Accelerated k")
                ['k'] = { plug = 'accelerated_jk_k', modes = 'n' }

            map:register {}
        end
    },
    {'kana/vim-repeat'},
    {
        "kylechui/nvim-surround",
        config = function()
            local surround = require("nvim-surround")
            surround.setup {}
        end
    },


    {
        'kana/vim-textobj-user',
        dependencies = {
            'I60R/map-dsl.nvim',
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

            ( map "Inner indent")
                ['ai'] = { plug = 'textobj-indent-a' }
            ;(map "Outer indent")
                ['iI'] = { plug = 'textobj-indent-i' }
            ;(map "Last pattern")
                ['an'] = { plug = 'textobj-lastpat-n' }
            ;(map "Previous pattern")
                ['aN'] = { plug = 'textobj-lastpat-N' }

            map:register { modes = 'o' }
        end
    },


    {
        'stevearc/aerial.nvim',
        dependencies = 'I60R/map-dsl.nvim',
        config = function ()
            local aerial = require('aerial')
            aerial.setup {
                on_attach = function(bufnr)

                    ( map "Jump next aerial")
                        ['{'] = 'AerialPrev'
                    ;(map "Jump next aerial")
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
        end
    },
    {
        'ray-x/lsp_signature.nvim',
        config = function ()
            local lsp_signature = require('lsp_signature')
            lsp_signature.setup {
                bind = false,
                handler_opts = {
                    border = "none"
                }
            }
        end
    },
    {
        'j-hui/fidget.nvim',
        config = function ()
            local fidget = require('fidget')
            fidget.setup {
                window = {
                    blend = 0,
                },
                fmt = {
                    upwards = false,
                }
            }
        end
    },
    {
        "glepnir/lspsaga.nvim",
        branch = "main",
        dependencies = 'I60R/map-dsl.nvim',
        config = function()
            local saga = require("lspsaga")
            saga.init_lsp_saga {
                border_style = "bold",
                saga_winblend = 25,
                max_preview_lines = 60,
                code_action_lightbulb = {
                    virtual_text = false
                }
            }

            ;(map "LSP actions")
                ['<F3>'] = 'Lspsaga code_action'
            ;(map "LSP rename")
                ['<F2>'] = 'Lspsaga rename'
            ;(map "LSP peek definition")
                .leader['d'] = 'Lspsaga peek_definition'
            ;(map "LSP line diagnostic")
                .leader['l'] = 'Lspsaga show_line_diagnostics'
            ;(map "LSP cursor diagnostic")
                .leader['c'] = 'Lspsaga show_cursor_diagnostics'
            ;(map "LSP hover doc")
                ['K'] = 'Lspsaga hover_doc'
            ;(map "LSP hover doc")
                .ctrl['K'] = 'Lspsaga lsp_finder'


            map:split { as = 'cmd', silent = true }


            ;(map "LSP next diagnostic")
                ['<F8>'] = function()
                    require("lspsaga.diagnostic")
                        .goto_prev({ severity = vim.diagnostic.severity.ERROR })
                end
            ;(map "LSP next diagnostic")
                .shift['<F8>'] = function()
                    require("lspsaga.diagnostic")
                        .goto_next({ severity = vim.diagnostic.severity.ERROR })
                end

            map:register { silent = true }
        end,
    },
    {
        'folke/neodev.nvim',
        dependencies = 'neovim/nvim-lspconfig',
        config = function()
            local lua_dev = require('neodev');
            lua_dev.setup {
                library = {
                    enabled = true,
                    runtime = true,
                    types = true,
                    plugins = true,
                },
                lspconfig = true,
                setup_jsonls = false,
            }
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'I60R/map-dsl.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            local lspconfig = require('lspconfig')
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            ;(map "Diagnostics")
                .leader['e'] = vim.diagnostic.open_float
            ;(map "Previous diagnostic")
                ['[d'] = vim.diagnostic.goto_prev
            ;(map "Next diagnostic")
                [']d'] = vim.diagnostic.goto_next
            ;(map "Set loclist")
                .leader['q'] = vim.diagnostic.setloclist

            map:register { silent = true }

            local cmp_nvim_lsp = require('cmp_nvim_lsp')
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

            local function on_attach(client, bufnr)
                -- Mappings.
                ( map "Workspace folders")
                    .leader['wl'] = function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end
                ;(map "Add workspace folder")
                    .leader['wa'] = vim.lsp.buf.add_workspace_folder
                ;(map "Remove workdspace folder")
                    .leader['wr'] = vim.lsp.buf.remove_workspace_folder

                ;(map "Declaration")
                    ['gD'] = vim.lsp.buf.declaration
                ;(map "Definition")
                    ['gd'] = vim.lsp.buf.definition
                ;(map "Hover")
                    ['K'] = vim.lsp.buf.hover
                ;(map "Implementation")
                    ['gi'] = vim.lsp.buf.implementation
                ;(map "Signature")
                    .ctrl['k'] = vim.lsp.buf.signature_help
                ;(map "Type")
                    .leader['D'] = vim.lsp.buf.type_definition
                ;(map "Rename")
                    .leader['rn'] = vim.lsp.buf.rename
                ;(map "References")
                    ['gr'] = vim.lsp.buf.references

                -- Set some keybinds conditional on server capabilities
                if client.server_capabilities.document_formatting then
                    ( map "Document formatting")
                        .leader['f'] = vim.lsp.buf.formatting;
                elseif client.server_capabilities.document_range_formatting then
                    ( map "Range formatting")
                        .leader['f'] = vim.lsp.buf.range_formatting;
                end

                map:register { silent = true, buffer = bufnr }

                -- Set autocommands conditional on server_capabilities
                if client.server_capabilities.document_highlight then
                    vim.api.nvim_set_hl(0, 'LspReferenceRead', {
                        underdouble = true
                    })
                    vim.api.nvim_set_hl(0, 'LspReferenceText', {
                        underdouble = true
                    })
                    vim.api.nvim_set_hl(0, 'LspReferenceWrite ', {
                        underdouble = true
                    })

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

            -- a loop to conveniently both setup defined servers
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
    },

    {
        'windwp/nvim-autopairs',
        config = function()
            local autopairs = require('nvim-autopairs')
            autopairs.setup {
                check_ts = true,
                enable_check_bracket_line = true,
            }
        end
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'rafamadriz/friendly-snippets'
        },
        config = function()
            require("luasnip/loaders/from_vscode").lazy_load()
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
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
            local lspkind = require('lspkind')

            local function has_words_before()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                local curr_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
                return col ~= 0 and curr_line:sub(col, col):match("%s") == nil
            end

            local function line_empty(line)
                return line:match("^%s*(.-)%s*$") == ""
            end

            local function begins_with(str, beginning)
               return beginning == "" or str:sub(1, #beginning) == beginning
            end

            local cmp = require('cmp')
            cmp.setup {
                formatting = {
                    format = lspkind.cmp_format {
                        mode = 'symbol_text',
                        maxwidth = 80,
                    }
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                enabled = function()
                    -- disable completion in comments
                    local context = require 'cmp.config.context'
                    -- keep command mode completion enabled when cursor is in a comment
                    if vim.api.nvim_get_mode().mode == 'c' then
                        return true
                    else
                        return not context.in_treesitter_capture("comment")
                          and not context.in_syntax_group("Comment")
                    end
                end,
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
                    ['<Up>'] = cmp.mapping(function (fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                            cmp.complete()
                        else
                            fallback()
                        end
                    end),
                    ['<Down>'] = cmp.mapping(function (fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                            cmp.complete()
                        else
                            fallback()
                        end
                    end),
                    ['<CR>'] = cmp.mapping(
                        function(fallback)
                            if cmp.get_selected_entry() == nil then
                                fallback()
                            else
                                cmp.complete()
                                cmp.confirm { select = true }
                                cmp.abort()
                            end
                        end
                    ),
                    ["<Tab>"] = cmp.mapping(
                        function(fallback)
                            local line = vim.api.nvim_get_current_line()
                            local active_entry = cmp.get_selected_entry()
                            local cmp_visible = cmp.visible()
                            local cword = vim.fn.expand('<cword>') or ""
                            local words_before = has_words_before()

                            if active_entry ~= nil then
                                active_entry = active_entry
                                    .cache
                                    .entries
                                    .get_completion_item
                                    .filter_text
                            end

                            if line_empty(line) and active_entry == nil then
                                fallback()
                            elseif cmp_visible and active_entry == nil then
                                if words_before then
                                    cmp.select_next_item()
                                    cmp.complete()
                                else
                                    fallback()
                                end
                            elseif cmp_visible
                                and active_entry ~= nil
                                and begins_with(active_entry, cword)
                            then
                                cmp.confirm { select = true }
                            elseif cmp_visible then
                                cmp.select_next_item()
                                cmp.complete()
                            elseif luasnip.expand_or_jumpable() then
                                luasnip.expand_or_jump()
                            elseif words_before then
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
    },

    {
        'lotabout/skim',
        dependencies = 'lotabout/skim.vim',
        build = './install',
    },
    {
        'w0rp/ale',
        cmd = 'ALEEnable'
    },
    {
        'sbdchd/neoformat',
        cmd = 'Neoformat'
    },

    {'kopischke/vim-stay'},
    {'tpope/vim-sleuth'},
    {
        "ahmedkhalf/project.nvim",
        config = function()
            local project = require("project_nvim")
            project.setup {
                detection_methods = {
                    "pattern",
                    "lsp",
                },
                patterns = { "^.config" },
                silent_chdir = false,
            }
        end
    },
    {'airodactyl/neovim-ranger'},

    {
        'phaazon/hop.nvim',
        dependencies = 'I60R/map-dsl.nvim',
        config = function()
            local hop = require('hop')
            hop.setup {
                inclusive_jump = true,
                uppercase_labels = true,
            }

            ;(map "Jump to a line")
                ['f'] = function() vim.cmd 'norm V'; hop.hint_lines_skip_whitespace() end
            ;(map "Jump to a letter")
                ['F'] = function() hop.hint_words() end

            map:split { modes = 'o' }

            ;(map "Jump to a line and focus on it")
                ['f'] = function() hop.hint_lines_skip_whitespace(); vim.cmd 'norm zz' end
            ;(map "Jump to a letter")
                ['F'] = function() hop.hint_words() end

            map:register { modes = 'n' }
        end
    },
    {
        'mfussenegger/nvim-treehopper',
        dependencies = 'I60R/map-dsl.nvim',
        config = function()

            ( map "Jump to a tree node")
                ['m'] = function() require('tsht').nodes() end
            ;(map "Jump to a tree node")
                ['m'] = { function() require('tsht').nodes() end, remap = false }

            map:register { modes = 'ov' }
        end
    },
    {
        'mizlan/iswap.nvim',
        dependencies = 'I60R/map-dsl.nvim',
        config = function()

            ( map "Swap with")
                ['s'] = { 'ISwapWith', as = 'cmd' }

            map:register {}
        end
    },
    {
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
    },
    {
        'mg979/vim-visual-multi',
        config = function ()
            local group = vim.api.nvim_create_augroup('VMlens', { clear = true })
            vim.api.nvim_create_autocmd('User', {
                group = group,
                pattern = "visual_multi_start",
                callback = function()
                    require('vmlens').start()
                end
            })
            vim.api.nvim_create_autocmd('User', {
                group = group,
                pattern = "visual_multi_exit",
                callback = function()
                    require('vmlens').exit()
                end
            })


        end
    },

    {
        'AndrewRadev/switch.vim',
        dependencies = 'I60R/map-dsl.nvim',
        keys = 't',
        config = function()

            ( map "Toggle value")
                ['t'] = 'Switch'

            map:register { as = 'cmd' }
        end
    },
    {
        'junegunn/vim-easy-align',
        dependencies = 'I60R/map-dsl.nvim',
        config = function()

            ( map "Align by symbol")
                ['|'] = { plug = 'EasyAlign' }

            map:register { modes = 'nxv' }
        end
    },
    {'matze/vim-move'},
    {'triglav/vim-visual-increment'},
    {'terryma/vim-expand-region'},
    {
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
    },
    {
        'saifulapm/chartoggle.nvim',
        config = function()
            local chartoggle = require('chartoggle')
            chartoggle.setup {
                leader = '<Leader>',
                keys = { ',', ';', "'", '"', ' ' }
            }
        end
    },
    {
        'tommcdo/vim-exchange',
        keys = 'cx'
    },
    {
        'arthurxavierx/vim-caser',
        keys = 'gs'
    },


    {'aperezdc/vim-template'},
    {'antoyo/vim-licenses'},
    {'chrisbra/unicode.vim'},
    {'fidian/hexmode'},
    {
        'lambdalisue/suda.vim',
        setup = function()
            vim.g['suda#prefix'] = 'sudo://'
            vim.g['suda_smart_edit'] = true
        end
    },

    {
        'gisphm/vim-gitignore',
        ft = 'gitignore'
    },
    {
        'lewis6991/gitsigns.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
	        'I60R/map-dsl.nvim',
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
                    delay = 1000,
                    ignore_whitespace = false,
                }
            }

            ;(map "Stage hunk")
                .leader['hs'] = 'Gitsigns stage_hunk'
            ;(map "Undo stage hunk")
                .leader['hS'] = 'Gitsigns undo_stage_hunk'
            ;(map "Preview hunk")
                .leader['hh'] = 'Gitsigns preview_hunk'
            ;(map "Preview hunk")
                .leader['hr'] = 'Gitsigns reset_hunk'
            ;(map "Next hunk")
                ['g]'] = 'Gitsigns next_hunk'
            ;(map "Prev hunk")
                ['g['] = 'Gitsigns prev_hunk'

            map:register { as = 'cmd' }
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        dependencies = {
            'romgrk/nvim-treesitter-context',
            'RRethy/nvim-treesitter-textsubjects',
            'RRethy/nvim-treesitter-endwise',
            'windwp/nvim-ts-autotag',
        },
        config = function()
            vim.api.nvim_set_hl(0, 'TreesitterContext', {
                link = 'QuickFixLine'
            })
            vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', {
                link = 'QuickFixLine'
            })

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
                        'html',
                        'javascript',
                        'javascriptreact',
                        'typescriptreact',
                        'svelte',
                        'vue',
                        'markdown',
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
    },
    {
        'Wansmer/treesj',
        dependencies = {
            'I60R/map-dsl.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            local treesj = require('treesj')
            treesj.setup {
                use_default_keymaps = false,
            }

            ;(map "Split/join node")
                .ctrl['J'] = 'TSJToggle'

            map:register { as = 'cmd' }
        end,
    },

    {
        'plasticboy/vim-markdown',
        dependencies = {
            'godlygeek/tabular'
        },
        ft = 'markdown'
    },
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_browser = "chromium"
        end,
    },

    {'dzeban/vim-log-syntax'},

    {'arjunmahishi/run-code.nvim'},
    {'nvim-treesitter/playground'},

    {
        'I60R/nvim-retrail',
        config = function()
            local retrail = require('retrail')
            retrail.setup { }
        end
    },
}

return plugins
