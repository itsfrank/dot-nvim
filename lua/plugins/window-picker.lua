return {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
        require("window-picker").setup({
            -- 'statusline-winbar' | 'floating-big-letter' | 'floating-letter'
            hint = "floating-letter",
            filter_rules = {
                include_current_win = true, -- no clue why, but it feels better with this
            },
        })

        vim.keymap.set("n", "<leader>jw", function()
            local picked_window_id = require("window-picker").pick_window()
            if picked_window_id then
                vim.api.nvim_set_current_win(picked_window_id)
            end
        end, { desc = "[j]ump to [w]indow" })

        vim.keymap.set("n", "<leader>jo", function()
            local picked_window_id = require("window-picker").pick_window()
            if picked_window_id then
                vim.api.nvim_set_current_win(picked_window_id)
                vim.cmd(":only")
            end
        end, { desc = "[j]ump to window and :[o]nly" })
    end,
}
