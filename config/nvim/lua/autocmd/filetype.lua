---@param filetypes table<string, string>
local set_auto_filetype = function (filetypes)
    for extension, filetype in pairs(filetypes) do
        vim.api.nvim_create_autocmd("BufRead", {
            pattern = { "*." .. extension },
            callback = function ()
                vim.api.nvim_set_option_value("filetype", filetype, { buf = 0 })
            end,
        })
    end
end

set_auto_filetype({
    ejs = "javascript",
    cjs = "javascript",
})
