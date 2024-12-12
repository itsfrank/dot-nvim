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

local rbx_utils = require("frank.rbx_utils")
function utils.is_project_json_present(dir)
    local p_scandir = require("plenary.scandir")
    local found_rojo = p_scandir.scan_dir(dir, { depth = 1, search_pattern = ".*%.project%.json" })
    return #found_rojo > 0
end

function utils.is_luau_project(dir)
    local p_scandir = require("plenary.scandir")
    local found_rojo = utils.is_project_json_present(dir)
    local found_luaurc = p_scandir.scan_dir(dir, { depth = 1, search_pattern = ".luaurc", hidden = true })

    -- roblox engine repo paths
    local is_rbx_luau = rbx_utils.is_rbx_lua_project(dir)

    return found_rojo or #found_luaurc > 0 or is_rbx_luau
end

function utils.find_lune_defs()
    local semver = require("frank.utils.semver")
    local p_path = require("plenary.path")
    local p_scandir = require("plenary.scandir")

    local home = vim.fn.expand("~")
    local lune_path = p_path:new(home, ".lune/.typedefs")
    if not lune_path:is_dir() then
        return nil
    end
    local folders = p_scandir.scan_dir(lune_path.filename, { only_dirs = true, depth = 1 })
    local largest, largest_ver = nil, semver(0, 0, 0)

    for _, p in ipairs(folders) do
        local p = p_path:new(p)
        local parts = p:_split()
        local name = parts[#parts]
        local ver = semver(name)
        if ver > largest_ver then
            largest = p:absolute()
            largest_ver = ver
        end
    end
    return largest
end

---removes duplicate elements in a list
---@generic T
---@param l T[]
---@return T[]
function utils.remove_duplicates(l)
    local map = {}
    local ret = {}
    for _, v in ipairs(l) do
        if map[v] == nil then
            map[v] = true
            table.insert(ret, v)
        end
    end
    return ret
end

function utils.read_luaurc_aliases(dir)
    local p = require("plenary.path")
    local luaurc_path = p:new(dir, ".luaurc")
    if not luaurc_path:exists() then
        return nil
    end

    local luaurc_data = luaurc_path:read()
    local luaurc = vim.json.decode(luaurc_data)

    if luaurc == nil or luaurc["aliases"] == nil then
        return nil
    end
    if type(luaurc["aliases"]) ~= "table" then
        return nil
    end

    local aliases = luaurc["aliases"]
    local ret = {}
    for k, v in pairs(aliases) do
        ret["@" .. k] = v
    end
    return ret
end

return utils
