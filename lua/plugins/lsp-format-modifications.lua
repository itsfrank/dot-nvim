return {
    -- format git changes only
    "joechrisellis/lsp-format-modifications.nvim",
    config = function()
        vim.g.lsp_format_modifications_silence = true
    end,
}
