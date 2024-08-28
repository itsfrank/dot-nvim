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
