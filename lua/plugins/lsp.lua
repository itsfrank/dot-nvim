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
        "lopi-py/luau-lsp.nvim",
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
        ---@field use_mason? boolean dont install with mason if false, nil implies true
        ---@field enable? fun():boolean|boolean conditionally disable the lsp, runs once per session (wont disable if things change after start)
        ---@field capabilities? fun():any|any
        ---@field on_attach? fun():nil
        ---@field custom_setup? fun():nil run this instead of default config function below, still respects enable and use_mason

        -- based on kickstart.nvim (see: https://github.com/nvim-lua/kickstart.nvim)
        -- however I support additional fields
        ---List of lsp servers that should be instaled and configuraton objects
        ---@type (ServerConfig|fun():ServerConfig)[] if function return nil, then all must be configured in the function
        local lsp_servers = {
            -- configure your lsp settings here, the table is used to intialize below
            clangd = {
                filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
            },
            gopls = {},
            tsserver = {},
            pyright = {},
            luau_lsp = {
                filetypes = { "lua", "luau" },
                enable = function() -- enable only in rojo projects
                    local utils = require("frank.utils.misc")
                    return utils.is_luau_project(vim.fn.getcwd())
                end,
                custom_setup = function()
                    local run_once = false

                    local aliases = require("frank.utils.misc").read_luaurc_aliases(vim.fn.getcwd())
                    require("luau-lsp").setup({
                        server = {
                            filetypes = { "luau", "lua" },
                            capabilities = default_capabilities,
                            on_attach = function(client, bufnr)
                                default_on_attach(client, bufnr)
                                if run_once then
                                    return
                                end
                                run_once = true
                                vim.defer_fn(function()
                                    vim.cmd("e %")
                                end, 500)
                            end,
                            settings = {
                                ["luau-lsp"] = {
                                    require = {
                                        mode = "relativeToFile",
                                        directoryAliases = aliases,
                                    },
                                },
                            },
                        },
                    })
                end,
            },
            lua_ls = {
                enable = function() -- disable lua_ls in roblox projects
                    local utils = require("frank.utils.misc")
                    return not utils.is_luau_project(vim.fn.getcwd())
                end,
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
                use_mason = false,
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
        -- Ensure the servers above are installed (except thise with use_mason = false)
        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup({
            ensure_installed = iter.filter(vim.tbl_keys(lsp_servers), function(server)
                return lsp_servers[server].use_mason ~= false
            end),
        })

        -- setup the servers
        for server_name, server_settings in pairs(lsp_servers) do
            local loop = function() -- i need this because lua doesn't have `continue` :(
                server_settings = utils.get_or_function(server_settings)

                server_settings.enable = utils.get_or_function(server_settings.enable)
                if server_settings.enable == false then
                    return
                end

                -- custom setup
                if server_settings.custom_setup ~= nil then
                    server_settings.custom_setup()
                    return
                end

                -- default setup
                server_settings.capabilities =
                    utils.not_nil_or(utils.get_or_function(server_settings.capabilities), default_capabilities)
                server_settings.on_attach =
                    utils.not_nil_or(utils.get_or_function(server_settings.on_attach), default_on_attach)

                lspconfig[server_name].setup(server_settings)
            end
            loop()
        end
    end,
}
