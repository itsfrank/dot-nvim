return { -- File broswer that behaves like a buffer
    "stevearc/oil.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("oil").setup({
            keymaps = {
                -- yank full path of a file into the default register
                ["<C-y>"] = "actions.copy_entry_path",
            },
            view_options = {
                show_hidden = true,
            },
        })

        vim.keymap.set(
            "n",
            "<leader>-",
            require("oil").open,
            { desc = "oil: Open file-explorer in parent directory [-]" }
        )

        -- telescope picker to open a folder in oil
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local finders = require("telescope.finders")
        local pickers = require("telescope.pickers")
        local conf = require("telescope.config").values

        local find_folder = function(opts)
            opts = opts or {}
            if opts.cwd == nil then
                opts.cwd = "."
            end

            local fd_command = { "fd", ".", opts.cwd, "--type", "d" }
            pickers
                .new(opts, {
                    prompt_title = "Find Folder",
                    finder = finders.new_oneshot_job(fd_command, opts),
                    previewer = conf.file_previewer(opts),
                    sorter = conf.file_sorter(opts),
                    attach_mappings = function(_, _)
                        actions.select_default:replace(function(bufnr)
                            local selection = action_state.get_selected_entry()
                            actions.close(bufnr)

                            if selection == nil or selection[1] == "" then
                                return
                            end
                            vim.cmd("e " .. selection[1])
                        end)
                        return true
                    end,
                })
                :find()
        end

        local telescope_builtin = require("telescope.builtin")
        telescope_builtin.find_folder = find_folder

        vim.keymap.set("n", "<leader>fs", telescope_builtin.find_folder, { desc = "[F]older [S]earch" })
    end,
}
