local M = {}
function M.put_guards()
    local path = vim.fn.expand("%:.")
    local guard_name = path:gsub("/", "_"):gsub("%.", "_")
    guard_name = guard_name:upper()
    vim.api.nvim_put({
        "#ifndef " .. guard_name,
        "#define " .. guard_name,
        "",
        "#endif // " .. guard_name,
    }, "c", true, true)
end

return M
