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
            clangd = { filetypes = { "c", "cpp", "objc", "objcpp", "cuda" } },
            gopls = {},
            tsserver = {},
            bashls = {},
            zls = {},
            pylsp = {
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                ignore = { "W391" },
                                maxLineLength = 100,
                            },
                        },
                    },
                },
            },
            luau_lsp = {
                enable = function() -- enable only in rojo projects
                    local utils = require("frank.utils.misc")
                    return utils.is_luau_project(vim.fn.getcwd())
                end,
                custom_setup = function()
                    vim.filetype.add({ extensions = { rbxp = "json" } })
                    vim.filetype.add({
                        extension = {
                            lua = function(path)
                                return path:match("%.nvim%.lua$") and "lua" or "luau"
                            end,
                        },
                    })

                    -- create the local type file if it does not exist
                    -- this way if it gets changed, the lsp will reload
                    local RBX_LOCAL_TYPES_PATH = "/tmp/rbxLocalTypes.d.luau"
                    local rbxLocal = require("plenary.path"):new(RBX_LOCAL_TYPES_PATH)
                    if not rbxLocal:exists() then
                        rbxLocal:touch()
                    end

                    local utils = require("frank.utils.misc")
                    require("luau-lsp").setup({
                        sourcemap = {
                            enabled = true,
                            autogenerate = utils.is_project_json_present(vim.fn.getcwd()),
                        },
                        types = {
                            ---@type luau-lsp.RobloxSecurityLevel
                            roblox_security_level = "RobloxScriptSecurity",
                            definition_files = {
                                RBX_LOCAL_TYPES_PATH,
                            },
                        },
                        server = {
                            filetypes = { "luau", "lua" },
                            -- on_attach = default_on_attach,

                            on_attach = function(client, bufnr)
                                if vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t") == ".nvim.lua" then
                                    client.stop()
                                    return
                                end
                                default_on_attach(client, bufnr)
                            end,
                            settings = {
                                ["luau-lsp"] = {
                                    require = {
                                        mode = "relativeToFile",
                                        directoryAliases = (function()
                                            local aliases = require("luau-lsp").aliases()
                                            if aliases == nil then
                                                aliases = {}
                                            end
                                            local lune_path = utils.find_lune_defs()
                                            if lune_path ~= nil then
                                                aliases["@lune"] = lune_path
                                            end
                                            return aliases
                                        end)(),
                                    },
                                },
                            },
                            root_dir = function(path)
                                return vim.fs.root(path, function(name)
                                    return name:match(".+%.project%.json$")
                                end) or vim.fs.root(path, {
                                    ".git",
                                    ".luaurc",
                                    "stylua.toml",
                                    "selene.toml",
                                    "selene.yml",
                                    "default.rbxp", -- internal projects
                                })
                            end,
                        },
                    })
                end,
            },
            lua_ls = {
                -- enable = function() -- disable lua_ls in roblox projects
                --     local utils = require("frank.utils.misc")
                --     return not utils.is_luau_project(vim.fn.getcwd())
                -- end,
                on_attach = function(client, bufnr)
                    local utils = require("frank.utils.misc")
                    local is_luau = utils.is_luau_project(vim.fn.getcwd())

                    if is_luau then
                        if vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t") ~= ".nvim.lua" then
                            client.stop()
                            return
                        end
                    end
                    default_on_attach(client, bufnr)
                end,
                root_dir = function(path)
                    if vim.fn.fnamemodify(path, ":t") == ".nvim.lua" then
                        return false
                    end
                    require("lspconfig.server_configurations.lua_ls").default_config.root_dir(path)
                end,
                -- root_dir = (function()
                --     local utils = require("frank.utils.misc")
                --     local is_luau = utils.is_luau_project(vim.fn.getcwd())
                --     if is_luau then -- lua_ls should only be used for .nvim.lua files in luau projects
                --         return function()
                --             return false
                --         end
                --     end
                --
                --     return nil
                -- end)(),
                Lua = {
                    format = { enable = false }, -- use stylua with conform instead
                    workspace = {
                        checkThirdParty = false,
                        ignoreDir = {
                            "Client",
                            "Client/*",
                            "Client/**",
                            "Client/**/*.lua",
                            "*.lua",
                        },
                        library = {
                            vim.env.VIMRUNTIME,
                        },
                    },
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
            server_settings = utils.get_or_function(server_settings)

            server_settings.enable = utils.get_or_function(server_settings.enable)
            if server_settings.enable ~= false then
                if server_settings.custom_setup == nil then
                    -- default setup
                    server_settings.capabilities =
                        utils.not_nil_or(utils.get_or_function(server_settings.capabilities), default_capabilities)
                    server_settings.on_attach = utils.not_nil_or(server_settings.on_attach, default_on_attach)

                    lspconfig[server_name].setup(server_settings)
                else
                    -- custom setup
                    server_settings.custom_setup()
                end
            end
        end
    end,
}
