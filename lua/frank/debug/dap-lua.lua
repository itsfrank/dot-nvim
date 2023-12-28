local dap_lua = {}

dap_lua.local_lua_adapter = {
    type = "executable",
    command = "node",
    args = {
        "/Users/fobrien/tools/local-lua-debugger-vscode/extension/debugAdapter.js",
    },
    enrich_config = function(config, on_config)
        if not config["extensionPath"] then
            local c = vim.deepcopy(config)
            c.extensionPath = "/Users/fobrien/tools/local-lua-debugger-vscode/"
            on_config(c)
        else
            on_config(config)
        end
    end,
}

function dap_lua.make_luals_debug_config(args)
    local config = {
        name = "Debug LuaLS test",
        type = "local-lua",
        request = "launch",
        program = {
            command = "/Users/fobrien/frk/lua-language-server/bin/lua-language-server",
        },
        args = args,
        cwd = "${workspaceFolder}",
    }
    return config
end

return dap_lua
