local dap_utils = {}

--- warning, this does not respect quoted args, but I haven't run into that problem yet so...
local function str_split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

---@class TelescopeDebugLaunchOptions
---@field prompt_args? boolean #prompt user for args afte selecting executable, input will be split on spaces

---Select executable in a directory with telescope
---selected executable will be launched with debugger configuration
---@see TelescopeDebugLaunchOptions
---@param find_files_opts any #options to telescop find_files command
---@param make_config fun(selected:string, args:string[]|nil):any #function to make dap debug config
---@param opts? TelescopeDebugLaunchOptions #options
function dap_utils.telescope_debug_launch(find_files_opts, make_config, opts)
    local dap = require("dap")

    local exec_dap = function(selected_exe, args)
        local config = make_config(selected_exe, args)
        dap.run(config)
    end

    ---@param callback fun(args:string[]|nil):nil
    local get_args_exec = function(callback)
        vim.ui.input({
            prompt = "Executable args",
        }, function(input)
            if input == nil then
                -- cancelled with esc, dont call callback
                return
            end

            if input == "" then
                callback()
            else
                local args = str_split(input)
                callback(args)
            end
        end)
    end

    local telescope_callback = function(prompt_bufnr)
        local actions_state = require("telescope.actions.state")
        local actions = require("telescope.actions")
        local selected_entry = actions_state.get_selected_entry()
        local selected_exe = selected_entry.cwd .. "/" .. selected_entry[1]
        if opts ~= nil and opts.prompt_args == true then
            get_args_exec(function(args)
                exec_dap(selected_exe, args)
            end)
        else
            exec_dap(selected_exe)
        end
        actions.close(prompt_bufnr)
    end

    find_files_opts.find_command = { "fd", "-HI", "-t", "x" } -- find executables including in hidden folders (e.g. ./build)
    find_files_opts.attach_mappings = function(_, map)
        map("n", "<cr>", telescope_callback)
        map("i", "<cr>", telescope_callback)
        return true
    end
    require("telescope.builtin").find_files(find_files_opts)
end

return dap_utils
