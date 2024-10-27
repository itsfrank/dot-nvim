return {
    "mrcjkb/rustaceanvim",
    ft = "rust",
    config = function()
        local on_attach = require("frank.lsp-on-attach")

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        -- this is rustaceanvim's equivalent of calling setup() :/
        vim.g.rustaceanvim = {
            server = {
                on_attach = on_attach,
                capabilities = capabilities,
            },
        }
    end,
}
