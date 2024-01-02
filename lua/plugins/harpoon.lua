return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    as = "harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
            },
        })

        vim.keymap.set("n", "<leader>hm", function()
            harpoon:list():append()
        end, { desc = "[H]arpoon [M]ark" })

        vim.keymap.set("n", "<leader>hv", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "[H]arpoon [V]iew quick menu" })

        vim.keymap.set(
            "n",
            "<leader>hs",
            ":Telescope harpoon marks<cr>",
            { silent = true, desc = "[H]arpoon [S]earch with telescope" }
        )

        -- set up numeric keymaps: <leader>h1-9 for jumping to marks
        for i = 1, 9 do
            vim.keymap.set("n", "<leader>h" .. tostring(i), function()
                harpoon:list():select(i)
            end, { desc = "[H]arpoon jump to mark #" .. tostring(i) })
        end
    end,
}
