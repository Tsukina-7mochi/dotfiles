---@param scheme_name string
local function create_datastore (scheme_name)
    local filename = vim.fs.joinpath(vim.fn.stdpath("data"), scheme_name)

    return {
        ---@return string | nil
        get = function ()
            local file = io.open(filename, "r")
            if file == nil then
                return nil
            end
            return file:read("*a")
        end,

        ---@param value string
        set = function (value)
            local file = io.open(filename, "w")
            if file == nil then
                error("failed to open " .. filename)
            end

            file:write(value)
            file:close()
        end,
    }
end

return create_datastore
