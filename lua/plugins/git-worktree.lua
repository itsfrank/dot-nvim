return {
    {
        "ThePrimeagen/git-worktree.nvim",
        config = function()
            local git_worktree = require("git-worktree")
            git_worktree.setup()

            local telescope = require("telescope")
            vim.api.nvim_create_user_command("WtSwitch", function()
                telescope.extensions.git_worktree.git_worktrees()
            end, {})
            vim.api.nvim_create_user_command("WtCreate", function()
                telescope.extensions.git_worktree.create_git_worktree()
            end, {})

            vim.api.nvim_create_user_command("WtDeleteCurrent", function()
                local current_worktree = git_worktree.get_current_worktree_path()
                local wt_root = git_worktree.get_root()
                if current_worktree == nil or wt_root == nil then
                    vim.notify(
                        "Error: not currently in a worktree.",
                        vim.log.levels.ERROR,
                        { title = "franks-worktree" }
                    )
                    return
                end

                local confirmation =
                    vim.fn.input("You are about to deletr worktree [ " .. current_worktree .. " ] are you sure? (y/n)")
                if confirmation ~= "y" then
                    return
                end

                git_worktree.delete_worktree(current_worktree, false, {})
            end, {})

            vim.keymap.set("n", "<leader>wts", ":WtSwitch<cr>", { desc = "Git [W]ork[T]ree [S]witch" })
        end,
    },
}
