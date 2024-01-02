return {
    "akinsho/git-conflict.nvim",
    version = "1.1.1",
    config = function()
        require("git-conflict").setup({
            default_mappings = false, -- disable buffer local mapping created by this plugin
        })
    end,
}
