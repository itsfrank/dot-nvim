local utils = {}

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

return utils
