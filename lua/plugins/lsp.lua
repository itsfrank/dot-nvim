-- Two critical plugins here: lspconfig and mason
--      lspconfig: configuration utility for LSP server
--      mason: manager for automatically installing & updating LSP servers
return {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
        "folke/neodev.nvim",
    },
    config = function()
        require("neodev").setup({})
        require("mason").setup()

        local lspconfig = require("lspconfig")

        -- defaults passed to lspconfig (can be overriden in the lsp_servers list below)
        local default_on_attach = require("frank.lsp-on-attach")
        local default_capabilities =
            require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

        ---Used to intialize lsp servers, note that on_attach and capabilities are extracted and set to nil
        ---@class ServerConfig : lspconfig.Config
        ---@field no_mason? boolean dont use mason to manage the instalation of this server
        ---@field enable? fun():boolean|boolean conditionally disable the lsp, runs once per session (wont disable if things change after start)
        ---@field capabilities? fun():any|any
        ---@field on_attach? fun():nil

        -- based on kickstart.nvim (see: https://github.com/nvim-lua/kickstart.nvim)
        -- however I support additional fields
        ---List of lsp servers that should be instaled and configuraton objects
        ---@type (ServerConfig|fun():ServerConfig)[]
        local lsp_servers = {
            -- configure your lsp settings here, the table is used to intialize below
            clangd = {},
            gopls = {},
            tsserver = {},
            pyright = {},
            lua_ls = {
                Lua = {
                    format = { enable = false }, -- use stylua with conform instead
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                    diagnostics = {
                        disable = { "missing-fields" },
                    },
                    globals = {
                        -- Busted
                        "describe",
                        "it",
                        "before_each",
                        "after_each",
                        "teardown",
                        "pending",
                        "clear",
                    },
                },
                handlers = {
                    -- I get annoyed when gd opens a quickfix wiht all elements on the same line
                    -- if that happens, just jump to the first one
                    ["textDocument/definition"] = function(err, result, ctx, config)
                        if vim.tbl_islist(result) and #result > 0 then
                            local line = result[1].targetRange.start.line
                            local file = result[1].targetUri

                            local all_same = true
                            for _, res in ipairs(result) do
                                if res.targetRange.start.line ~= line or res.targetUri ~= file then
                                    all_same = false
                                    break
                                end
                            end
                            if all_same then
                                result = result[1]
                            end
                        end

                        local rtn = vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
                        return rtn
                    end,
                },
            },
            ocamllsp = {
                no_mason = true,
                filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
                capabilities = function()
                    local c = default_capabilities
                    c.textDocument.completion.completionItem.snippetSupport = true
                    c.textDocument.completion.completionItem.resolveSupport = {
                        properties = {
                            "documentation",
                            "detail",
                            "additionalTextEdits",
                        },
                    }
                    return c
                end,
            },
        }

        local utils = require("frank.utils.misc")
        local iter = require("frank.utils.iter")
        -- Ensure the servers above are installed (except thise with no_mason = true)
        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup({
            ensure_installed = iter.filter(vim.tbl_keys(lsp_servers), function(server)
                return lsp_servers[server].no_mason ~= true
            end),
        })

        local function setup_server(server_name, server_settings)
            local capabilities =
                utils.not_nil_or(utils.get_or_function(server_settings.capabilities), default_capabilities)
            local on_attach = utils.not_nil_or(utils.get_or_function(server_settings.on_attach), default_on_attach)
            local handlers = server_settings.handlers

            -- clean up before passing to lspconfig
            server_settings.capabilities = nil
            server_settings.on_attach = nil
            server_settings.enable = utils.get_or_function(server_settings.enable)
            server_settings.handlers = nil

            lspconfig[server_name].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = server_settings,
                handlers = handlers,
            })
        end

        -- mason will set up our servers automatically
        mason_lspconfig.setup_handlers({
            function(server_name)
                local server_settings = utils.not_nil_or(utils.get_or_function(lsp_servers[server_name]), {})
                setup_server(server_name, server_settings)
            end,
        })

        -- setup the no_mason servers
        for server_name, server_settings in pairs(lsp_servers) do
            if server_settings.no_mason == false then
                setup_server(server_name, server_settings)
            end
        end
    end,
}
