return {
    { -- git commands from the nvim cmdline
        "tpope/vim-fugitive",
        init = function()
            vim.g.fugitive_legacy_commands = 0
        end,
    },
}
