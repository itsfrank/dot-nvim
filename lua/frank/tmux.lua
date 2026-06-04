local M = {}

--- Check if we're running inside tmux
---@return boolean
function M.is_active()
  return vim.env.TMUX ~= nil
end

--- Assert that we're in tmux, error if not
local function assert_tmux()
  if not M.is_active() then
    error("not in a tmux session", 3)
  end
end

--- Get the pane ID that nvim is running in
---@return string pane_id e.g. "%0"
function M.current_pane()
  assert_tmux()
  return vim.env.TMUX_PANE
end

--- Get the current window ID
---@return string window_id e.g. "@0"
function M.current_window()
  assert_tmux()
  local result = vim.fn.system("tmux display-message -p '#{window_id}'")
  return vim.trim(result)
end

--- List panes in a given window
---@param window_id string e.g. "@0"
---@return { id: string, index: number, active: boolean }[]
function M.panes(window_id)
  assert_tmux()
  local cmd = string.format(
    "tmux list-panes -t %s -F '#{pane_id}:#{pane_index}:#{pane_active}:#{pane_current_command}'",
    window_id
  )
  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    error("tmux list-panes failed: " .. vim.trim(result), 2)
  end

  local panes = {}
  for line in vim.gsplit(vim.trim(result), "\n") do
    local id, index, active, current_command = line:match("^(%%[^:]+):(%d+):(%d+):(.+)$")
    if id then
      table.insert(panes, {
        id = id,
        index = tonumber(index),
        active = active == "1",
        current_command = current_command,
      })
    end
  end
  return panes
end

--- Send keys to a pane
---@param pane_id string e.g. "%0"
---@param keys string e.g. "Enter", "C-c"
function M.send_keys(pane_id, keys)
  assert_tmux()
  local result = vim.fn.system({ "tmux", "send-keys", "-t", pane_id, keys })
  if vim.v.shell_error ~= 0 then
    error("tmux send-keys failed: " .. vim.trim(result), 2)
  end
end

--- Send text to a pane (set-buffer → paste-buffer → Enter)
---@param pane_id string e.g. "%0"
---@param text string text to send
function M.send_text(pane_id, text)
  assert_tmux()

  local result = vim.fn.system({ "tmux", "set-buffer", text })
  if vim.v.shell_error ~= 0 then
    error("tmux set-buffer failed: " .. vim.trim(result), 2)
  end

  result = vim.fn.system({ "tmux", "paste-buffer", "-p", "-r", "-d", "-t", pane_id })
  if vim.v.shell_error ~= 0 then
    error("tmux paste-buffer failed: " .. vim.trim(result), 2)
  end

  vim.defer_fn(function()
    M.send_keys(pane_id, "Enter")
  end, 50)
end

--- Focus a pane
---@param pane_id string e.g. "%0"
function M.focus_pane(pane_id)
  assert_tmux()
  local result = vim.fn.system({ "tmux", "select-pane", "-t", pane_id })
  if vim.v.shell_error ~= 0 then
    error("tmux select-pane failed: " .. vim.trim(result), 2)
  end
end

return M
