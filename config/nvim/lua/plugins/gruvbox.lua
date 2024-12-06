return {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    priority = 1000,
    event = "VimEnter",
    config = function()
        require("gruvbox").setup({})
    end
}
