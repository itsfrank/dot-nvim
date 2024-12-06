local m_buffer = {}

---turn bufnr to it's full number, 0 and nil become current bufers, other return number as-is
---@param bufnr number?
function m_buffer.full_bufnr(bufnr)
    if bufnr == nil or bufnr == 0 then
        return vim.api.nvim_get_current_buf()
    end
    return bufnr
end

---make buffer automatically close if the cursor leaves it
---@param bufnr number?
function m_buffer.del_on_leave(bufnr)
    bufnr = m_buffer.full_bufnr(bufnr)
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = bufnr,
        callback = function()
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(bufnr) then
                    vim.api.nvim_buf_delete(bufnr, { force = true })
                end
            end)
        end,
    })
end

---make buffer behave like I want my temp buffers to
---q to close, close on cursot leave, etc...
---@param bufnr any
function m_buffer.make_temp_buf(bufnr)
    bufnr = m_buffer.full_bufnr(bufnr)
    m_buffer.del_on_leave(bufnr)
    vim.keymap.set("n", "q", function()
        vim.api.nvim_buf_delete(bufnr, { force = true })
    end, { buffer = bufnr })
end

return m_buffer
