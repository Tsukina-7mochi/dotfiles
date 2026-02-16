return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    event = "BufRead",
    config = function ()
        require("nvim-treesitter").setup()
    end,
}
