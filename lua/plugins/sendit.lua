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

local function paste_text_to_pane(text)
    local tmux = require("sendit.tmux")
    local config = require("sendit").config

    tmux.select_pane(function(pane_id)
        vim.system({ "tmux", "set-buffer", text }, {}, function(set_result)
            if set_result.code ~= 0 then
                vim.schedule(function()
                    vim.notify("sendit: set-buffer failed: " .. (set_result.stderr or ""), vim.log.levels.ERROR)
                end)
                return
            end

            vim.system({ "tmux", "paste-buffer", "-p", "-r", "-d", "-t", pane_id }, {}, function(paste_result)
                if paste_result.code ~= 0 then
                    vim.schedule(function()
                        vim.notify("sendit: paste-buffer failed: " .. (paste_result.stderr or ""), vim.log.levels.ERROR)
                    end)
                    return
                end

                vim.defer_fn(function()
                    vim.system({ "tmux", "send-keys", "-t", pane_id, "Enter" }, {}, function(send_result)
                        vim.schedule(function()
                            if send_result.code ~= 0 then
                                vim.notify("sendit: send-keys failed: " .. (send_result.stderr or ""), vim.log.levels.ERROR)
                                return
                            end

                            if config.focus_after_send then
                                vim.system(tmux.focus_command(pane_id))
                            end
                            vim.notify("Sent to pane '" .. pane_id .. "'")
                        end)
                    end)
                end, 50)
            end)
        end)
    end)
end

local function send_prompt_with_context(opts)
    local prompt = table.concat(opts.fargs, " ")

    if prompt == "" then
        vim.notify("Usage: :Pr <prompt>", vim.log.levels.ERROR)
        return
    end

    local abs_path = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.getcwd()
    local lines = {
        prompt,
        "",
        "Context:",
        "- CWD: " .. cwd,
        "- File: " .. abs_path,
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

    paste_text_to_pane(table.concat(lines, "\n"))
end

return {
    "js/tmux-sendit.nvim",
    cmd = { "Sendit", "Pr" },
    keys = {
        { "<leader>a", group = "sendit", icon = "", desc = "sendit to tmux" },
        {
            "<leader>as",
            function()
                require("sendit").send_selection()
            end,
            mode = "v",
            desc = "Send selection to tmux pane",
        },
        {
            "<leader>af",
            function()
                require("sendit").send_rel_path()
            end,
            mode = { "n", "v" },
            desc = "Send relative file path to tmux pane",
        },
        {
            "<leader>aF",
            function()
                require("sendit").send_abs_path()
            end,
            mode = { "n", "v" },
            desc = "Send absolute file path to tmux pane",
        },
        {
            "<leader>ad",
            function()
                require("sendit").send_diagnostic()
            end,
            mode = { "n", "v" },
            desc = "Send diagnostics to tmux pane",
        },
    },
    config = function()
        require("sendit").setup({
            pane_scope = "window",
        })

        vim.api.nvim_create_user_command("Pr", send_prompt_with_context, {
            nargs = "+",
            desc = "Send a custom prompt with current file, cwd, and optional selection",
            range = true,
        })
    end,
}
