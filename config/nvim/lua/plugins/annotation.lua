return {
    "Tsukina-7mochi/annotation-nvim",
    -- dir = "~/workspace/annotation-nvim",
    event = "BufEnter",
    config = function ()
        require("annotation").setup()
    end,
    keys = {
        {
            "<leader>aa",
            function ()
                require("annotation").annotate()
            end,
            mode = { "n", "v" },
        },
    },
}
