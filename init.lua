-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd('packadd packer.nvim')
end

require('packer').startup(function(use)
    -- Package manager
    use 'wbthomason/packer.nvim'

    use { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        requires = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            'j-hui/fidget.nvim',

            -- Additional lua configuration, makes nvim stuff amazing
            'folke/neodev.nvim',
        },
    }

    -- icons
    use { 'nvim-tree/nvim-web-devicons' }

    -- workspaces management
    use { 'natecraddock/workspaces.nvim' }

    -- start page
    use {
        'goolord/alpha-nvim',
        config = 'require("frank.dashboard")'
    }

    -- better git diffview
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
    -- fzf stuff cause telesope is slow on game engine
    use { 'junegunn/fzf', run = './install --bin', } -- fzf
    use { 'junegunn/fzf.vim' } -- fzf vim plugin

    -- improved search & replace (and other fun stuff)
    use { 'smjonas/live-command.nvim',
        config = function()
            require("live-command").setup {
                commands = {
                    S = { cmd = "Subvert" }, -- must be defined before we import vim-abolish
                },
            }
        end
    }

    -- cool search plugin kinda like vscodes global search
    use { 'windwp/nvim-spectre', requires = 'nvim-lua/plenary.nvim' }

    use { 'tpope/vim-abolish' }

    use { -- Autocompletion
        'hrsh7th/nvim-cmp',
        requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    }

    use { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    }

    use { -- Additional text objects via treesitter
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }

    use { -- Auto cleanup whitespace
        'lewis6991/spaceless.nvim',
        config = function()
            require 'spaceless'.setup()
        end
    }

    use { -- Easier terminal window management
        "akinsho/toggleterm.nvim", tag = '*', config = function()
            require("toggleterm").setup({
                size = 40,
            })
        end
    }

    -- Git related plugins
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'
    use 'lewis6991/gitsigns.nvim'

    use { "catppuccin/nvim", as = "catppuccin" }
    use 'nvim-lualine/lualine.nvim' -- Fancier statusline
    use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
    use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
    use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

    -- Fuzzy Finder (files, lsp, etc)
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

    -- Telescope based file browser (alternative to netrw)
    use { "nvim-telescope/telescope-file-browser.nvim" }

    -- Multi-Cursor
    use 'mg979/vim-visual-multi'

    use {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    }

    use { 'joechrisellis/lsp-format-modifications.nvim' }
    -- end packer plugin list

    -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
    local has_plugins, plugins = pcall(require, 'custom.plugins')
    if has_plugins then
        plugins(use)
    end

    if is_bootstrap then
        require('packer').sync()
    end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
    print '=================================='
    print '    Plugins are being installed'
    print '    Wait until Packer completes,'
    print '       then restart nvim'
    print '=================================='
    return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
    group = packer_group,
    pattern = vim.fn.expand '$MYVIMRC',
})

local os_info = require('frank.os-info')
-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- highlight line cursor is on
vim.o.cursorline = true
-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd.colorscheme "catppuccin"

-- override cursor line nr so its the same color as other colors, otherwise with cursorline its distracting
local line_nr_color = vim.api.nvim_get_hl_by_name('LineNr', true)
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = line_nr_color.foreground })

-- from primeagen
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
if os_info:is_windows() then
    vim.opt.undodir = os.getenv("HOMEPATH") .. "/.vim/undodir"
elseif os_info:is_mac() or os_info:is_linux() then
    vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
    },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
    char = '┊',
    show_trailing_blankline_indent = false,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
    defaults = {
        -- path_display = { "smart" },
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
                ["<C-h>"] = "which_key",
            },
            n = {
                ["<C-h>"] = "which_key",
            },
        },
        pickers = {
            find_files = {
                find_command = {
                    'fd',
                    '--type',
                    'file',
                    '--type',
                    'symlink',
                    '--hidden',
                    '--exclude',
                    '.git',
                    -- put your other patterns here
                }
            }
        },
    },
    extensions = {
        file_browser = {
            hijack_netrw = true,
            hidden = true,
        },
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
    },
}

-- fzf config
vim.fn.setenv("FZF_DEFAULT_COMMAND", 'fd --type f --color=always')
vim.fn.setenv("FZF_DEFAULT_OPTS",
    "--ansi --layout reverse --preview 'bat --color=always --style=header,grid --line-range :300 {}' ")
vim.g.fzf_layout = { up = '~90%',
    window = { width = 0.9, height = 0.9, yoffset = 0.5, xoffset = 0.5, border = 'rounded' } }

-- for xome reason fzfz_colors isnt working on my windows PC, so I deen to do this
if os_info:is_windows() then
    -- thes eoptions will need to be re-generated when colorscheme is changed
    -- on a machione where fzf_colors works do: `:echo fzf#wrap().options`
    vim.fn.setenv("FZF_DEFAULT_OPTS", os.getenv("FZF_DEFAULT_OPTS") .. " " ..
        "--color=bg+:#2a2b3c,bg:#1e1e2e,spinner:#74c7ec,hl:#585b70 " ..
        "--color=fg:#cdd6f4,pointer:#cba6f7,info:#f5c2e7,header:#585b70 " ..
        "--color=marker:#cba6f7,fg+:#cdd6f4,prompt:#cba6f7,hl+:#cba6f7")
