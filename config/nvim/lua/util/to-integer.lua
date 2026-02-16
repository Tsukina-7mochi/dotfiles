---Converts a value to an integer if possible.
---@param value any
---@return integer | nil
local function to_integer (value)
    local number = tonumber(value)

    if type(number) ~= "number" or math.floor(number) ~= number then
        return nil
    end

    return number
end

return to_integer
