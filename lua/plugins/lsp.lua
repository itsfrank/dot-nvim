return {
    "neovim/nvim-lspconfig", -- this is installed so we get community maintained default configs
    dependencies = {
        "j-hui/fidget.nvim",
        "folke/lazydev.nvim",
        "Bilal2453/luvit-meta", -- libuv typings
    },
    config = function()
        require("lazydev").setup({
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                "luvit-meta/library",
            },
        })

        vim.lsp.config("*", {
            capabilities = require("blink.cmp").get_lsp_capabilities(),
        })

        vim.lsp.enable("lua_ls")
        vim.lsp.enable("clangd")
    end,
}
