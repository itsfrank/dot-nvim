return {
    -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "Snikimonkd/telescope-git-conflicts.nvim",
    },
    config = function()
        local telescope = require("telescope")
        telescope.load_extension("dap")
        telescope.load_extension("workspaces")
        telescope.load_extension("aerial")
        telescope.load_extension("conflicts")

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                        -- tab/s-tab to navigate instead of selecting
                        ["<tab>"] = "move_selection_previous",
                        ["<S-tab>"] = "move_selection_next",
                        ["<C-h>"] = "which_key",
                    },
                    n = {
                        ["<C-h>"] = "which_key",
                    },
                },
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                borderchars = {
                    preview = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
                    prompt = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
                    results = { " ", "▐", "▄", "▌", "▌", "▐", "▟", "▙" },
                },
            },
        })

        -- uncomment if you want to use telescope to fuzzy find files currently usinf fzfx.nvim instead because of performanc on large projects
        -- vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
        -- vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })

        vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
        vim.keymap.set(
            "n",
            "<leader>sw",
            require("telescope.builtin").grep_string,
            { desc = "[S]earch current [W]ord" }
        )
        vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
        vim.keymap.set("n", "<leader>km", require("telescope.builtin").keymaps, { desc = "[K]ey [M]aps" })
        vim.keymap.set(
            "n",
            "<leader>?",
            require("telescope.builtin").oldfiles,
            { desc = "[?] Find recently opened files" }
        )
        vim.keymap.set(
            "n",
            "<leader><space>",
            require("telescope.builtin").buffers,
            { desc = "[ ] Find existing buffers" }
        )
        vim.keymap.set("n", "<leader>/", function()
            require("telescope.builtin").current_buffer_fuzzy_find()
        end, { desc = "[/] Fuzzily search in current buffer]" })
        vim.keymap.set(
            "n",
            "<leader>gc",
            ":Telescope conflicts<cr>",
            { silent = true, desc = "Telescope [G]it [C]onflicts" }
        )

        -- styling
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                local caret_color = vim.api.nvim_get_hl(0, { name = "Conditional" })
                local telescope_overrides = {
                    TelescopeBorder = { fg = "bg" },
                    TelescopeSelectionCaret = { fg = caret_color.fg },
                    TelescopePromptPrefix = { fg = caret_color.fg },
                }

                for hl, col in pairs(telescope_overrides) do
                    vim.api.nvim_set_hl(0, hl, col)
                end
            end,
        })
    end,
}
