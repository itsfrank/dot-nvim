return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            local toggleterm = require("toggleterm")
            toggleterm.setup({
                direction = "float",
                on_open = function(t)
                    vim.cmd("startinsert!")
                    vim.api.nvim_win_set_option(t.window, "winhighlight", "Normal:NormalFloat")
                end,
                float_opts = {
                    border = "none",
                    width = function()
                        return math.floor(vim.o.columns * 0.95)
                    end,
                    height = function()
                        return math.floor((vim.o.lines - vim.o.cmdheight) * 0.95)
                    end,
                    row = function()
                        return math.floor(0.025 * (vim.o.lines - vim.o.cmdheight))
                    end,
                },
            })

            vim.keymap.set("n", "<leader>tt", toggleterm.toggle, { silent = true, desc = "[T]oggle [T]erm" })
            vim.keymap.set("n", "<c-t><c-t>", toggleterm.toggle, { silent = true, desc = "[T]oggle [T]erm" })
            vim.api.nvim_create_autocmd("TermOpen", {
                callback = function()
                    vim.keymap.set("t", "<c-t><c-t>", function()
                        vim.api.nvim_command("q")
                    end, { silent = true, desc = "[T]oggle [T]erm" })
                    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { silent = true, desc = "[T]oggle [T]erm" })
                end,
            })

            -- custom terminal for gitui
            local Terminal = require("toggleterm.terminal").Terminal
            local function make_gitui_term()
                return Terminal:new({
                    cmd = "gitui",
                    dir = vim.fn.getcwd(),
                })
            end

            local function lazygit_toggle()
                make_gitui_term():toggle()
            end

            vim.keymap.set("n", "<leader>tg", lazygit_toggle, { noremap = true, silent = true })
        end,
    },
    {
        "ryanmsnyder/toggleterm-manager.nvim",
        dependencies = {
            "akinsho/nvim-toggleterm.lua",
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
        },
        config = function()
            local toggleterm_manager = require("toggleterm-manager")
            local actions = toggleterm_manager.actions
            toggleterm_manager.setup({
                titles = {
                    prompt = "c-i: new | c-d: del | c-r: rename",
                },
                mappings = {
                    i = {
                        ["<CR>"] = { action = actions.toggle_term, exit_on_action = true },
                    },
                },
            })
            vim.keymap.set(
                "n",
                "<leader>ts",
                ":Telescope toggleterm_manager<cr>",
                { silent = true, desc = "[T]erminal [S]earch" }
            )
        end,
    },
}
