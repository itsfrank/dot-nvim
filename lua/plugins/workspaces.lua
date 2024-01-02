return { -- workspaces management
    "natecraddock/workspaces.nvim",
    config = function()
        -- setup workspaces
        require("workspaces").setup({
            hooks = {
                -- open = { "Telescope find_files" },
                open = {
                    function(_, path)
                        require("oil").open(path)
                    end,
                },
            },
        })
    end,
}
