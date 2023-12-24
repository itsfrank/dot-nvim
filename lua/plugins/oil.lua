return {
    { -- File broswer that behaves like a buffer
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                keymaps = {
                    -- yank full path of a file into the default register
                    ["<C-y>"] = "actions.copy_entry_path",
                },
                view_options = {
                    show_hidden = true,
                },
            })

            vim.keymap.set(
                "n",
                "<leader>-",
                require("oil").open,
                { desc = "oil: Open file-explorer in parent directory [-]" }
            )
        end,
    },
}
