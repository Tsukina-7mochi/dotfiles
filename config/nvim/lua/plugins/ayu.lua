return {
    "Shatur/neovim-ayu",
    name = "ayu",
    priority = 1000,
    event = "VimEnter",
    config = function()
        require("ayu").setup({
            mirage = true,
        })
    end
}
