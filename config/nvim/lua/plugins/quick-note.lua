return {
    "Tsukina-7mochi/quick-note.nvim",
    event = "BufEnter",
    config = function ()
        require("quick-note").setup()
    end,
    keys = {
        {
            "<leader>mm",
            ":Note<Return>",
        },
        {
            "<leader>mo",
            ":NoteEdit<Return>",
        },
    },
}
