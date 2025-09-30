local function create_rename_params(old_filename, new_filename)
    local old_uri = vim.uri_from_fname(old_filename)
    local new_uri = vim.uri_from_fname(new_filename)
    return {
        files = {
            {
                oldUri = old_uri,
                newUri = new_uri,
            }
        },
    }
end

---@param client vim.lsp.Client
---@param edit any
---@param old_filename string
---@param new_filename string
local function post_request_reame(client, edit, old_filename, new_filename)
    local rename_params = create_rename_params(old_filename, new_filename)

    if edit then
        vim.lsp.util.apply_workspace_edit(edit, "utf-8")
    end

    vim.fn.rename(old_filename, new_filename)

    vim.api.nvim_command("edit " .. new_filename)

    local success = client:notify("workspace/didRenameFiles", rename_params)
    if not success then
        vim.notify("Failed to notify language server of file rename", vim.log.levels.ERROR)
    end
end

---@param client vim.lsp.Client
---@param old_filename string
---@param new_filename string
local function request_rename(client, old_filename, new_filename)
    local rename_params = create_rename_params(old_filename, new_filename)

    vim.notify("Using " .. client.name, vim.log.levels.INFO)
    client:request("workspace/willRenameFiles", rename_params, function(err, result)
        if err then
            vim.notify("Error from language server: " .. err.message, vim.log.levels.ERROR)
            return
        end

        post_request_reame(client, result, old_filename, new_filename)
    end)
end

vim.api.nvim_create_user_command("RenameFile", function(opts)
    local old_filename = vim.api.nvim_buf_get_name(0)
    local new_filename = vim.fs.abspath(opts.fargs[1])

    local clients = vim.lsp.get_clients({ bufnr = 0, method = "workspace/willRenameFiles" })

    if #clients == 0 then
        vim.notify("No LSP clients support workspace/willRenameFiles", vim.log.levels.ERROR)
        return
    elseif #clients == 1 then
        request_rename(clients[1], old_filename, new_filename)
        return
    end

    vim.ui.select(clients, {
        prompt = "Select LSP client",
        format_item = function(item)
            return item.name
        end,
    }, function(client)
        if client then
            request_rename(client, old_filename, new_filename)
        end
    end)
end, {
    nargs = 1,
    complete = "file",
    desc = "Rename current file with integrated LSP support",
})
