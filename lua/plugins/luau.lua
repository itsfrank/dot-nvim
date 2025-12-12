local function best_sourcemap_rbxp()
    -- check if "analyze.rbxp" exists in the current directory
    if vim.fn.filereadable("analyze.rbxp") == 1 then
        return "analyze.rbxp"
    end
    return "default.rbxp"
end
return {
    {
        "lopi-py/luau-lsp.nvim",
        config = function()
            if not require("frank.utils.os-info").is_work_laptop() then
                return -- we configure below in that case
            end
            --- @diagnostic disable-next-line: missing-fields
            require("luau-lsp").setup({
                -- todo: figure out what options I like
            })
        end,
    },
    {
        dir = "~/frk/rbx-luau-nvim",
        -- url = "https://github.rbx.com/fobrien/rbx-luau.nvim.git",
        dependencies = {
            "lopi-py/luau-lsp.nvim",
        },
        enabled = function()
            -- only enable on work laptop
            return require("frank.utils.os-info").is_work_laptop()
        end,
        config = function()
            -- where you set up your plugin, likel in the lazy.nvim plugin object `config` function
            local rbx_luau = require("rbx-luau")
            rbx_luau.setup({
                autostart_sourcemap_watcher = false, -- automatically start watching lua[u] file in rbxp projects
                notify = false,
                -- command = { "rplug", "-p", "sourcemap", "--rbxp", picked_rbxp },
                forward_command_output_to_file = false,
            })

            -- utility to find foundation tags
            vim.keymap.set("n", "<leader>FF", function()
                require("rbx-luau").pick_foundation_tag()
            end, { desc = "pick foundation tag" })

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

            vim.lsp.config("luau-lsp", {
                settings = {
                    ["luau-lsp"] = {
                        index = {
                            maxFiles = 100000,
                        },
                    },
                },
            })

            local picked_rbxp = best_sourcemap_rbxp()
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
                    autogenerate = true, -- automatically generate sourcemaps for luau files
                    generator_cmd = { "rplug", "-p", "sourcemap", "--rbxp", picked_rbxp, "-w" },
                },
            })
        end,
    },
}
