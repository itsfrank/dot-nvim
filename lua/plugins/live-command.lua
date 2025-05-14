return { -- improved search & replace (and other fun stuff)
    "smjonas/live-command.nvim",
    config = function()
        require("live-command").setup({
            commands = {
                Norm = { cmd = "norm" },
            },
        })
    end,
}
