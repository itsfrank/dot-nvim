return { -- suround stuff easily
    "echasnovski/mini.surround",
    config = function()
        require("mini.surround").setup({
            mappings = {
                add = "<leader>wa", -- Add surrounding in Normal and Visual modes
                delete = "<leader>wd", -- Delete surrounding
                replace = "<leader>wr",

                -- disable all the others
                find = "", -- Find surrounding (to the right)
                find_left = "", -- Find surrounding (to the left)
                highlight = "", -- Highlight surrounding
                update_n_lines = "", -- Update `n_lines`
                suffix_last = "", -- Suffix to search with "prev" method
                suffix_next = "", -- Suffix to search with "next" method
            },
        })
    end,
}
