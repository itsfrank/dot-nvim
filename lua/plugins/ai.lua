local custom_prompt = [[ You are an AI programming assistant. Please keep your answers 

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return relevant code. 

When asked vim/neovim questions never use vimscript, always suggest neovim lua
]]

return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- Optional
            {
                "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
                opts = {},
            },
        },
        config = function()
            local codecompanion = require("codecompanion")
            codecompanion.setup({
                strategies = {
                    chat = {
                        adapter = "anthropic",
                    },
                },
                opts = {
                    system_prompt = custom_prompt,
                },
                display = {
                    chat = {
                        window = {
                            width = 0.35,
                        },
                    },
                },
            })

            -- create a folder to store our chats
            local Path = require("plenary.path")
            local data_path = vim.fn.stdpath("data")
            local save_folder = Path:new(data_path, "cc_saves")
            if not save_folder:exists() then
                save_folder:mkdir({ parents = true })
            end

            -- telescope picker for our saved chats
            vim.api.nvim_create_user_command("CodeCompanionLoad", function()
                local t_builtin = require("telescope.builtin")
                local t_actions = require("telescope.actions")
                local t_action_state = require("telescope.actions.state")

                local function start_picker()
                    t_builtin.find_files({
                        prompt_title = "Saved CodeCompanion Chats | <c-d>: delete",
                        cwd = save_folder:absolute(),
                        attach_mappings = function(_, map)
                            map("i", "<c-d>", function(prompt_bufnr)
                                local selection = t_action_state.get_selected_entry()
                                local filepath = selection.path or selection.filename
                                os.remove(filepath)
                                t_actions.close(prompt_bufnr)
                                start_picker()
                            end)
                            return true
                        end,
                    })
                end
                start_picker()
            end, {})

            -- save current chat, `CodeCompanionSave foo bar baz` will save as 'foo-bar-baz.md'
            vim.api.nvim_create_user_command("CodeCompanionSave", function(opts)
                local success, chat = pcall(function()
                    return codecompanion.buf_get_chat(0)
                end)
                if not success or chat == nil then
                    vim.notify(
                        "CodeCompanionSave should only be called from CodeCompanion chat buffers",
                        vim.log.levels.ERROR
                    )
                    return
                end
                if #opts.fargs == 0 then
                    vim.notify("CodeCompanionSave requires at least 1 arg to make a file name", vim.log.levels.ERROR)
                end
                local save_name = table.concat(opts.fargs, "-") .. ".md"
                local save_path = Path:new(save_folder, save_name)
                local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                save_path:write(table.concat(lines, "\n"), "w")
            end, { nargs = "*" })

            vim.keymap.set("n", "<leader>gpt", function()
                codecompanion.toggle()

                vim.cmd("wincmd L")
                vim.cmd(
                    "vertical resize " .. math.floor(vim.o.columns * codecompanion.config.display.chat.window.width)
                )

                local current_buffer = vim.api.nvim_get_current_buf()
                local buffer_name = vim.api.nvim_buf_get_name(current_buffer)
                if string.find(buffer_name, "%[CodeCompanion%]") then
                    vim.cmd("set filetype=markdown")
                end
            end, {
                silent = true,
                desc = "Chat[GPT] window",
            })
        end,
    },
}
