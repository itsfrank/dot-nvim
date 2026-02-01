---@returns string[]
local function get_selection()
    local s = vim.fn.getpos("v") -- visual start
    local e = vim.fn.getpos(".") -- cursor
    local lines = vim.fn.getregion(s, e)
    return lines
end

return {
    "MagicDuck/grug-far.nvim",
    config = function()
        require("grug-far").setup({
            startInInsertMode = false,
            transient = true,
            prefills = {
                flags = "--ignore-case",
            },
            normalModeSearch = true,
            openTargetWindow = {
                preferredLocation = "prev",
            },
        })

        vim.keymap.set({ "n" }, "<leader>sp", function()
            require("grug-far").toggle_instance({ instanceName = "grug main" })
        end, { desc = "Toggle [S]earch [P]project - global find/replace" })

        vim.keymap.set({ "v" }, "<leader>sp", function()
            require("grug-far").toggle_instance({
                instanceName = "grug main",
                prefills = { search = table.concat(get_selection(), "\n") },
            })
        end, { desc = "Toggle [S]earch [P]project with visual selection - global find/replace" })
    end,
}
