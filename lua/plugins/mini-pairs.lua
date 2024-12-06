return { -- auto close pairs
    "echasnovski/mini.pairs",
    enabled = false,
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
