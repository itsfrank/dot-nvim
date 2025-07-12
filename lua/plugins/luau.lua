return {
    dir = "~/frk/rbx-luau-nvim",
    -- url = "https://github.rbx.com/fobrien/rbx-luau.nvim.git",
    dependencies = {
        "lopi-py/luau-lsp.nvim",
    },

    config = function()
        -- where you set up your plugin, likel in the lazy.nvim plugin object `config` function
        local rbx_luau = require("rbx-luau")
        rbx_luau.setup({
            autostart_sourcemap_watcher = true, -- automatically start watching lua[u] file in rbxp projects
        })

        -- set up luau-lsp
        require("luau-lsp").setup({
            platform = {
                type = "roblox",
            },
            types = {
                roblox_security_level = "RobloxScriptSecurity", -- we have internal permissions!
                definition_files = { "~/misc/luau-definitions/ComponentTypes.d.luau" },
            },
            sourcemap = {
                enabled = true, -- disable rojo-based sourcemap gen to silence errors
                autogenerate = false, -- automatically generate sourcemaps for luau files
            },
        })

        -- we use .lua for luau files, in rbxp projects, consider .lua as luau files
        if rbx_luau.is_rbxp_project(vim.fn.getcwd()) then
            vim.filetype.add({
                extension = {
                    lua = function(path)
                        return path:match("%.nvim%.lua$") and "lua" or "luau"
                    end,
                },
            })
        end
    end,
}
