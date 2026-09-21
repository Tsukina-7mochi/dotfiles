return {
    "Tsukina-7mochi/quick-note.nvim",
    event = "BufEnter",
    config = function ()
        require("quick-note").setup()
    end,
    keys = {
        {
            "<leader>nn",
            ":Note<Return>",
        },
        {
            "<leader>ne",
            ":NoteEdit<Return>",
        },
    },
}
