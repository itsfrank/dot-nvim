return { -- improved search & replace (and other fun stuff)
    "smjonas/live-command.nvim",
    config = function()
        require("live-command").setup({
            commands = {
                -- preview macros
                Macro = {
                    cmd = "norm",
                    -- This will transform ":5Reg a" into ":norm 5@a"
                    args = function(opts)
                        return (opts.count == -1 and "" or opts.count) .. "@" .. opts.args
                    end,
                    range = "",
                },
            },
        })
    end,
}
