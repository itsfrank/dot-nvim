return {
    { "EdenEast/nightfox.nvim" },
    {
        "rose-pine/neovim",
        name = "rose-pine",
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
}
