if vim.fn.executable("tree-sitter") ~= 1 then
    vim.notify("tree-sitter CLI is not installed; skipping nvim-treesitter setup", vim.log.levels.WARN)
    return {}
end

return {
    {
        "romus204/tree-sitter-manager.nvim",
        dependencies = {}, -- tree-sitter CLI must be installed system-wide
        config = function()
            require("tree-sitter-manager").setup({
                -- Default Options
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
                    "python",
                    "rust",
                    "toml",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                },
                move = {
                    set_jumps = true,
                },
            })

            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")
            local swap = require("nvim-treesitter-textobjects.swap")

            vim.keymap.set({ "x", "o" }, "aa", function()
                select.select_textobject("@parameter.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ia", function()
                select.select_textobject("@parameter.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "af", function()
                select.select_textobject("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "if", function()
                select.select_textobject("@function.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ac", function()
                select.select_textobject("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ic", function()
                select.select_textobject("@class.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ib", function()
                select.select_textobject("@codeblock.inner", "textobjects")
            end)

            vim.keymap.set({ "n", "x", "o" }, "]f", function()
                move.goto_next_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]c", function()
                move.goto_next_start("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]a", function()
                move.goto_next_start("@parameter.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]M", function()
                move.goto_next_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]C", function()
                move.goto_next_end("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]A", function()
                move.goto_next_end("@parameter.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[f", function()
                move.goto_previous_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[c", function()
                move.goto_previous_start("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[a", function()
                move.goto_previous_start("@parameter.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[F", function()
                move.goto_previous_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[C", function()
                move.goto_previous_end("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[A", function()
                move.goto_previous_end("@parameter.outer", "textobjects")
            end)

            vim.keymap.set("n", "<leader>a", function()
                swap.swap_next("@parameter.inner", "textobjects")
            end)
            vim.keymap.set("n", "<leader>A", function()
                swap.swap_previous("@parameter.inner", "textobjects")
            end)
        end,
    },
}
