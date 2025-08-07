-- lazy.nvim
return {
    "folke/snacks.nvim",
    config = function()
        local snacks = require("snacks")
        snacks.setup({
            picker = {
                -- I like tab/s-tab to move up/down
                win = {
                    input = {
                        keys = {
                            ["<Tab>"] = { "list_down", mode = { "i", "n" } },
                            ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
                        },
                    },
                    list = {
                        keys = {

                            ["<Tab>"] = { "list_down", mode = { "i", "n" } },
                            ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
                        },
                    },
                },
            },
            terminal = {},
        })

        -- add my custom pickers
        local frk_picker = require("frank.utils.picker")
        ---@diagnostic disable-next-line: inject-field
        Snacks.picker.directories = frk_picker.fuzzy_oil

        -- picker
        vim.keymap.set("n", "<leader>sf", function()
            snacks.picker.files({
                layout = { preview = { enabled = false } },
            })
        end, { silent = true, desc = "[S]earch [F]iles" })

        vim.keymap.set("n", "<leader>fs", Snacks.picker.directories, { silent = true, desc = "[F]older [S]earch" })

        vim.keymap.set("n", "<leader>gc", function()
            snacks.picker.git_status({
                pattern = "UU",
            })
        end, { desc = "Pick [G]it [C]onflicts" })

        vim.keymap.set("n", "<leader>/", snacks.picker.lines, { desc = "[/] fuzzy search current buffer]" })
        vim.keymap.set("n", "<leader>ck", snacks.picker.pickers, { desc = "Pick Pi[c][k]ers" })
        vim.keymap.set("n", "<leader>km", snacks.picker.keymaps, { desc = "[K]ey[M]aps" })
        vim.keymap.set("n", "<leader>sh", snacks.picker.help, { desc = "[S]earch [H]elp" })
        vim.keymap.set("n", "<leader>sd", snacks.picker.diagnostics_buffer, { desc = "[S]earch [D]iagnostics" })
        vim.keymap.set("n", "<leader><space>", snacks.picker.buffers, { desc = "[ ] Find existing buffers" })
        vim.keymap.set("n", "<leader>gs", snacks.picker.git_status, { desc = "search [G]it [S]tatus" })
        vim.keymap.set("n", "<leader>sg", snacks.picker.grep, { desc = "[S]earch by [G]rep" })
        vim.keymap.set(
            "n",
            "<leader>cr",
            snacks.picker.command_history,
            { desc = "[c]ommand histo[r]y (also ctrl-r?)" }
        )

        -- terminal
        vim.keymap.set({ "n", "t" }, "<m-q>", function()
            local win, created = snacks.terminal.get()
            if win then
                win.opts.height = 20
            end
            if not created then
                snacks.terminal.toggle()
            end
        end)

        vim.keymap.set({ "n", "t" }, "<m-Q>", function()
            local win, created = snacks.terminal.get(nil, { win = { height = 0 } })
            if win then
                win.opts.height = 0
            end
            if not created then
                snacks.terminal.toggle(nil, { win = { height = 0 } })
            end
        end)
    end,
}
