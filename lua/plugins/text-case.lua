return {
    "johmsalas/text-case.nvim",
    config = function()
        require("textcase").setup({
            default_keymappings_enabled = false,
        })

        local methods = {
            "to_upper_case",
            "to_lower_case",
            "to_snake_case",
            "to_dash_case",
            "to_title_dash_case",
            "to_constant_case",
            "to_dot_case",
            "to_phrase_case",
            "to_camel_case",
            "to_pascal_case",
            "to_title_case",
            "to_path_case",
            "to_upper_phrase_case",
            "to_lower_phrase_case",
        }

        vim.api.nvim_create_user_command("Textcase", function(opts)
            local method = opts.args
            if vim.tbl_contains(methods, method) then
                vim.cmd("lua require('textcase').current_word('" .. method .. "')")
            else
                print("Invalid method: " .. method)
            end
        end, {
            nargs = 1,
            complete = function(ArgLead, _, _)
                return vim.tbl_filter(function(method)
                    return string.find(method, ArgLead) == 1
                end, methods)
            end,
        })
    end,
}
