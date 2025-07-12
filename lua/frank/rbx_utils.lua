local plenary = require("plenary")
local m = {}

function m.is_rbx_lua_project(path)
    local found_rbxp = plenary.scandir.scan_dir(path, { depth = 1, search_pattern = ".*.rbxp", hidden = true })
    return #found_rbxp > 0 or m.is_rbx_game_engine(path)
end

function m.is_rbx_game_engine(path)
    return (string.find(path, "roblox/game-engine", 1, true) ~= nil)
        or (string.find(path, "roblox/ge-worktrees", 1, true) ~= nil)
end

return m
