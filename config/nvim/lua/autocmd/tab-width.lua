---@param tab_width table<string, number>
local set_auto_tab_width = function(tab_width)
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

set_auto_tab_width({
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
    typespec = 2,
})
