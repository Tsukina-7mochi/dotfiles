return {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    config = function ()
        require("gitsigns").setup()
    end,
    keys = {
        {
            "<leader>gn",
            ":Gitsigns next_hunk<Return>",
            desc = "Git next hunk",
        },
        {
            "<leader>gb",
            ":Gitsigns prev_hunk<Return>",
            desc = "Git previous hunk",
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
        {
            "<leader>gB",
            ":Gitsigns blame_line<Return>",
            desc = "Git blame",
        },
    },
}
