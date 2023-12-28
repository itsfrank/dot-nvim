return {
    {
        "itsFrank/nvim-swell",
        config = function()
            vim.keymap.set("n", "<leader>z", "<Plug>(swell-toggle)")
        end,
    },
}
