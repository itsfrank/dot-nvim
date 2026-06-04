local tmux = require("frank.tmux")

local function get_selection_from_range(range)
  if range == 0 then
    return nil
  end

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getregion(start_pos, end_pos, { type = vim.fn.visualmode() })
  if not lines or vim.tbl_isempty(lines) then
    return nil
  end

  return table.concat(lines, "\n")
end

local function get_target_pane()
  local window = tmux.current_window()
  local panes = tmux.panes(window)

  if #panes ~= 2 then
    error("expected exactly 2 panes in current window, found " .. #panes, 2)
  end

  local current = tmux.current_pane()
  for _, pane in ipairs(panes) do
    if pane.id ~= current then
      return pane.id
    end
  end
end

local function send_prompt(opts)
  local prompt = table.concat(opts.fargs, " ")
  if prompt == "" then
    vim.notify("Usage: :P <prompt>", vim.log.levels.ERROR)
    return
  end

  local abs_path = vim.api.nvim_buf_get_name(0)
  local cwd = vim.fn.getcwd()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lines = {
    prompt,
    "",
    "Context:",
    "- CWD: " .. cwd,
    "- File: " .. abs_path,
    "- Cursor: Line " .. cursor[1] .. ", Col " .. cursor[2],
  }

  local selection = get_selection_from_range(opts.range)
  if selection and selection ~= "" then
    vim.list_extend(lines, {
      "",
      "Selection:",
      "```",
    })
    vim.list_extend(lines, vim.split(selection, "\n", { plain = true }))
    table.insert(lines, "```")
  end

  local target = get_target_pane()
  tmux.send_text(target, table.concat(lines, "\n"))
  vim.notify("Sent to pane " .. target)
end

vim.api.nvim_create_user_command("P", send_prompt, {
  nargs = "+",
  desc = "Send prompt with context to the other tmux pane",
  range = true,
})
