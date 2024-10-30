vim.api.nvim_create_user_command("YankFileLine", function()
    local file = vim.fn.expand("%")
    local line = vim.fn.line(".")
    local cwd = vim.fn.getcwd()
    if file:match(cwd) then
        file = file.sub(file, cwd:len())
    end
    local str = file .. ":" .. line
    vim.fn.setreg('"', str)
    print("set reg to: " .. str)
end, {})

---@type uv_tcp_t?
local notify_server = nil
vim.api.nvim_create_user_command("StartNotifyServer", function()
    if notify_server and not notify_server:is_closing() then
        return
    end

    local try_notify_server, err = require("frank.utils.server").start_server()
    if err then
        error(err)
    end
    notify_server = try_notify_server
end, {})

vim.api.nvim_create_user_command("StopNotifyServer", function()
    if notify_server and not notify_server:is_closing() then
        notify_server:close()
    end
end, {})
