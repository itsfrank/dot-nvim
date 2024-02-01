vim.api.nvim_create_user_command("YankFileLine", function()
    local file = vim.fn.expand("%")
    local line = vim.fn.line(".")
    local cwd = vim.fn.getcwd()
    if file:match(cwd) then
        file = file.sub(file, cwd:len())
    end
    local str = file .. ":" .. line
    vim.fn.setreg('"', str)
    print("set reg to: " .. str)
end, {})
