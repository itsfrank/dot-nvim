return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        branch = "canary", -- TODO: when v2.0.0 ships remove this
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                before_highlight = function(_, highlight, palette)
                    if highlight.fg == palette.pine then
                        highlight.fg = "#419abe"
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
