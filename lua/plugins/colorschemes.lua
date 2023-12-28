return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        branch = "canary", -- TODO: when v2.0.0 ships remove this
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                before_highlight = function(group, highlight, palette)
                    -- more contyrast for pine
                    if highlight.fg == palette.pine then
                        highlight.fg = "#419abe"
                    end

                    -- fix the faxt that search results are white, matching the cursor
                    if group == "Search" then
                        highlight.fg = palette.base
                        highlight.bg = palette.iris
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
}
