return {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    config = function ()
        require("gitsigns").setup()
    end,
    keys = {
        {
            "<leader>gb",
            ":Gitsigns blame_line<Return>",
            desc = "Git blame",
        },
        {
            "<leader>gd",
            ":Gitsigns preview_hunk_inline<Return>",
            desc = "Git diff inline",
        },
        {
            "<leader>gD",
            ":Gitsigns diffthis<Return>",
            desc = "Git diff",
        },
    },
}
