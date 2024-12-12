if table.unpack == nil then
    table.unpack = unpack
end

---@param tab_width table<string, number>
local auto_tab_width = function(tab_width)
    for lang, width in pairs(tab_width) do
        vim.api.nvim_create_autocmd("FileType", {
            pattern = lang,
            callback = function()
                vim.opt_local.shiftwidth = width
                vim.opt_local.tabstop = width
            end
        })
    end
end

---@param filetypes table<string, string>
local auto_filetype = function(filetypes)
    for extension, filetype in pairs(filetypes) do
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = { "*." .. extension },
            callback = function()
                vim.api.nvim_set_option_value("filetype", filetype, { buf = 0 })
            end
        })
    end
end

auto_tab_width({
    css = 2,
    html = 2,
    javascript = 2,
    javascriptreact = 2,
    ["javascript.jsx"] = 2,
    json = 2,
    json5 = 2,
    jsonc = 2,
    lua = 4,
    markdown = 2,
    python = 4,
    scss = 2,
    typescript = 2,
    typescriptreact = 2,
    ["typescript.tsx"] = 2,
})

auto_filetype({
    ejs = "javascript",
    cjs = "javascript",
})
