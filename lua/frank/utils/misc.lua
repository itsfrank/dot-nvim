local utils = {}

---return value or return of function if type is function
function utils.get_or_function(v_or_f)
    if type(v_or_f) == "function" then
        return v_or_f()
    end
    return v_or_f
end

function utils.not_nil_or(v_or_nil, default)
    if v_or_nil == nil then
        return default
    end
    return v_or_nil
end

function utils.find_buffer_by_name(name)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name == name then
            return buf
        end
    end
    return -1
end

function utils.find_buffers_name_contains(str)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if string.find(buf_name, str) then
            return buf
        end
    end
    return -1
end

function utils.toggle_buffer(name, open, close)
    if utils.find_buffers_name_contains(name) == -1 then
        open()
    else
        close()
    end
end

return utils
