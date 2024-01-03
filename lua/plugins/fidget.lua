return {
    "j-hui/fidget.nvim",
    config = function()
        local fidget = require("fidget")
        fidget.setup({
            display = {
                render_limit = 16,
            },
            notification = {
                override_vim_notify = true,
            },
        })
        vim.notify = fidget.notify
    end,
}
