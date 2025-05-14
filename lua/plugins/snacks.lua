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

        -- picker
        vim.keymap.set("n", "<leader>sf", function()
            snacks.picker.files({
                layout = { preview = { enabled = false } },
            })
        end, { silent = true, desc = "[S]earch [F]iles" })

        vim.keymap.set("n", "<leader>gc", function()
            snacks.picker.files({ cmd = "git", args = { "--no-pager", "diff", "--name-only", "--diff-filter=U" } })
        end, { silent = true, desc = "Pick [G]it [C]onflicts" })

        vim.keymap.set("n", "<leader>/", snacks.picker.lines, { desc = "[/] fuzzy search current buffer]" })
        vim.keymap.set("n", "<leader>ck", snacks.picker.pickers, { desc = "Pick Pi[c][k]ers" })
        vim.keymap.set("n", "<leader>km", snacks.picker.keymaps, { desc = "[K]ey[M]aps" })

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
