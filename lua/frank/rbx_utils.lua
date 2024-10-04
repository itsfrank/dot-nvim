local plenary = require("plenary")
local m = {}

function m.is_rbx_lua_project(path)
    local found_rbxp = plenary.scandir.scan_dir(path, { depth = 1, search_pattern = ".*%.rbxp", hidden = true })
    local is_rbx = (string.find(path, "roblox/game-engine", 1, true) ~= nil)
        or (string.find(path, "roblox/ge-worktrees", 1, true) ~= nil)
    return #found_rbxp > 0 or is_rbx
end

return m
