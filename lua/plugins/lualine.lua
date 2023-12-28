return {
    {
        -- Fancier statusline
        "nvim-lualine/lualine.nvim",
        config = function()
            -- referesh lualine when we enter or leave a libmodal mode
            vim.api.nvim_create_autocmd("User", {
                pattern = "DebugLayerChanged",
                callback = function()
                    require("lualine").refresh({ scope = "window", place = { "statusline" } })
                end,
            })

            require("lualine").setup({
                options = {
                    icons_enabled = false,
                    theme = "rose-pine-alt",
                    component_separators = "|",
                    section_separators = "",
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                        },
                        {
                            function() -- auto change color according the vim mode
                                local base = vim.api.nvim_get_hl_by_name("lualine_a_insert", true)
                                vim.api.nvim_set_hl(0, "LibmodalMode", base)
                                return "DEBUG"
                            end,
                            icon = { "▊", align = "left" },
                            color = "LibmodalMode",
                            cond = function()
                                local debug_layer = require("frank.debug.debug-layer")
                                return debug_layer.layer:is_active()
                            end,
                        },
                    },
                    lualine_b = {
                        {
                            "filename",
                            file_status = true, -- Displays file status (readonly status, modified status)
                            newfile_status = true, -- Display new file status (new file means no write after created)
                            path = 1,
                            -- 0: Just the filename
                            -- 1: Relative path
                            -- 2: Absolute path
                            -- 3: Absolute path, with tilde as the home directory
                        },
                    },
                    lualine_c = { "diff" },
                    lualine_x = { "aerial", "branch" },
                },
            })
        end,
    },
}
