return {
    "j-hui/fidget.nvim",
    config = function()
        local fidget = require("fidget")
        fidget.setup({
            notification = {
                override_vim_notify = true,
            },
        })
        fidget.notification.set_config("default", { info_style = "@label" }, true)
    end,
}
