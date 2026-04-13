return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("render-markdown").setup({
            sign = {
                enabled = false,
            },
            code = {
                border = "thick",
            },
        })
    end,
}
