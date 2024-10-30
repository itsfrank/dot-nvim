---@param host string
---@param port number
---@param on_data? fun(data: string, sock: uv_tcp_t)
---@param on_err? fun(data: string, sock: uv_tcp_t)
---@return uv_tcp_t?, string?
local function create_tcp_server(host, port, on_data, on_err)
    local server = vim.uv.new_tcp()
    local _, err = server:bind(host, port)
    if err ~= nil then
        return nil, "start server failed for '" .. host .. ":" .. tostring(port) .. "', err: " .. err
    end

    _, err = server:listen(128, function(err1)
        assert(not err1, err1)
        local sock = vim.uv.new_tcp()
        server:accept(sock)
        sock:read_start(function(err2, chunk)
            if err2 then
                error(err2)
            end
            if err2 and on_err ~= nil then
                on_err(err2, sock)
            elseif chunk and on_data ~= nil then
                on_data(chunk, sock)
            end
            if not sock:is_closing() then
                sock:close()
            end
        end)
    end)
    if err ~= nil then
        return nil, "start server failed for '" .. host .. ":" .. tostring(port) .. "', err: " .. err
    end
    return server
end

--- start a tcp server that will notify based on tcp messages to localhost @ port env.NOTIFY_PORT
--- messages are json and take form {"evt": "info|warn|err", "msg": "<your message>"}
--- they are fed to vim.notify with the matching level
---@return uv_tcp_t?, string?
local function notify_start_server()
    local notify_port = tonumber(vim.env.NOTIFY_PORT) or 34567
    local notify_server, err = create_tcp_server("0.0.0.0", notify_port, function(data, sock)
        local ok, json = pcall(function()
            return vim.json.decode(data)
        end)

        local lvl = vim.log.levels[string.upper(json.evt or "")]
        local msg = json.msg
        if ok and lvl ~= nil and msg ~= nil then
            vim.schedule(function()
                vim.notify(msg, lvl)
            end)
        end

        sock:write("ack")
    end)
    if err ~= nil then
        return nil, err
    end

    assert(notify_server ~= nil)
    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            if not notify_server:is_closing() then
                notify_server:close()
            end
        end,
    })

    return notify_server
end

return {
    start_server = notify_start_server,
}
