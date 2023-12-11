return {
    {
        enabled = false,
    -- Lsp integration for non-lsp formatters
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                on_attach = require("frank.on-lsp-attach"),
                sources = {
                    null_ls.builtins.formatting.beautysh,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.black,
                    -- null_ls.builtins.formatting.rustfmt,
                    null_ls.builtins.formatting.fixjson,
                    null_ls.builtins.formatting.prettier.with({
                        filetypes = { "yaml", "markdown" },
                        extra_args = { "--prose-wrap=always" },
                    }),
                    null_ls.builtins.diagnostics.markdownlint,
                },
            })
        end,
        dependencies = { "nvim-lua/plenary.nvim" },
    },
}
