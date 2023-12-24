return {
    {
        -- Add indentation guides even on blank lines
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            local colors = require("frank.utils.colors")
            -- want it to be bearely visible
            local function make_ibl_hl()
                local normal = colors.get_color_from_hl("Normal")
                if normal.background == nil then
                    normal.background = "#000000"
                end
                local hl_fg = colors.brighten(normal.background, 20)

                vim.api.nvim_set_hl(0, "IblHighlight", { fg = hl_fg })
            end
            make_ibl_hl()
            -- update our hlgroup when the colorscheme changes
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = function()
                    make_ibl_hl()
                end,
            })

            require("ibl").setup({
                enabled = false, -- start disabled, use `:IBLToggle` to turn on
                indent = {
                    char = "┊",
                    highlight = "IblHighlight",
                },
                scope = { enabled = false },
            })
        end,
    },
}