elseif os_info:is_mac() or os_info:is_linux() then
    vim.g.fzf_colors = {
        ['fg'] = { 'fg', 'Normal' },
        ['bg'] = { 'bg', 'Normal' },
        ['hl'] = { 'fg', 'Comment' },
        ['fg+'] = { 'fg', 'CursorLine', 'CursorColumn', 'Normal' },
        ['bg+'] = { 'bg', 'CursorLine', 'CursorColumn' },
        ['hl+'] = { 'fg', 'Statement' },
        ['info'] = { 'fg', 'PreProc' },
        ['border'] = { 'fg', 'Normal' },
        ['prompt'] = { 'fg', 'Conditional' },
        ['pointer'] = { 'fg', 'Exception' },
        ['marker'] = { 'fg', 'Keyword' },
        ['spinner'] = { 'fg', 'Label' },
        ['header'] = { 'fg', 'Comment' }
    }
end
-- Franks keymaps
vim.keymap.set('n', '<leader>cs', ':let @/ = ""<cr>', { desc = "[C]lear [S]earch" })
vim.keymap.set('n', '<leader>ls', '^', { desc = "[L]ine [S]tart" })
vim.keymap.set('n', '<leader>le', 'g_', { desc = "[L]ine [E]nd" })
vim.keymap.set('v', '<leader>ls', '^', { desc = "[L]ine [S]tart" })
vim.keymap.set('v', '<leader>le', 'g_', { desc = "[L]ine [E]nd" })
vim.keymap.set('n', '<leader>fta', ':Format<cr>', { desc = "[F]orma[T] [A]ll - formats enire buffer" })
vim.keymap.set('n', '<leader>ftm', ':FormatModifications<cr>',
    { desc = "[F]orma[T] [M]odifications - formats modifications in this buffer" })

-- Git DiffView Keymaps
vim.keymap.set('n', '<leader>gdvo', ':DiffviewOpen<cr>', { desc = '[G]it [D]iff [V]iew [O]pen' })
vim.keymap.set('n', '<leader>gdvc', ':DiffviewClose<cr>', { desc = '[G]it [D]iff [V]iew [C]lose' })

-- system clipboard keymaps
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank to system cpliboar' })
vim.keymap.set('n', '<leader>Y', '"+yg_', { desc = 'Yank to system cpliboar' })
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Yank to system cpliboar' })
vim.keymap.set('n', '<leader>yy', '"+yy', { desc = 'Yank to system cpliboar' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from system clipboar' })
vim.keymap.set('n', '<leader>P', '"+P', { desc = 'Paste from system clipboar' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste from system clipboar' })
vim.keymap.set('v', '<leader>P', '"+P', { desc = 'Paste from system clipboar' })
vim.keymap.set('t', '<c-p>', '<c-\\><c-n>pi', { desc = 'Paste in terminal mode' })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
        layout_config = { width = 0.8 },
    })
end, { desc = '[/] Fuzzily search in current buffer]' })

-- using fzf to find files instead of telescope
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>sf', ':Files<cr>', { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>sg', ':Rg<cr>', { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>km', require('telescope.builtin').keymaps, { desc = '[K]ey [M]aps' })

-- Telescope file browser
require("telescope").load_extension "file_browser"
vim.keymap.set("n", "<leader>fb", require('telescope').extensions.file_browser.file_browser,
    { desc = '[F]ile [B]rowser' })

require('telescope').load_extension("workspaces")
vim.keymap.set("n", "<leader>wk", require('telescope').extensions.workspaces.workspaces,
    { desc = 'Search [W]or[K] spaces' })

-- Toggleterm keymaps
vim.keymap.set('n', '<leader>``', ":ToggleTerm<cr>", { desc = "Toggle terminal view" })
vim.keymap.set('n', '<leader>`v', ":ToggleTerm direction=vertical <cr>", { desc = "Toggle [H]orizontal terminal view" })
vim.keymap.set('n', '<leader>`h', ":ToggleTerm direction=horizontal <cr>", { desc = "Toggle [V]ertical terminal view" })
vim.keymap.set('n', '<leader>`f', ":ToggleTerm direction=float <cr>", { desc = "Toggle [F]loat terminal view" })

vim.keymap.set('t', '<C-space>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'vim', 'help' },

    highlight = { enable = true },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
    -- lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', ':CodeActionMenu<cr>', '[C]ode [A]ction')
    -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
    -- Adds command `:FormatModifications`
    local lsp_format_modifications = require "lsp-format-modifications"
    lsp_format_modifications.attach(client, bufnr, { format_on_save = true })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
    clangd = {},
    -- gopls = {},
    -- pyright = {},
    pyright = {},
    rust_analyzer = {},
    -- tsserver = {},

    sumneko_lua = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
        }
    end,
}

-- setup workspaces
require("workspaces").setup({
    hooks = {
        open = { "Telescope find_files" },
        -- open = { "Files" },
    }
})

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-s>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
    view = {
        entries = { name = 'custom', selection_order = 'bottom_up' }
    },
}
