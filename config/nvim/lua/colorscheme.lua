local datastore = require("util/datastore")
local datastore_key = "colorscheme"

local initial_scheme = datastore[datastore_key]
if initial_scheme ~= nil then
    vim.cmd("colorscheme " .. initial_scheme)
end

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function ()
        local scheme_name = vim.g.colors_name
        datastore[datastore_key] = scheme_name
    end,
})
