local utils = {}

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
        print("opening")
        open()
    else
        print("closing")
        close()
    end
end

function utils.set_of(list)
    local set = {}
    for i = 1, #list do
        set[list[i]] = true
    end
    return set
end

function utils.list_conatins_one(list, elements)
    local set = utils.set_of(list)
    for _, val in ipairs(elements) do
        if set[val] ~= nil then
            return true
        end
    end
    return false
end

return utils
