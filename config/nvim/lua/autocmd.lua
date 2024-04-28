local create_autocmd = vim.api.nvim_create_autocmd
local create_filetype_autocmd = function(pattern, callback)
    create_autocmd("FileType", { pattern=pattern, callback=callback })
end

-- language specific settings
create_filetype_autocmd("css", function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
end)

create_filetype_autocmd("html", function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
end)

create_filetype_autocmd("javascript", function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
end)

create_filetype_autocmd("json", function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
end)

create_filetype_autocmd("json5", function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
end)

create_filetype_autocmd("jsonc", function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
end)

create_filetype_autocmd("markdown", function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
end)

create_filetype_autocmd("python", function()
    local cfg_path = vim.fs.find({ "pyproject.toml" }, { upward = true })[1]
    if cfg_path == nil then return end
    local file = io.open(cfg_path)
    local content = file:read("a")
    file:close()

    -- assert the project is powered by rye
end)

create_filetype_autocmd("scss", function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
end)
