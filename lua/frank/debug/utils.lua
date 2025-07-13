local dap = require("dap")

local dap_utils = {}

---@class LaunchDebugConfig
---@field kind string
---@field exe string
---@field args string[]

---@type LaunchDebugConfig|nil
dap_utils._last_exec = nil
dap_utils._debug_kind_launchers = {}

function dap_utils.debug_last()
    if dap_utils._last_exec == nil then
        error("last exec is nil, you must debug something once before using debug_last")
        return
    end
    dap_utils.launch_debug(dap_utils._last_exec)
end

---@param conf LaunchDebugConfig
function dap_utils.launch_debug(conf)
    local make_config = dap_utils._debug_kind_launchers[conf.kind]
    if make_config == nil then
        error("no debug launcher registered for kind: " .. conf.kind)
        return
    end

    dap_utils._last_exec = conf
    local dap_config = make_config(conf.exe, conf.args)
    dap.run(dap_config)
end

---@param fn fun(selected_exe:string, args:string[]|nil):dap.Configuration
function dap_utils.register_debug_kind(name, fn)
    dap_utils._debug_kind_launchers[name] = fn
end

-- user command: LaunchDebug <kind> <exe path> [<args to fwd to exe...>]
function dap_utils.make_commands()
    vim.api.nvim_create_user_command("LaunchDebug", function(opts)
        local conf = {
            kind = opts.fargs[1],
            exe = opts.fargs[2],
            args = {},
        }
        for i = 3, #opts.fargs do
            table.insert(conf.args, opts.fargs[i])
        end
        dap_utils.launch_debug(conf)
    end, { nargs = "*" })

    vim.api.nvim_create_user_command("LaunchDebugLast", function(_)
        dap_utils.debug_last()
    end, {})
end

-- TODO: maybe add a fuzzy picker for finding debug exes?
-- TODO: maybe add launch config history? With fuzzy picker and persistence?

return dap_utils
