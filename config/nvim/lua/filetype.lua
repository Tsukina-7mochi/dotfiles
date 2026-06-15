local filetypes = {
    ejs = "javascript",
    cjs = "javascript",
    mjs = "javascript",
}

for extension, filetype in pairs(filetypes) do
    vim.api.nvim_create_autocmd("BufRead", {
        pattern = { "*." .. extension },
        callback = function ()
            vim.api.nvim_set_option_value("filetype", filetype, { buf = 0 })
        end,
    })
end
