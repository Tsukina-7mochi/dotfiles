---@param width integer
---@param use_space boolean
local function set_indentation (width, use_space)
    vim.opt_local.expandtab = use_space
    vim.opt_local.tabstop = width
    vim.opt_local.softtabstop = width
    vim.opt_local.shiftwidth = width
end

vim.api.nvim_create_user_command("UseTabIndent", function (opts)
    local width = tonumber(opts.fargs[1])
    if width ~= nil then
        set_indentation(width, false)
    end
end, { nargs = 1 })

vim.api.nvim_create_user_command("UseSpaceIndent", function (opts)
    local width = tonumber(opts.fargs[1])
    if width ~= nil then
        set_indentation(width, false)
    end
end, { nargs = 1 })

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function ()
        local lines = vim.api.nvim_buf_get_lines(0, 0, 100, false)
        for _, line in ipairs(lines) do
            if line:match("^(\t+)") then
                set_indentation(4, false)
                return
            end
            local spaces = line:match("^( +)%S")
            if spaces then
                set_indentation(#spaces, false)
                return
            end
        end
    end,
})
