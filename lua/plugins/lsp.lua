-- Two critical plugins here: lspconfig and mason
--      lspconfig: configuration utility for LSP server
--      mason: manager for automatically installing & updating LSP servers
return {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
        "folke/lazydev.nvim",
        "lopi-py/luau-lsp.nvim",
        "Bilal2453/luvit-meta", -- libuv typings
    },
    config = function()
        require("lazydev").setup({
            enabled = function(root)
                return true
            end,
            library = {
                "luvit-meta/library",
            },
        })

        local lsp_configs = {
            lua_ls = {},
            clangd = {},
            luau_lsp = {
                exclude_enable = true,
            },
        }

        -- compute the things
        local iter = require("frank.utils.iter")
        local lsp_names = iter.tbl.keys(lsp_configs)
        local enable_excluded = iter.tbl.keys(iter.tbl.filter(lsp_configs, function(_, v)
            return v.exclude_enable
        end))

        -- do the setup
        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup({
            ensure_installed = lsp_names,
            automatic_enable = {
                exclude = enable_excluded,
            },
        })

        -- need to do this for now, see: https://github.com/neovim/nvim-lspconfig/issues/3827
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                require("frank.lsp-on-attach")(client, args.buf)
            end,
        })
    end,
}
