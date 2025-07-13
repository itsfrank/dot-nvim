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

When asked vim/neovim configuration questions never use vimscript, always suggest neovim lua
]]

return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
                opts = {},
            },
        },
        config = function()
            local win_width = 0.4
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
                            width = win_width,
                        },
                    },
                },
                adapters = {
                    deepseek = function()
                        return require("codecompanion.adapters").extend("ollama", {
                            name = "deepseek",
                            schema = {
                                model = {
                                    default = "deepseek-r1:14b",
                                },
                            },
                        })
                    end,
                },
            })

            -- if youre looking for the code you wrote to save/load chats... I removed it :)
            -- there is a plugin that implements it now: https://github.com/ravitemer/codecompanion-history.nvim

            local function toggle_chat()
                codecompanion.toggle()

                vim.cmd("wincmd L")
                vim.cmd("vertical resize " .. math.floor(vim.o.columns * win_width))

                local current_buffer = vim.api.nvim_get_current_buf()
                local buffer_name = vim.api.nvim_buf_get_name(current_buffer)
                if string.find(buffer_name, "%[CodeCompanion%]") then
                    vim.cmd("set filetype=markdown")
                end
            end

            vim.keymap.set("n", "<leader>gpt", toggle_chat, { desc = "chat[GPT] window" })
            vim.keymap.set("n", "<leader>ai", toggle_chat, { desc = "[AI] chat window" })
        end,
    },
}
