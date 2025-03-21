local to_integer = require("util.to-integer")

--Changes the tab width for the current buffer.
--
--Usage:
--  :TabWidth <width>
vim.api.nvim_create_user_command("TabWidth", function(opts)
    local width = to_integer(opts.fargs[1])
    if width == nil then
        print(opts.fargs[1] .. " is not a valid value as width")
        return
    end

    vim.opt_local.shiftwidth = width
    vim.opt_local.tabstop = width

    print("Tab width set to " .. width)
end, {
    nargs = 1
})
