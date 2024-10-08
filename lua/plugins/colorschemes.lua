return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        branch = "canary", -- TODO: when v2.0.0 ships remove this
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                before_highlight = function(group, highlight, palette)
                    -- more contrast for pine
                    if highlight.fg == palette.pine then
                        highlight.fg = "#419abe"
                    end

                    -- fix the search results being white, matching the cursor
                    if group == "Search" then
                        highlight.fg = palette.base
                        highlight.bg = palette.iris
                    end

                    if
                        group == "markdownH1"
                        or group == "markdownH2"
                        or group == "markdownH3"
                        or group == "markdownH4"
                        or group == "markdownH5"
                        or group == "markdownH6"
                        or group == "@markup.heading"
                        or group == "Title"
                    then
                        highlight.fg = palette.foam
                    end
                end,
            })
        end,
    },
    {
        -- fancy colors meow!
        "catppuccin/nvim",
        as = "catppuccin",
        priority = 1000,
    },
    {
        "nyoom-engineering/oxocarbon.nvim",
        as = "oxocarbon",
        priority = 1000,
    },
    {
        "ribru17/bamboo.nvim",
        priority = 1000,
        config = function()
            require("bamboo").setup({})
        end,
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("cyberdream").setup({
                -- Recommended - see "Configuring" below for more config options
                transparent = true,
                italic_comments = true,
                hide_fillchars = true,
                borderless_telescope = true,
                terminal_colors = true,
            })
        end,
    },
}
