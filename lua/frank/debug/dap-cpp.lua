local dap_cpp = {}

dap_cpp.lldb_adapter = {
    type = "executable",
    command = "/opt/homebrew/opt/llvm/bin/lldb-vscode", -- adjust as needed, must be absolute path
    name = "lldb",
}

---launch an exe with args and attach a debugger
---@param exe_path string #path to executable to launch
---@param args string[]|nil #list of args to pass to executable under test
function dap_cpp.new_cpp_debug_config(exe_path, args)
    args = args and args or {}
    return {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = exe_path,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = args,
    }
end

return dap_cpp
