local neovim_ascii = {
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}

local alpha = require('alpha')
local max_width = 55
local hl1 = 'String'
local hl2 = 'Label'

local function get_plugins_list()
    local short_name = require('packer.util').get_plugin_short_name
    local list_plugins = require('packer.plugin_utils').list_installed_plugins

    local opt, start = list_plugins()
    local plugin_paths = vim.tbl_extend('force', opt, start)
    local plugins = {}

    for path in pairs(plugin_paths) do
        local name, _ = short_name({ path }):gsub('.nvim', '')
        table.insert(plugins, name)
    end

    table.sort(plugins)

    return plugins
end

local function button(sc, txt, keybind, keybind_opts)
    local sc_ = sc:gsub('%s', ''):gsub('SPC', '<leader>')

    local opts = {
        position = 'center',
        shortcut = sc,
        cursor = 5,
        width = max_width,
        align_shortcut = 'right',
        hl_shortcut = 'Normal',
        hl = hl2
    }

    if keybind then
        keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { 'n', sc_, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. '<Ignore>', true, false, true)
        vim.api.nvim_feedkeys(key, 't', false)
    end

    return {
        type = 'button',
        val = txt,
        on_press = on_press,
        opts = opts
    }
end

-- Text header
local header = {
    type = 'text',
    val = neovim_ascii,
    opts = {
        position = 'center',
        type = 'ascii',
        hl = hl1,
    }
}

-- Button groups
local quick_link_btns = {
    type = 'group',
    val = {
        { type = 'text', val = 'QUICK LINKS', opts = { hl = hl1, position = 'center' } },
        { type = 'padding', val = 1 },
        button('SPC n f', '  New File', ':ene <BAR> startinsert<CR>'),
        button('SPC f b', '  File Browser', ':Telescope file_browser<CR>'),
        button('SPC w k', '  Workspaces', ':Telescope workspaces<CR>'),
    },
    opts = {
        hl = hl2,
        position = 'center'
    }
}

local config_btns = {
    type = 'group',
    val = {
        { type = 'text', val = 'CONFIGS', opts = { hl = hl1, position = 'center' } },
        { type = 'padding', val = 1 },
        button('SPC c', '  Config Files', ':cd ~/.config<CR> :Telescope file_browser<CR>'),
        button('SPC c 1', '    Neovim', ':cd ~/.config/nvim/<CR> :e init.lua<CR>'),
        button('SPC c 2', '    Wezterm', ':cd ~/.config/wezterm/<CR> :e wezterm.lua<CR>'),
    },
    opts = {
        position = 'center',
        hl = hl2
    }
}

local misc_btns = {
    type = 'group',
    val = {
        button('q', '  Quit', ':qa<CR>'),
    },
    opts = {
        position = 'center',
    }
}

-- Footer
local plugins = get_plugins_list()

local footer1 = {
    type = 'text',
    val = '  ' .. (#plugins) .. ' plugins installed',
    opts = {
        position = 'center',
        hl = hl1
    }
}

local config = {
    layout = {
        { type = 'padding', val = 2 },
        header,
        { type = 'padding', val = 3 },
        quick_link_btns,
        { type = 'padding', val = 1 },
        config_btns,
        { type = 'padding', val = 2 },
        misc_btns,
        { type = 'padding', val = 3 },
        footer1,
    },
    opts = {
        noautocmd = false,
        redraw_on_resize = true,
    }
}

alpha.setup(config)
