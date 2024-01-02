return {
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

        vim.keymap.set("n", "<leader>tt", ":ToggleTerm<cr>", { silent = true, desc = "[T]oggle [T]erm" })
        vim.keymap.set("n", "<c-t><c-t>", ":ToggleTerm<cr>", { silent = true, desc = "[T]oggle [T]erm" })
        vim.keymap.set("t", "<c-t><c-t>", "<c-\\><c-n>:ToggleTerm<cr>", { silent = true, desc = "[T]oggle [T]erm" })
        vim.keymap.set(
            "n",
            "<leader>tv",
            ":ToggleTerm direction=vertical <cr>",
            { silent = true, desc = "Toggle [H]orizontal terminal view" }
        )
        vim.keymap.set(
            "n",
            "<leader>th",
            ":ToggleTerm direction=horizontal <cr>",
            { silent = true, desc = "Toggle [V]ertical terminal view" }
        )
        vim.keymap.set(
            "n",
            "<leader>ff",
            ":ToggleTerm direction=float <cr>",
            { silent = true, desc = "Toggle [F]loat terminal view" }
        )

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
}
