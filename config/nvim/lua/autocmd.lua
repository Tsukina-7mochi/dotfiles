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

---@param buffer integer
---@param callback fun(args: string[] | nil)
---@param user_command { name: string, nargs: integer | string } | nil
---@param keymap { mode: string, key: string } | nil
local lsp_command_keymap = function(buffer, callback, user_command, keymap)
    if user_command ~= nil then
        vim.api.nvim_buf_create_user_command(buffer, user_command.name, function(opts)
            callback(opts.fargs)
        end, { nargs = user_command.nargs })
    end

    if keymap ~= nil then
        vim.api.nvim_buf_set_keymap(buffer, keymap.mode, keymap.key, "", {
            callback = callback
        })
    end
end

auto_tab_width({
    css = 2,
    html = 2,
    javascript = 2,
    json = 2,
    json5 = 2,
    jsonc = 2,
    lua = 4,
    markdown = 2,
    python = 4,
    scss = 2,
    typescript = 2,
})
