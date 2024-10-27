return {
    --     "simrat39/rust-tools.nvim",
    --     ft = "rust",
    --     dependencies = "neovim/nvim-lspconfig",
    --     config = function()
    --         local on_attach = require("frank.lsp-on-attach")
    --
    --         local capabilities = vim.lsp.protocol.make_client_capabilities()
    --         capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    --
    --         require("rust-tools").setup({
    --             server = {
    --                 on_attach = on_attach,
    --                 capabilities = capabilities,
    --             },
    --         })
    --     end,
}
