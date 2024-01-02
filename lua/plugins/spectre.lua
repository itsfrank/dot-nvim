return { -- cool search plugin kinda like vscodes global search
    "windwp/nvim-spectre",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
        vim.keymap.set(
            "n",
            "<leader>sp",
            require("spectre").toggle,
            { desc = "Toggle [S][P]ectre - project find/replace" }
        )
    end,
}
