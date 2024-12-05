return {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
        require("lualine").setup {
            options = {
                icons_enabled = false,
                theme = "nord"
            },
        }
    end
}
