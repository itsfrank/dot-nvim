-- this is a basic wrapper around snacks.picker that makes it synchronous from a coroutine
-- you probably can't do 100% of that snack.picker offers wrt actions, but it's god enough for me for now

local async = require("frank.utils.async")
local picker = require("snacks.picker")

local M = {}

--- Pick async, must be called from a coroutine or async.block
---@param opts_in snacks.picker.Config
function M.pick_async(opts_in)
    ---@diagnostic disable: redefined-local
    local function pick_cb(opts_in, cb)
        local picked = nil
        local opts = vim.deepcopy(opts_in)
        opts.confirm = function(picker, item)
            picked = item
            if opts_in.confirm then
                opts_in.confirm(picker, item)
            end
            picker:close()
        end
        opts.on_close = function(picker)
            if opts_in.on_close then
                opts_in.on_close(picker)
            end
            cb(picked)
        end
        picker.pick(opts)
    end

    return async.wrap(pick_cb)(opts_in)
end

function M.fuzzy_oil()
    local find_command = {
        "fd",
        "--type",
        "d",
        "--color",
        "never",
    }

    vim.fn.jobstart(find_command, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                local filtered = vim.tbl_filter(function(el)
                    return el ~= ""
                end, data)

                local items = {}
                for _, v in ipairs(filtered) do
                    local path = vim.fs.normalize(v)
                    table.insert(items, {
                        text = path,
                        file = path,
                        prefix = vim.fs.dirname(path),
                        folder = vim.fs.basename(path),
                    })
                end

                ---@module 'snacks'
                Snacks.picker.pick({
                    source = "directories",
                    items = items,
                    format = function(item)
                        return {
                            { " ", "SnacksNormal" },
                            { item.prefix .. "/", "SnacksPickerDir" },
                            { item.folder, "SnacksNormal" },
                        }
                    end,
                    confirm = function(picker, item)
                        picker:close()
                        vim.cmd("Oil " .. item.text)
                    end,
                })
            end
        end,
    })
end



return M
