return {
    {
        -- install the actual fzf binary
        "junegunn/fzf",
        build = function()
            vim.fn["fzf#install"]()
        end,
    },
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "junegunn/fzf", "nvim-tree/nvim-web-devicons" },
        config = function()
            require("fzf-lua").setup({
                "borderless",
                keymap = {
                    builtin = {
                        ["<M-p>"] = "toggle-preview",
                    },
                    fzf = {
                        ["tab"] = "down",
                        ["shift-tab"] = "up",
                    },
                },
                winopts = {
                    border = "none",
                    height = 0.95,
                    width = 0.90,
                    preview = {
                        border = "none",
                        hidden = "hidden",
                    },
                },
                defaults = {
                    git_icons = true,
                    file_icons = true,
                },
            })

            vim.keymap.set("n", "<leader>sf", ":FzfLua files<cr>", { silent = true, desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>sg", ":FzfLua live_grep<cr>", { silent = true, desc = "[S]earch by [G]rep" })
        end,
    },
}
