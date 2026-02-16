vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function ()
        require("lualine").setup({
            options = {
                theme = "auto",
            },
        })
    end,
})
