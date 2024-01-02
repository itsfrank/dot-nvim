return { -- auto close pairs
    "echasnovski/mini.pairs",
    config = function()
        require("mini.pairs").setup({
            mappings = {
                ['"'] = false,
                ["'"] = false,
                ["`"] = false,
            },
        })
    end,
}
