local create_datastore = require("util/datastore")

local datastore = create_datastore("colorscheme")

local initial_scheme = datastore.get()
if initial_scheme ~= nil then
    vim.cmd("colorscheme " .. initial_scheme)
end

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function ()
        local schemeName = vim.g.colors_name
        datastore.set(schemeName)
    end,
})
