vim.api.nvim_create_user_command("UseTabIndent", function (opts)
    local width = tonumber(opts.fargs[1])
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = width
    vim.opt_local.softtabstop = width
    vim.opt_local.shiftwidth = width
end, { nargs = 1 })

vim.api.nvim_create_user_command("UseSpaceIndent", function (opts)
    local width = tonumber(opts.fargs[1])
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = width
    vim.opt_local.softtabstop = width
    vim.opt_local.shiftwidth = width
end, { nargs = 1 })
