-- from https://www.reddit.com/r/neovim/comments/qco76a/way_to_increase_decrease_brightness_of_selected/
local fmt = string.format

local colors = {}

function colors.get_color_from_hl(name)
    local result = {}
    for k, v in pairs(vim.api.nvim_get_hl_by_name(name, true)) do
        result[k] = fmt("#%06x", v)
    end
    return result
end

function colors.to_rgb(color)
    return tonumber(color:sub(2, 3), 16), tonumber(color:sub(4, 5), 16), tonumber(color:sub(6), 16)
end

function colors.clamp_color(color)
    return math.max(math.min(color, 255), 0)
end

-- https://stackoverflow.com/a/13532993
function colors.brighten(color, percent)
    local r, g, b = colors.to_rgb(color)
    r = colors.clamp_color(math.floor(tonumber(r * (100 + percent) / 100)))
    g = colors.clamp_color(math.floor(tonumber(g * (100 + percent) / 100)))
    b = colors.clamp_color(math.floor(tonumber(b * (100 + percent) / 100)))

    local rh = fmt("%0x", r)
    local gh = fmt("%0x", g)
    local bh = fmt("%0x", b)

    local function add_zeros(s)
        if #s >= 2 then
            return s
        end
        if #s == 1 then
            return "0" .. s
        end
        return "00"
    end

    return "#" .. add_zeros(fmt("%0x", r)) .. add_zeros(fmt("%0x", g)) .. add_zeros(fmt("%0x", b))
end

function colors.highlight(group, color)
    local style = color.style and "gui=" .. color.style or "gui=NONE"
    local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
    local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
    local sp = color.sp and "guisp=" .. color.sp or ""
    local hl = "highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp
    vim.cmd(hl)
end

-- function usage()
-- 	local normal = get_color_from_hl("Normal")
-- 	local darkbg = brighten(normal.background, -10) -- darken by 10%
--
-- 	local groups = {
-- 		DarkerBackground = { bg = darkbg },
-- 	}
--
-- 	for name, values in pairs(groups) do
-- 		highlight(name, values)
-- 	end
-- end

return colors
