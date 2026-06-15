local filename = vim.fs.joinpath(vim.fn.stdpath("data"), "user.json")
local datastore = {}

---@type any
local cached_config = nil
local function get_config ()
    if cached_config ~= nil then
        return cached_config
    end

    local file = io.open(filename, "r")
    if file == nil then
        cached_config = {}
        return cached_config
    end

    cached_config = vim.json.decode(file:read("*a"))
    file:close()
    return cached_config
end

local function write_config ()
    if cached_config == nil then
        return
    end

    local file, errmsg = io.open(filename, "w")
    if file == nil then
        error("Failed to open user config file: " .. errmsg)
    end

    file:write(vim.json.encode(cached_config))
    file:close()
end

setmetatable(datastore, {
    __index = function (_, key)
        local config = get_config()
        return config[key]
    end,
    __newindex = function (_, key, value)
        local config = get_config()
        config[key] = value
        write_config()
    end,
})

return datastore
