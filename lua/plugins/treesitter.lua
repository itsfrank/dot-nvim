return {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = function()
        pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = {
                "c",
                "cpp",
                "go",
                "http",
                "json",
                "lua",
                "luau",
                "markdown",
                "markdown_inline",
                "ocaml",
                "python",
                "rust",
                "typescript",
                "vim",
                "vimdoc",
            },
            highlight = { enable = true },
            indent = { enable = true, disable = { "python" } },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<c-c>",
                    node_incremental = "<c-c>",
                    node_decremental = "<c-r>",
                    scope_incremental = "<c-f>",
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["ib"] = "@codeblock.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]a"] = "@parametr.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]C"] = "@class.outer",
                        ["]A"] = "@parametr.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[a"] = "@parametr.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[A"] = "@parametr.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>A"] = "@parameter.inner",
                    },
                },
            },
        })

        require("treesitter-context").setup({
            max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
        })
    end,
}
