local os_info = require("frank.utils.os-info")
local neovim_ascii = {
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}

local hello_frank_train_ascii = {
    [[           _                 _       _                        __                            _    ]],
    [[    o O O | |_      ___     | |     | |     ___     ___      / _|    _ _   __ _    _ _     | |__ ]],
    [[   o      | ' \    / -_)    | |     | |    / _ \   |___|    |  _|   | '_| / _` |  | ' \    | / / ]],
    [[  ||__[O] |_||_|   \___|   _|_|_   _|_|_   \___/   _____   _|_|_   _|_|_  \__,_|  |_||_|   |_\_\ ]],
    [[ {======|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|     |_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|]],
    [[./o--000'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-']],
}

local neovim_train_ascii = {
    [[                                              _            ]],
    [[     o o o  _ _      ___     ___    __ __    (_)    _ __   ]],
    [[    o      | ' \    / -_)   / _ \   \ V /    | |   | '  \  ]],
    [[   ||__[O] |_||_|   \___|   \___/   _\_/_   _|_|_  |_|_|_| ]],
    [[  {======|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| ]],
    [[ ./o--000'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' ]],
}

local alpha = require("alpha")
local lazy = require("lazy")
local max_width = 55
local hl_green = "String"
local hl_blue = "Label"
local hl_yellow = "Type"
local hl_red = "Error"

local function button(sc, txt, keybind, keybind_opts)
    local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

    local opts = {
        position = "center",
        shortcut = sc,
        cursor = 5,
        width = max_width,
        align_shortcut = "right",
        hl_shortcut = "Normal",
        hl = hl_green,
    }

    if keybind then
        keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
    end

    return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
    }
end

-- Text header
local header = {
    type = "text",
    -- val = neovim_ascii,
    val = neovim_train_ascii,
    -- val = hello_frank_train_ascii,
    opts = {
        position = "center",
        type = "ascii",
        hl = hl_blue,
    },
}

-- Button groups
local quick_link_btns = {
    type = "group",
    val = {
        { type = "text", val = "QUICK LINKS", opts = { hl = hl_blue, position = "center" } },
        { type = "padding", val = 1 },
        button("SPC n f", "  New File", ":ene <BAR> startinsert<CR>"),
        button("SPC f b", "  File Browser", ":Telescope file_browser<CR>"),
        button("SPC w k", "  Workspaces", ":Telescope workspaces<CR>"),
    },
    opts = {
        hl = hl_green,
        position = "center",
    },
}

local config_paths = {
    neovim = "~/.config/nvim/",
    wezterm = "~/.config/wezterm/",
}
if os_info:is_windows() then
    config_paths.neovim = "C:\\Users\\fobrien\\AppData\\Local\\nvim"
end

local config_btns = {
    type = "group",
    val = {
        { type = "text", val = "CONFIGS", opts = { hl = hl_blue, position = "center" } },
        { type = "padding", val = 1 },
        button("SPC c", "  Config Files", ":cd ~/.config<CR> :Telescope file_browser<CR>"),
        button("SPC c 1", "    Neovim", ":cd " .. config_paths.neovim .. "<CR> :e init.lua<CR>"),
        button("SPC c 2", "    Wezterm", ":cd " .. config_paths.wezterm .. "<CR> :e wezterm.lua<CR>"),
    },
    opts = {
        position = "center",
        hl = hl_green,
    },
}

local misc_btns = {
    type = "group",
    val = {
        button("q", "  Quit", ":qa<CR>"),
    },
    opts = {
        position = "center",
    },
}

-- Footer
local lazy_stats = lazy.stats()
local footer_plugins = {
    type = "group",
    val = {
        {
            type = "text",
            val = "  " .. lazy_stats.count .. " plugins installed",
            opts = { position = "center", hl = hl_blue },
        },
    },
    opts = {
        position = "center",
        hl = hl_green,
    },
}

local footer_config_status = {
    type = "text",
    val = " checking config status",
    opts = { position = "center", hl = hl_blue },
}

local footer_uncommitted_status = {
    type = "text",
    val = "",
    opts = { position = "center", hl = hl_yellow },
}
local config = {
    layout = {
        { type = "padding", val = 2 },
        header,
        { type = "padding", val = 3 },
        quick_link_btns,
        { type = "padding", val = 1 },
        config_btns,
        { type = "padding", val = 2 },
        misc_btns,
        { type = "padding", val = 3 },
        footer_plugins,
        { type = "padding", val = 1 },
        footer_config_status,
        footer_uncommitted_status,
    },
    opts = {
        noautocmd = false,
        redraw_on_resize = true,
    },
}

-- wait for lazy to finish loading and populate plugin data
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function()
        local lazy_stats = require("lazy").stats()
        footer_plugins.val = {
            {
                type = "text",
                val = "  " .. lazy_stats.count .. " plugins installed",
                opts = { position = "center", hl = hl_blue },
            },
            {
                type = "text",
                val = "  " .. lazy_stats.loaded .. " plugins loaded in " .. lazy_stats.startuptime .. "ms",
                opts = { position = "center", hl = hl_blue },
            },
        }
        pcall(vim.cmd.AlphaRedraw)
    end,
})

-- check git status of nvim config
local config_version_check = require("frank.config-version-check")
config.opts.setup = function()
    config_version_check:after(vim.schedule_wrap(function()
        local result = config_version_check:result()
        local behind = tonumber(result.behind)
        local ahead = tonumber(result.ahead)
        local behind_string = result.behind
        local ahead_string = result.ahead

        if ahead > 0 and behind > 0 then
            footer_config_status.val = " config [ ahead | behind ] by [ "
                .. ahead_string
                .. " | "
                .. behind_string
                .. " ] commits"
            footer_config_status.opts.hl = hl_red
        elseif ahead > 0 then
            footer_config_status.val = " config ahead by " .. ahead_string .. " commits"
            footer_config_status.opts.hl = hl_yellow
        elseif behind > 0 then
            footer_config_status.val = " config behind by " .. behind_string .. " commits"
            footer_config_status.opts.hl = hl_red
        else
            footer_config_status.val = " config up-to-date"
            footer_config_status.opts.hl = hl_green
        end
        if result.has_uncommitted then
            footer_uncommitted_status.val = "  config has uncommitted changes"
        end
        alpha.redraw()
    end))

    config_version_check:start()
end

alpha.setup(config)
