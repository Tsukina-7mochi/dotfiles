vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function ()
        pcall(vim.treesitter.start)
    end,
})

vim.api.nvim_create_user_command("TSEnable", function ()
    vim.treesitter.start()
end, {
    desc = "Enable Treesitter highlighting",
})
