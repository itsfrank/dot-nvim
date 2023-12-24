return {
    {
        "johmsalas/text-case.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("textcase").setup({
                default_keymappings_enabled = false,
            })
            require("telescope").load_extension("textcase")
        end,
    },
}
