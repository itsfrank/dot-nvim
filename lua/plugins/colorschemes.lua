return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        branch = "canary", -- TODO: when v2.0.0 ships remove this
        priority = 1000,
        config = function()
            ---@diagnostic disable:missing-fields
            require("rose-pine").setup({
                variant = "auto",
                dark_variant = "main",
                palette = {
                    -- more contrast for pine
                    main = {
                        pine = "#419abe",
                    },
                },
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
                terminal_colors = true,
            })
        end,
    },
}
