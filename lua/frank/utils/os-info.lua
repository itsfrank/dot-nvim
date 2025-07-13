local sysname = vim.loop.os_uname().sysname

local module = {
    sysname = vim.loop.os_uname().sysname,
}

function module:is_windows()
    return self.sysname:find("Windows") and true or false
end

function module:is_mac()
    return self.sysname == "Darwin"
end

function module:is_linux()
    return self.sysname == "Linux"
end

function module.is_work_laptop()
    return vim.fn.environ()["IS_WORK_LAPTOP"] == "true"
end

return module
