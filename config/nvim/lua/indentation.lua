---@class IndentationOptions
---@field width integer
---@field use_space boolean

---@param opts IndentationOptions
local function set_indentation (opts)
    vim.opt_local.expandtab = opts.use_space
    vim.opt_local.tabstop = opts.width
    vim.opt_local.softtabstop = opts.width
    vim.opt_local.shiftwidth = opts.width
end

vim.api.nvim_create_user_command("UseTabIndent", function (cmd_opts)
    local width = tonumber(cmd_opts.fargs[1])
    if width ~= nil then
        set_indentation({ width = width, use_space = false })
    end
end, { nargs = 1 })

vim.api.nvim_create_user_command("UseSpaceIndent", function (cmd_opts)
    local width = tonumber(cmd_opts.fargs[1])
    if width ~= nil then
        set_indentation({ width = width, use_space = true })
    end
end, { nargs = 1 })

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function ()
        local lines = vim.api.nvim_buf_get_lines(0, 0, 100, false)
        for _, line in ipairs(lines) do
            if line:match("^(\t+)") then
                set_indentation({ width = 4, use_space = false })
                return
            end
            local spaces = line:match("^( +)%S")
            if spaces then
                set_indentation({ width = #spaces, use_space = true })
                return
            end
        end
    end,
})
