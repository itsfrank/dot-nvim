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

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                require("frank.lsp-on-attach")(client, bufnr)
            end,
        })

        vim.lsp.enable("lua_ls")
        vim.lsp.enable("clangd")
    end,
}
